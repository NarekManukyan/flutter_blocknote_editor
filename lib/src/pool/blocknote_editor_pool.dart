/// Singleton pool for pre-warming BlockNote WebView instances.
///
/// Pre-initializes a [HeadlessInAppWebView] with the editor page and JS bridge
/// loaded, so subsequent editor instances can display instantly without loading
/// delay. The React/BlockNote.js editor may still be initializing; the widget
/// handles that by listening for the "ready" signal.
///
/// Usage:
/// ```dart
/// // At app startup (optional but recommended):
/// await BlockNoteEditorPool.instance.warmup();
///
/// // Then use BlockNoteEditor as usual - it automatically uses the pool:
/// BlockNoteEditor(initialDocument: doc, ...)
/// ```
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../widget/asset_loader.dart';
import '../widget/webview_config.dart';
import '../widget/webview_initializer.dart';

/// A pre-warmed WebView entry ready for use.
class BlockNotePoolEntry {
  /// Creates a new pool entry.
  BlockNotePoolEntry({
    required this.headlessWebView,
    required this.controller,
    required this.assetLoader,
    required this.assetUrl,
  });

  /// The pre-initialized headless WebView.
  final HeadlessInAppWebView headlessWebView;

  /// The WebView controller.
  final InAppWebViewController controller;

  /// The asset loader (owns the temp directory).
  final BlockNoteAssetLoader? assetLoader;

  /// The URL used to load the editor assets.
  final String assetUrl;

  /// Mutable delegate for routing raw JS messages from the WebView.
  ///
  /// Set by the [BlockNoteEditor] widget when it claims this entry.
  void Function(String)? onRawJsMessage;

  /// Mutable delegate for routing console messages from the WebView.
  ///
  /// Set by the [BlockNoteEditor] widget when it claims this entry.
  void Function(String)? onConsoleMessage;
}

/// Singleton pool that pre-warms BlockNote WebView instances.
///
/// Call [warmup] to pre-initialize a WebView with the editor page loaded.
/// When a [BlockNoteEditor] widget is created, it automatically checks
/// this pool for a warm entry, making the editor appear instantly.
///
/// After an entry is consumed, the pool automatically starts warming
/// a new one in the background for the next use.
class BlockNoteEditorPool {
  BlockNoteEditorPool._();

  /// The singleton instance.
  static final BlockNoteEditorPool instance = BlockNoteEditorPool._();

  BlockNotePoolEntry? _warmEntry;
  bool _isReady = false;
  Completer<void>? _warmupCompleter;
  bool _isWarming = false;

  // Stored config for re-warming after consumption.
  String? _localhostUrl;
  bool _debugLogging = false;
  Duration _warmupTimeout = const Duration(seconds: 30);

  /// Whether a warm entry is available for immediate use.
  bool get hasWarmEntry => _warmEntry != null && _isReady;

  /// Whether the pool is currently warming up an entry.
  bool get isWarming => _isWarming;

