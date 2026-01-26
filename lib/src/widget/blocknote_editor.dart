/// BlockNote editor widget for Flutter.
///
/// This widget embeds BlockNoteJS inside a WebView and provides a clean
/// Dart API for embedding BlockNote editors in Flutter apps. It handles
/// bidirectional communication, transaction batching, and undo/redo safety.
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../model/blocknote_document.dart';
import '../model/blocknote_transaction.dart';
import '../model/blocknote_theme.dart';
import '../model/blocknote_toolbar_config.dart';
import '../model/blocknote_slash_command.dart';
import '../bridge/js_bridge.dart';
import '../bridge/message_types.dart';
import 'blocknote_controller.dart';
import '../batching/transaction_batcher.dart';
import 'asset_server.dart';
import 'webview_initializer.dart';
import 'document_loader.dart';
import 'message_handlers.dart';
import 'toolbar_popup_handler.dart';
import 'webview_config.dart';
import 'webview_height_manager.dart';
import 'css_utils.dart';

/// BlockNote editor widget.
///
/// Embeds BlockNoteJS inside a WebView and provides bidirectional
/// communication with transaction batching. The widget is fully isolated
/// from app-specific logic and supports iOS and Android.
///
/// **Undo/Redo Safety Rules:**
///
/// 1. Undo/redo operations are NEVER triggered from Flutter. They remain
///    entirely within the JavaScript BlockNote editor.
///
/// 2. Flutter NEVER re-applies transactions into the editor. Once a
///    transaction is emitted from JavaScript, it is considered final.
///
/// 3. On reload: load the full document, reset the editor once, then resume
///    streaming transactions. This ensures undo/redo history is preserved.
class BlockNoteEditor extends StatefulWidget {
  /// Creates a new BlockNote editor widget.
  const BlockNoteEditor({
    required this.initialDocument,
    this.onTransactions,
    this.onReady,
    this.readOnly = false,
    this.debugLogging = false,
    this.localhostUrl,
    this.theme,
    this.toolbarConfig,
    this.slashCommandConfig,
    this.schemaConfig,
    this.schemaConfigs,
    this.activeSchemaId,
    this.customJavaScript,
    this.customJavaScriptAssetPaths,
    this.customCss,
    this.customCssAssetPaths,
    this.onToolbarPopupRequest,
    this.transactionDebounceDuration,
    this.onLinkTapped,
    super.key,
  });

  /// The initial document to load into the editor.
  final BlockNoteDocument initialDocument;

  /// Callback invoked when new transactions are available.
  ///
  /// Transactions are batched and sent periodically (default 400ms window)
  /// to prevent excessive Flutter rebuilds. They are also flushed immediately
  /// on critical operations (paste, delete block, etc.).
  final ValueChanged<List<BlockNoteTransaction>>? onTransactions;

  /// Callback invoked when the editor is ready and initialized.
  ///
  /// The controller provides programmatic access to the editor, including
  /// methods to get the full document, set configuration, and load documents.
  final ValueChanged<BlockNoteController>? onReady;

  /// Callback invoked when a toolbar popup is clicked.
  ///
  /// Returns the selected value, or null if cancelled.
  /// The popupType indicates the type of popup (e.g., 'colorStyle', 'blockTypeSelect').
  /// The options list contains available choices for the popup.
  final Future<dynamic> Function(
    String popupType,
    List<Map<String, dynamic>> options,
  )?
  onToolbarPopupRequest;

  /// Callback invoked when a link is tapped in the editor.
  ///
  /// The URL of the tapped link is passed as a parameter.
  /// Use this to handle link navigation (e.g., using `url_launcher`).
  final ValueChanged<String>? onLinkTapped;

  /// Whether the editor should be in read-only mode.
  final bool readOnly;

  /// Whether to enable debug logging.
  final bool debugLogging;

  /// Localhost URL for serving built assets (e.g., 'http://localhost:4173').
  /// If null, uses bundled assets from package.
  /// Set this to use Vite preview server or custom HTTP server.
  final String? localhostUrl;

  /// Theme configuration for customizing editor colors, fonts, and styling.
  final BlockNoteTheme? theme;

  /// Toolbar configuration for customizing formatting toolbar buttons.
  final BlockNoteToolbarConfig? toolbarConfig;

