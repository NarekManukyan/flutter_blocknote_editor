/// Singleton pool for pre-warming BlockNote WebView instances.
///
/// Pre-initializes a [HeadlessInAppWebView] with BlockNote.js fully loaded,
/// so subsequent editor instances can display instantly without loading delay.
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
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../widget/asset_loader.dart';
import '../widget/webview_config.dart';
import '../widget/webview_initializer.dart';

/// A pre-warmed WebView entry ready for use.
class PoolEntry {
  /// Creates a new pool entry.
  PoolEntry({
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
  final AssetLoader? assetLoader;

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
/// Call [warmup] to pre-initialize a WebView with BlockNote.js loaded.
/// When a [BlockNoteEditor] widget is created, it automatically checks
/// this pool for a warm entry, making the editor appear instantly.
///
/// After an entry is consumed, the pool automatically starts warming
/// a new one in the background for the next use.
class BlockNoteEditorPool {
  BlockNoteEditorPool._();

  /// The singleton instance.
  static final BlockNoteEditorPool instance = BlockNoteEditorPool._();

  PoolEntry? _warmEntry;
  bool _isReady = false;
  Completer<void>? _warmupCompleter;
  bool _isWarming = false;

  // Stored config for re-warming after consumption.
  String? _localhostUrl;
  bool _debugLogging = false;

  /// Whether a warm entry is available for immediate use.
  bool get hasWarmEntry => _warmEntry != null && _isReady;

  /// Whether the pool is currently warming up an entry.
  bool get isWarming => _isWarming;

  /// Pre-warms a WebView instance with BlockNote.js fully initialized.
  ///
  /// This copies assets, creates a [HeadlessInAppWebView], loads the editor
  /// HTML/JS, and waits for the BlockNote "ready" signal. After this completes,
  /// the next [BlockNoteEditor] widget will display instantly.
  ///
  /// Safe to call multiple times - subsequent calls return the same future
  /// if warmup is already in progress.
  Future<void> warmup({
    String? localhostUrl,
    bool debugLogging = false,
  }) async {
    // Store config for re-warming.
    _localhostUrl = localhostUrl;
    _debugLogging = debugLogging;

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
      final readyCompleter = Completer<void>();

      // Temporary raw message handler to detect the "ready" signal.
      void Function(String)? tempRawMessageHandler;

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
          // Allow all navigation during warmup - the page must load.
          return NavigationActionPolicy.ALLOW;
        },
        onWebViewCreated: (controller) {
          warmController = controller;

          // Set up JS handlers with mutable delegates.
          controller.addJavaScriptHandler(
            handlerName: 'onMessage',
            callback: (args) {
              if (args.isNotEmpty) {
                final msg = args[0].toString();
                tempRawMessageHandler?.call(msg);
              }
              return null;
            },
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
          // Inject JS bridge objects.
          await WebViewConfig.setupJavaScriptBridge(
            controller: controller,
            debugLogging: debugLogging,
          );
        },
      );

      // Listen for "ready" message from BlockNote.js.
      tempRawMessageHandler = (message) {
        try {
          final json = jsonDecode(message) as Map<String, dynamic>;
          if (json['type'] == 'ready' && !readyCompleter.isCompleted) {
            if (debugLogging) {
              debugPrint(
                '[BlockNoteEditorPool] Editor ready signal received',
              );
            }
            readyCompleter.complete();
          }
        } catch (_) {
          // Ignore parse errors during warmup.
        }
      };

      // Start the headless WebView.
      await headless.run();

      // Wait for BlockNote.js to initialize (with timeout).
      await readyCompleter.future.timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          if (debugLogging) {
            debugPrint(
              '[BlockNoteEditorPool] Warmup timed out waiting for ready signal',
            );
          }
        },
      );

      // Clear temp handler - the claiming widget will set its own.
      tempRawMessageHandler = null;

      // Store the warm entry.
      _warmEntry = PoolEntry(
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
  PoolEntry? acquire() {
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