  /// Pre-warms a WebView instance with the editor page and JS bridge loaded.
  ///
  /// This copies assets, creates a [HeadlessInAppWebView], loads the editor
  /// HTML page, and sets up the JS bridge. The React/BlockNote.js editor may
  /// still be initializing when this completes — that's OK; the widget handles
  /// the "ready" signal.
  ///
  /// Safe to call multiple times — subsequent calls return the same future
  /// if warmup is already in progress.
  Future<void> warmup({
    String? localhostUrl,
    bool debugLogging = false,
    Duration warmupTimeout = const Duration(seconds: 30),
  }) async {
    // Store config for re-warming.
    _localhostUrl = localhostUrl;
    _debugLogging = debugLogging;
    _warmupTimeout = warmupTimeout;

    // If already warming or warm, return existing future.
    if (_isWarming && _warmupCompleter != null) {
      return _warmupCompleter!.future;
    }
    if (_isReady && _warmEntry != null) {
      return;
    }

    _isWarming = true;
    _warmupCompleter = Completer<void>();

    try {
      if (debugLogging) {
        debugPrint('[BlockNoteEditorPool] Starting warmup...');
      }

      // Initialize assets.
      final result = await WebViewInitializer.initialize(
        localhostUrl: localhostUrl,
        debugLogging: debugLogging,
      );

      // Create headless WebView.
      late final InAppWebViewController warmController;
      final pageLoadCompleter = Completer<void>();

      final headless = HeadlessInAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(result.url)),
        initialSettings: WebViewConfig.getDefaultSettings(
          allowingReadAccessTo:
              result.assetLoader?.tempDirPath != null
                  ? WebUri(
                    Uri.directory(result.assetLoader!.tempDirPath!).toString(),
                  )
                  : null,
        ),
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          // Allow all navigation during warmup — the page must load.
          return NavigationActionPolicy.ALLOW;
        },
        onWebViewCreated: (controller) {
          warmController = controller;

          // Set up placeholder JS handlers. The claiming widget will replace
          // these with its own via addJavaScriptHandler (which replaces by name).
          controller.addJavaScriptHandler(
            handlerName: 'onMessage',
            callback: (args) => null,
          );
          controller.addJavaScriptHandler(
            handlerName: 'flutterConsole',
            callback: (args) {
              if (args.isNotEmpty && debugLogging) {
                debugPrint('[BlockNoteEditorPool] JS: ${args[0]}');
              }
              return null;
            },
          );
        },
        onLoadStop: (controller, url) async {
          if (debugLogging) {
            debugPrint('[BlockNoteEditorPool] Page loaded: $url');
          }
          // Inject JS bridge objects so the React app can communicate.
          await WebViewConfig.setupJavaScriptBridge(
            controller: controller,
            debugLogging: debugLogging,
          );
          if (!pageLoadCompleter.isCompleted) {
            pageLoadCompleter.complete();
          }
        },
      );

      // Start the headless WebView.
      await headless.run();

      // Wait for the page to fully load and the JS bridge to be set up.
      // We do NOT wait for the React/BlockNote "ready" signal here — that
      // can take 15+ seconds in headless mode. The widget will handle it.
      await pageLoadCompleter.future.timeout(
        _warmupTimeout,
        onTimeout: () {
          if (debugLogging) {
            debugPrint(
              '[BlockNoteEditorPool] Warmup timed out waiting for page load',
            );
          }
          throw TimeoutException('Page load timed out');
        },
      );

      // Store the warm entry.
      _warmEntry = BlockNotePoolEntry(
        headlessWebView: headless,
        controller: warmController,
        assetLoader: result.assetLoader,
        assetUrl: result.url,
      );
      _isReady = true;
      _isWarming = false;

      if (debugLogging) {
        debugPrint('[BlockNoteEditorPool] Warmup complete - entry ready');
      }

      if (!_warmupCompleter!.isCompleted) {
        _warmupCompleter!.complete();
      }
    } catch (e) {
      _isWarming = false;
      if (debugLogging) {
        debugPrint('[BlockNoteEditorPool] Warmup failed: $e');
      }
      if (_warmupCompleter != null && !_warmupCompleter!.isCompleted) {
        _warmupCompleter!.completeError(e);
      }
    }
  }

  /// Acquires a pre-warmed entry from the pool.
  ///
  /// Returns `null` if no warm entry is available. After acquisition,
  /// the pool automatically starts warming a new entry in the background.
  ///
  /// The caller is responsible for the entry's lifecycle. The entry's
  /// [HeadlessInAppWebView] should be passed to `InAppWebView(headlessWebView:)`
  /// for display.
  BlockNotePoolEntry? acquire() {
    if (!_isReady || _warmEntry == null) {
      return null;
    }

    final entry = _warmEntry;
    _warmEntry = null;
    _isReady = false;
    _warmupCompleter = null;

    if (_debugLogging) {
      debugPrint('[BlockNoteEditorPool] Entry acquired - starting re-warmup');
    }

    // Re-warm in background for next use.
    _rewarmInBackground();

    return entry;
  }

  /// Starts re-warming a new entry in the background.
  void _rewarmInBackground() {
    // Schedule on next microtask to avoid blocking the current frame.
    Future.microtask(() {
      warmup(
        localhostUrl: _localhostUrl,
        debugLogging: _debugLogging,
      );
    });
  }

  /// Disposes of the pool and any warm entries.
  ///
  /// Call this when the app no longer needs editor pooling.
  Future<void> dispose() async {
    if (_warmEntry != null) {
      await _warmEntry!.headlessWebView.dispose();
      await _warmEntry!.assetLoader?.dispose();
      _warmEntry = null;
    }
    _isReady = false;
    _isWarming = false;
    _warmupCompleter = null;

    if (_debugLogging) {
      debugPrint('[BlockNoteEditorPool] Pool disposed');
    }
  }
}