  /// Slash command configuration for customizing slash menu items.
  final BlockNoteSlashCommandConfig? slashCommandConfig;

  /// Schema configuration for enabling custom blocks, inline content, or styles.
  final Map<String, dynamic>? schemaConfig;

  /// Schema configurations keyed by an identifier.
  ///
  /// Use [activeSchemaId] to select which schema config to apply.
  final Map<String, Map<String, dynamic>>? schemaConfigs;

  /// Active schema identifier used with [schemaConfigs].
  final String? activeSchemaId;

  /// Custom JavaScript to run in the editor context.
  ///
  /// Use this to register custom BlockNote blocks or schema extensions
  /// without forking the web editor bundle.
  final String? customJavaScript;

  /// Asset paths containing custom JavaScript to load into the editor context.
  final List<String>? customJavaScriptAssetPaths;

  /// Custom CSS to inject into the editor (e.g., for @font-face declarations).
  ///
  /// This CSS is injected into the document head and can be used to define
  /// custom fonts, override styles, etc. Example:
  ///
  /// ```dart
  /// customCss: '''
  ///   @font-face {
  ///     font-family: 'CustomFont';
  ///     src: url('./custom-font.woff2') format('woff2');
  ///   }
  /// '''
  /// ```
  final String? customCss;

  /// Asset paths containing custom CSS to inject into the editor.
  final List<String>? customCssAssetPaths;

  /// Transaction debounce duration in milliseconds.
  ///
  /// Controls how long to wait before flushing transactions after the last
  /// change. Defaults to 400ms. Lower values provide more responsive updates
  /// but may cause more frequent Flutter rebuilds.
  final Duration? transactionDebounceDuration;

  @override
  State<BlockNoteEditor> createState() => _BlockNoteEditorState();
}

class _BlockNoteEditorState extends State<BlockNoteEditor> {
  InAppWebViewController? _controller;
  JsBridge? _bridge;
  TransactionBatcher? _batcher;
  AssetServer? _assetServer;
  BlockNoteController? _blockNoteController;
  bool _isReady = false;
  bool _hasLoadedDocument = false;
  bool _hasPreloadedCustomJavaScript = false;
  bool _hasPreloadedCustomCss = false;
  bool _hasPreloadedSchemaConfig = false;
  double _lastKeyboardHeight = 0;
  double _lastAvailableHeight = 0;
  String? _initialUrl;
  bool _isInitializing = false;
  String? _loadedInitialUrl;
  Timer? _contentSizeChangeDebounceTimer;
  DateTime? _lastSignificantChangeTime;

  @override
  void initState() {
    super.initState();
    _initializeWebView().catchError((error) {
      if (widget.debugLogging) {
        debugPrint('[BlockNoteEditor] Error initializing WebView: $error');
      }
      MessageHandlers.handleError(
        message: 'Failed to initialize WebView: $error',
        debugLogging: widget.debugLogging,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure initialization happens
    if (_initialUrl == null && !_isInitializing) {
      _initializeWebView().catchError((error) {
        if (widget.debugLogging) {
          debugPrint('[BlockNoteEditor] Error initializing WebView: $error');
        }
        MessageHandlers.handleError(
          message: 'Failed to initialize WebView: $error',
          debugLogging: widget.debugLogging,
        );
      });
    }
  }

  @override
  void dispose() {
    // Stop asset server if running
    _assetServer?.stop();
    // Flush any pending transactions before disposing
    _batcher?.dispose();
    // Cancel debounce timer
    _contentSizeChangeDebounceTimer?.cancel();
    super.dispose();
  }

  /// Initializes the WebView and sets up the JavaScript bridge.
  Future<void> _initializeWebView() async {
    if (_isInitializing || _initialUrl != null) return;

    _isInitializing = true;

    // Create transaction batcher
    _batcher = TransactionBatcher(
      onBatch: (transactions) {
        if (widget.onTransactions != null) {
          widget.onTransactions!(transactions);
        }
      },
      batchWindow: widget.transactionDebounceDuration ??
          const Duration(milliseconds: 400),
      debugLogging: widget.debugLogging,
    );

    // Initialize WebView
    final result = await WebViewInitializer.initialize(
      localhostUrl: widget.localhostUrl,
      debugLogging: widget.debugLogging,
    );
    _assetServer = result.assetServer;

    if (mounted) {
      setState(() {
        _initialUrl = result.url;
        _isInitializing = false;
      });
    }
  }

  /// Loads the initial document into the editor.
  ///
  /// This is called once after the editor sends the "ready" message.
  /// We load the full document and then resume streaming transactions.
  Future<void> _loadInitialDocument() async {
    if (_hasLoadedDocument || _bridge == null || !_isReady) {
      return;
    }

    _hasLoadedDocument = true;

    // Load document immediately since editor is ready
    if (!mounted) return;

    try {
      await DocumentLoader.loadInitialDocument(
        DocumentLoadRequest(
          widget: widget,
          bridge: _bridge!,
          context: context,
          debugLogging: widget.debugLogging,
          options: DocumentLoadOptions(
            applySchemaConfig: !_hasPreloadedSchemaConfig,
            applyCustomJavaScript: !_hasPreloadedCustomJavaScript,
            applyCustomJavaScriptAssets: !_hasPreloadedCustomJavaScript,
            applyCustomCss: !_hasPreloadedCustomCss,
            applyCustomCssAssets: !_hasPreloadedCustomCss,
          ),
        ),
      );

      // Ensure WebView height is updated after document loads
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_isReady || _bridge == null) return;
        if (!context.mounted) return;

        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        final screenHeight = MediaQuery.of(context).size.height;
        final availableHeight = screenHeight - keyboardHeight;
        _updateWebViewHeight(keyboardHeight, availableHeight);
      });
    } catch (e) {
      MessageHandlers.handleError(
        message: 'Failed to load document: $e',
        debugLogging: widget.debugLogging,
      );
    }
  }

