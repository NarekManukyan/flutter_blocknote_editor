/// WebView configuration utilities for BlockNote editor.
library;

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Sets up JavaScript handlers for message communication.
class WebViewConfig {
  /// Sets up JavaScript handlers for message communication.
  static void setupJavaScriptHandlers({
    required InAppWebViewController controller,
    required Function(String) onJsMessage,
    required Function(String) onConsoleMessage,
    required bool debugLogging,
  }) {
    // Handler for onMessage channel
    controller.addJavaScriptHandler(
      handlerName: 'onMessage',
      callback: (args) {
        if (args.isNotEmpty) {
          onJsMessage(args[0].toString());
        }
      },
    );

    // Handler for flutterConsole channel
    controller.addJavaScriptHandler(
      handlerName: 'flutterConsole',
      callback: (args) {
        if (args.isNotEmpty) {
          final msg = args[0].toString();
          onConsoleMessage(msg);
        }
      },
    );
  }

  /// Sets up JavaScript bridge objects for message communication.
  static Future<void> setupJavaScriptBridge({
    required InAppWebViewController controller,
    required bool debugLogging,
  }) async {
    try {
      // Inject JavaScript to create bridge objects that map to handlers
      // This allows the existing JavaScript code to work without changes
      await controller.evaluateJavascript(
        source:
            '''
        (function() {
          // Set debug logging flag
          window.BlockNoteDebugLogging = $debugLogging;
          
          // Create onMessage bridge object
          if (!window.onMessage) {
            window.onMessage = {
              postMessage: function(message) {
                if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) {
                  window.flutter_inappwebview.callHandler('onMessage', message);
                }
              }
            };
          }
          
          // Create flutterConsole bridge object
          if (!window.flutterConsole) {
            window.flutterConsole = {
              postMessage: function(message) {
                if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) {
                  window.flutter_inappwebview.callHandler('flutterConsole', message);
                }
              }
            };
          }
          
          if (window.BlockNoteDebugLogging) {
            console.log('[BlockNote] JavaScript handlers bridge installed');
          }
        })();
      ''',
      );

      if (debugLogging) {
        debugPrint('[BlockNoteEditor] JavaScript bridge installed');
      }
    } catch (error) {
      if (debugLogging) {
        debugPrint(
          '[BlockNoteEditor] Error setting up JavaScript bridge: $error',
        );
      }
    }
  }

  /// Gets the default WebView settings for BlockNote editor.
  ///
  /// [backgroundColor] is optional. If provided, the WebView will use this
  /// color as its background instead of being transparent. The background color
  /// is applied via the theme system in JavaScript, not through WebView settings.
  static InAppWebViewSettings getDefaultSettings({Color? backgroundColor}) {
    return InAppWebViewSettings(
      javaScriptEnabled: true,
      transparentBackground: backgroundColor == null,
      useHybridComposition: true,
      verticalScrollBarEnabled: true,
      horizontalScrollBarEnabled: false,
      supportZoom: false,
      disableVerticalScroll: false,
      disableHorizontalScroll: true,
    );
  }
}
