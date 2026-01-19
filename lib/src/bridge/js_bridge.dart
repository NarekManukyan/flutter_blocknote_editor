/// JavaScript bridge for Flutter ↔ JavaScript communication.
///
/// This file provides the communication layer between Flutter and the
/// JavaScript BlockNote editor running in a WebView. It handles message
/// serialization, deserialization, and type-safe message routing.
library;

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'message_types.dart';

/// JavaScript bridge for BlockNote editor communication.
///
/// Handles bidirectional message passing between Flutter and the
/// JavaScript editor. All messages are JSON-encoded for type safety.
class JsBridge {
  /// Creates a new JavaScript bridge.
  JsBridge({
    required this.controller,
    required this.onMessage,
    this.debugLogging = false,
  });

  /// The WebView controller for sending messages.
  final InAppWebViewController controller;

  /// Callback for handling messages from JavaScript.
  final ValueChanged<JsToFlutterMessage> onMessage;

  /// Whether to enable debug logging.
  final bool debugLogging;

  /// Sends a message to the JavaScript editor.
  ///
  /// Messages are JSON-encoded and sent via the WebView's JavaScript
  /// evaluation channel.
  Future<void> sendMessage(FlutterToJsMessage message) async {
    try {
      final json = jsonEncode(message.toJson());
      if (debugLogging) {
        debugPrint('[JsBridge] Sending: $json');
      }

      // Send message via JavaScript evaluation
      // Use JSON.parse in JavaScript to properly handle nested JSON strings
      // This ensures proper parsing of escaped JSON strings
      final escapedJson = json
          .replaceAll('\\', '\\\\')
          .replaceAll("'", "\\'")
          .replaceAll('\n', '\\n')
          .replaceAll(r'$', r'\$');
      await controller.evaluateJavascript(
        source:
            '''
        (function() {
          if (typeof window.handleFlutterMessage === 'function') {
            try {
              // Parse the JSON string to handle nested JSON properly
              const messageJson = JSON.parse('$escapedJson');
              window.handleFlutterMessage(messageJson);
            } catch (e) {
              console.error('[BlockNote] Error parsing message JSON:', e);
              // Fallback: try as string
              window.handleFlutterMessage('$escapedJson');
            }
          } else {
            console.error('[BlockNote] handleFlutterMessage not available');
          }
        })();
      ''',
      );
    } catch (e) {
      if (debugLogging) {
        debugPrint('[JsBridge] Error sending message: $e');
      }
      rethrow;
    }
  }

  /// Handles a message received from JavaScript.
  ///
  /// Messages are JSON-decoded and routed to the appropriate handler.
  void handleMessage(String message) {
    try {
      if (debugLogging) {
        debugPrint('[JsBridge] Received: $message');
      }

      final json = jsonDecode(message) as Map<String, dynamic>;
      final messageType = json['type'] as String?;

      if (debugLogging) {
        debugPrint('[JsBridge] Message type: $messageType');
      }

      // Handle test messages (for debugging)
      if (messageType == 'test') {
        if (debugLogging) {
          debugPrint('[JsBridge] Test message received: ${json['data']}');
        }
        return;
      }

      final jsMessage = JsToFlutterMessage.fromJson(json);
      if (debugLogging) {
        debugPrint('[JsBridge] Parsed message type: ${jsMessage.type}');
      }
      onMessage(jsMessage);
    } catch (e) {
      if (debugLogging) {
        debugPrint('[JsBridge] Error handling message: $e');
      }
      // Forward error to Flutter
      onMessage(ErrorMessage(message: 'Failed to parse message: $e'));
    }
  }

  /// Loads a document into the editor.
  Future<void> loadDocument(Map<String, dynamic> document) async {
    await sendMessage(LoadDocumentMessage(document: document));
  }

  /// Sets the editor read-only state.
  Future<void> setReadonly(bool value) async {
    await sendMessage(SetReadonlyMessage(value: value));
  }

  /// Flushes pending transactions immediately.
  Future<void> flush() async {
    await sendMessage(const FlushMessage());
  }

  /// Sets the editor theme.
  Future<void> setTheme(Map<String, dynamic> theme) async {
    await sendMessage(SetThemeMessage(theme: theme));
  }

  /// Sets the toolbar configuration.
  Future<void> setToolbarConfig(Map<String, dynamic> config) async {
    await sendMessage(SetToolbarConfigMessage(config: config));
  }

  /// Sets the slash command configuration.
  Future<void> setSlashCommandConfig(Map<String, dynamic> config) async {
    await sendMessage(SetSlashCommandConfigMessage(config: config));
  }

  /// Updates the WebView height for keyboard handling.
  Future<void> updateWebViewHeight(int height, int keyboardHeight) async {
    await sendMessage(
      UpdateWebViewHeightMessage(
        height: height,
        keyboardHeight: keyboardHeight,
      ),
    );
  }

  /// Injects custom CSS into the editor.
  Future<void> injectCustomCss(String css) async {
    await sendMessage(InjectCustomCssMessage(css: css));
  }

  /// Sends toolbar popup response with selected value.
  Future<void> sendToolbarPopupResponse({
    required String requestId,
    required String popupType,
    dynamic selectedValue,
  }) async {
    await sendMessage(
      ToolbarPopupResponseMessage(
        requestId: requestId,
        popupType: popupType,
        selectedValue: selectedValue,
      ),
    );
  }
}