  /// Handles messages from the JavaScript bridge.
  void _handleBridgeMessage(JsToFlutterMessage message) {
    MessageHandlers.handleBridgeMessage(
      message: message,
      onReady: _handleReady,
      onTransactions: _handleTransactions,
      onError: (msg) => MessageHandlers.handleError(
        message: msg,
        debugLogging: widget.debugLogging,
      ),
      onToolbarPopupRequest: _handleToolbarPopupRequest,
      onDocument: _handleDocument,
      onLinkTap: _handleLinkTap,
      mounted: mounted,
    );
  }

  /// Handles link tap messages from JavaScript.
  void _handleLinkTap(LinkTapMessage message) {
    if (widget.onLinkTapped != null) {
      widget.onLinkTapped!(message.url);
    }
  }

  /// Handles document response from JavaScript.
  void _handleDocument(DocumentMessage message) {
    if (_blockNoteController == null) {
      if (widget.debugLogging) {
        debugPrint(
          '[BlockNoteEditor] Received document message but controller is null',
        );
      }
      return;
    }

    try {
      final document = BlockNoteDocument.fromJson(message.document);
      _blockNoteController!.handleDocumentResponse(message.requestId, document);
    } catch (e) {
      if (widget.debugLogging) {
        debugPrint('[BlockNoteEditor] Error parsing document: $e');
      }
      _blockNoteController!.handleDocumentError(
        message.requestId,
        'Failed to parse document: $e',
      );
    }
  }

  /// Handles raw JavaScript messages (fallback).
  void _handleJsMessage(String message) {
    MessageHandlers.handleJsMessage(
      message: message,
      bridge: _bridge,
      debugLogging: widget.debugLogging,
    );
  }

  /// Handles the ready message from JavaScript.
  void _handleReady() {
    if (_isReady) return;

    _isReady = true;

    if (widget.debugLogging) {
      debugPrint('[BlockNoteEditor] Editor is ready');
    }

    // Initialize controller
    if (_bridge != null && _blockNoteController == null) {
      _blockNoteController = BlockNoteController(
        debugLogging: widget.debugLogging,
      );
      _blockNoteController!.initialize(_bridge!);
    }

    // Load initial document now that editor is ready
    _loadInitialDocument();

    // Set initial WebView height after next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_isReady || _bridge == null) return;
      if (!context.mounted) return;

      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      final screenHeight = MediaQuery.of(context).size.height;
      final availableHeight = screenHeight - keyboardHeight;
      _lastKeyboardHeight = keyboardHeight;
      _lastAvailableHeight = availableHeight;
      _updateWebViewHeight(keyboardHeight, availableHeight);
    });

    // Notify ready callback with controller
    if (widget.onReady != null && _blockNoteController != null) {
      widget.onReady!(_blockNoteController!);
    }
  }

  /// Handles transactions from JavaScript.
  void _handleTransactions(TransactionsMessage message) {
    MessageHandlers.handleTransactions(
      message: message,
      batcher: _batcher,
      debugLogging: widget.debugLogging,
      onError: (msg) => MessageHandlers.handleError(
        message: msg,
        debugLogging: widget.debugLogging,
      ),
    );
  }

  /// Handles toolbar popup request from JavaScript.
  void _handleToolbarPopupRequest(ToolbarPopupRequestMessage message) {
    ToolbarPopupHandler.handleToolbarPopupRequest(
      message: message,
      widget: widget,
      context: context,
      bridge: _bridge,
      mounted: mounted,
      debugLogging: widget.debugLogging,
    );
  }

  @override
  void didUpdateWidget(BlockNoteEditor oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update read-only state if it changed
    if (oldWidget.readOnly != widget.readOnly && _bridge != null) {
      _bridge!.setReadonly(widget.readOnly);
    }

    // Update theme if it changed
    if (oldWidget.theme != widget.theme && _bridge != null && _isReady) {
      if (widget.theme != null) {
        _bridge!.setTheme(widget.theme!.toJson());
      }
    }

    // Update toolbar config if it changed
    if (oldWidget.toolbarConfig != widget.toolbarConfig &&
        _bridge != null &&
        _isReady) {
      if (widget.toolbarConfig != null) {
        _bridge!.setToolbarConfig(widget.toolbarConfig!.toJson());
      }
    }

    // Update slash command config if it changed
    if (oldWidget.slashCommandConfig != widget.slashCommandConfig &&
        _bridge != null &&
        _isReady) {
      if (widget.slashCommandConfig != null) {
        _bridge!.setSlashCommandConfig(widget.slashCommandConfig!.toJson());
      }
    }

    // Update schema config if it changed
    if ((oldWidget.schemaConfig != widget.schemaConfig ||
            oldWidget.schemaConfigs != widget.schemaConfigs ||
            oldWidget.activeSchemaId != widget.activeSchemaId) &&
        _bridge != null) {
      _hasLoadedDocument = false;
      _isReady = false;
      _hasPreloadedSchemaConfig = false;
      final resolvedSchemaConfig = _resolveSchemaConfig();
      if (resolvedSchemaConfig != null) {
        _bridge!.setSchemaConfig(resolvedSchemaConfig);
      }
    }

    // Update custom CSS if it changed (from customCss or theme font)
    final oldCss = CssUtils.getEffectiveCss(oldWidget);
    final newCss = CssUtils.getEffectiveCss(widget);
    if (oldCss != newCss && _bridge != null && _isReady) {
      if (newCss != null && newCss.isNotEmpty) {
        _bridge!.injectCustomCss(newCss);
      }
    }

    // Update custom JavaScript if it changed
    if (oldWidget.customJavaScript != widget.customJavaScript &&
        _bridge != null) {
      final script = widget.customJavaScript;
      if (script != null && script.isNotEmpty) {
        _hasPreloadedCustomJavaScript = false;
        _bridge!.evaluateJavaScript(script);
      }
    }

    // Update custom JavaScript assets if they changed
    if (oldWidget.customJavaScriptAssetPaths !=
            widget.customJavaScriptAssetPaths &&
        _bridge != null) {
      _hasPreloadedCustomJavaScript = false;
      _applyCustomJavaScriptAssets();
    }

    // Update custom CSS assets if they changed
    if (oldWidget.customCssAssetPaths != widget.customCssAssetPaths &&
        _bridge != null) {
      _hasPreloadedCustomCss = false;
      _applyCustomCssAssets();
    }

    // Update debounce duration if it changed
    if (oldWidget.transactionDebounceDuration !=
            widget.transactionDebounceDuration &&
        _bridge != null &&
        _isReady) {
      final duration = widget.transactionDebounceDuration;
      if (duration != null) {
        _bridge!.setDebounceDuration(duration.inMilliseconds);
      }
    }
  }

  Future<void> _preloadEditorConfiguration() async {
    if (_bridge == null) {
      return;
    }

    if (!_hasPreloadedCustomJavaScript) {
      final script = widget.customJavaScript;
      if (script != null && script.isNotEmpty) {
        await _bridge!.evaluateJavaScript(script);
      }
      await _applyCustomJavaScriptAssets();
      _hasPreloadedCustomJavaScript = true;
    }

    if (!_hasPreloadedCustomCss) {
      final css = widget.customCss;
      if (css != null && css.isNotEmpty) {
        await _bridge!.injectCustomCss(css);
      }
      await _applyCustomCssAssets();
      _hasPreloadedCustomCss = true;
    }

    if (!_hasPreloadedSchemaConfig) {
      final resolvedSchemaConfig = _resolveSchemaConfig();
      final hasSchemaConfig = resolvedSchemaConfig != null ||
          (widget.schemaConfigs != null && widget.schemaConfigs!.isNotEmpty);
      await _bridge!.setSchemaConfig(
        resolvedSchemaConfig,
        isRequired: hasSchemaConfig,
      );
      _hasPreloadedSchemaConfig = true;
    }
  }

  Map<String, dynamic>? _resolveSchemaConfig() {
    final configs = widget.schemaConfigs;
    if (configs != null && configs.isNotEmpty) {
      final activeId = widget.activeSchemaId;
      if (activeId != null && configs.containsKey(activeId)) {
        return configs[activeId];
      }
      return configs.values.first;
    }
    return widget.schemaConfig;
  }

  Future<void> _applyCustomJavaScriptAssets() async {
    final bridge = _bridge;
    if (bridge == null) {
      return;
    }
    final scripts = await DocumentLoader.loadAssets(
      widget.customJavaScriptAssetPaths,
    );
    for (final script in scripts) {
      if (script.isEmpty) {
        continue;
      }
      await bridge.evaluateJavaScript(script);
    }
  }

  Future<void> _applyCustomCssAssets() async {
    final bridge = _bridge;
    if (bridge == null) {
      return;
    }
    final stylesheets = await DocumentLoader.loadAssets(
      widget.customCssAssetPaths,
    );
    if (stylesheets.isEmpty) {
      return;
    }
    final combinedCss = stylesheets.where((css) => css.isNotEmpty).join('\n');
    if (combinedCss.isEmpty) {
      return;
    }
    await bridge.injectCustomCss(combinedCss);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get keyboard height from viewInsets
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        final screenHeight = constraints.maxHeight;
        final availableHeight = screenHeight - keyboardHeight;

        // Show loading indicator while initializing
        if (_initialUrl == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // Update WebView height when editor is ready or when keyboard opens/closes
        if (_isReady && _bridge != null && _controller != null) {
          // Always update height when ready (even if keyboard hasn't changed)
          // This ensures proper scrolling is enabled from the start
          if (_lastAvailableHeight == 0 ||
              (keyboardHeight - _lastKeyboardHeight).abs() > 1.0 ||
              (availableHeight - _lastAvailableHeight).abs() > 1.0) {
            _lastKeyboardHeight = keyboardHeight;
            _lastAvailableHeight = availableHeight;
            _updateWebViewHeight(keyboardHeight, availableHeight);
          }
        }
        // Extract editor background color from theme if available
        Color? editorBackgroundColor;
        if (widget.theme != null) {
          final colors = widget.theme!.colors ?? widget.theme!.light ?? widget.theme!.dark;
          if (colors != null && colors.editor != null) {
            editorBackgroundColor = colors.editor!.background;
          }
        }

        return SizedBox(
          height: availableHeight,
          child: InAppWebView(
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            initialUrlRequest: URLRequest(url: WebUri(_initialUrl!)),
            initialSettings: WebViewConfig.getDefaultSettings(
              backgroundColor: editorBackgroundColor,
            ),
            onWebViewCreated: (controller) {
              _controller = controller;
              // Create JavaScript bridge
              _bridge = JsBridge(
                controller: controller,
                onMessage: _handleBridgeMessage,
                debugLogging: widget.debugLogging,
              );
              // Initialize controller if bridge is ready
              if (_isReady && _blockNoteController == null) {
                _blockNoteController = BlockNoteController(
                  debugLogging: widget.debugLogging,
                );
                _blockNoteController!.initialize(_bridge!);
                if (widget.onReady != null) {
                  widget.onReady!(_blockNoteController!);
                }
              }
              // Set up JavaScript handlers
              WebViewConfig.setupJavaScriptHandlers(
                controller: controller,
                onJsMessage: _handleJsMessage,
                onConsoleMessage: (msg) {
                  if (msg.contains('[ERROR]')) {
                    debugPrint('[BlockNoteEditor] $msg');
                    MessageHandlers.handleError(
                      message: msg,
                      debugLogging: widget.debugLogging,
                    );
                  } else if (widget.debugLogging) {
                    debugPrint('[JS Console] $msg');
                  }
                },
                debugLogging: widget.debugLogging,
              );
            },
            onLoadStop: (controller, url) async {
              if (widget.debugLogging) {
                debugPrint('[BlockNoteEditor] Page finished loading: $url');
              }
              // Mark initial URL as loaded
              if (_loadedInitialUrl == null && _initialUrl != null) {
                _loadedInitialUrl = url.toString();
              }
              // Set up JavaScript bridge objects for message communication
              await WebViewConfig.setupJavaScriptBridge(
                controller: controller,
                debugLogging: widget.debugLogging,
              );
              await _preloadEditorConfiguration();
              // Set debounce duration if provided
              if (widget.transactionDebounceDuration != null) {
                await _bridge!.setDebounceDuration(
                  widget.transactionDebounceDuration!.inMilliseconds,
                );
              }
            },
            onReceivedError: (controller, request, error) {
              if (widget.debugLogging) {
                debugPrint('[BlockNoteEditor] Web resource error: $error');
              }
              MessageHandlers.handleError(
                message: 'WebView error: ${error.description}',
                debugLogging: widget.debugLogging,
              );
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              // Allow initial page load, block subsequent navigation (link clicks)
              final url = navigationAction.request.url.toString();
              
              // Normalize URLs for comparison (remove trailing slashes)
              String normalizeUrl(String? urlStr) {
                if (urlStr == null) return '';
                return urlStr.endsWith('/') ? urlStr.substring(0, urlStr.length - 1) : urlStr;
              }
              
              final normalizedUrl = normalizeUrl(url);
              final normalizedInitialUrl = normalizeUrl(_initialUrl);
              
              // If this is the initial URL or we haven't loaded it yet, allow navigation
              if (_initialUrl != null && normalizedUrl == normalizedInitialUrl && _loadedInitialUrl == null) {
                _loadedInitialUrl = url;
                if (widget.debugLogging) {
                  debugPrint('[BlockNoteEditor] Allowing initial page load: $url');
                }
                return NavigationActionPolicy.ALLOW;
              }
              
              // Block all other navigation (link clicks)
              // Link taps are handled via JavaScript interception and sent to Flutter
              // via onLinkTapped callback.
              if (widget.debugLogging) {
                debugPrint(
                  '[BlockNoteEditor] Navigation blocked: $url',
                );
              }
              return NavigationActionPolicy.CANCEL;
            },
            onContentSizeChanged: (controller, oldContentSize, newContentSize) {
              WebViewHeightManager.handleContentSizeChange(
                controller: controller,
                oldContentSize: oldContentSize,
                newContentSize: newContentSize,
                isReady: _isReady,
                debugLogging: widget.debugLogging,
                onScrollToSelection: () {
                  if (_controller != null && mounted) {
                    WebViewHeightManager.triggerScrollToSelection(
                      controller: _controller!,
                      debugLogging: widget.debugLogging,
                    );
                    // Reset tracking
                    _lastSignificantChangeTime = null;
                  }
                },
                updateLastSignificantChangeTime: (time) {
                  _lastSignificantChangeTime = time;
                },
                updateDebounceTimer: (timer) {
                  _contentSizeChangeDebounceTimer?.cancel();
                  _contentSizeChangeDebounceTimer = timer;
                },
                lastSignificantChangeTime: _lastSignificantChangeTime,
                contentSizeChangeDebounceTimer: _contentSizeChangeDebounceTimer,
              );
            },
          ),
        );
      },
    );
  }

  /// Updates the WebView height in JavaScript to ensure proper scrolling.
  void _updateWebViewHeight(double keyboardHeight, double availableHeight) {
    if (_bridge == null || _controller == null) return;

    WebViewHeightManager.updateWebViewHeight(
      bridge: _bridge!,
      controller: _controller!,
      keyboardHeight: keyboardHeight,
      availableHeight: availableHeight,
      debugLogging: widget.debugLogging,
    );
  }

}
