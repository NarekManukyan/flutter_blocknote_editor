/// Message type definitions for Flutter ↔ JavaScript communication.
///
/// This file defines the message protocol used for bidirectional
/// communication between Flutter and the JavaScript BlockNote editor.
/// All messages use JSON format for type-safe handling.
library;

/// Message types sent from Flutter to JavaScript.
enum FlutterToJsMessageType {
  /// Load a document into the editor.
  loadDocument,

  /// Set the editor to read-only mode.
  setReadonly,

  /// Flush pending transactions immediately.
  flush,

  /// Set the editor theme.
  setTheme,

  /// Set the toolbar configuration.
  setToolbarConfig,

  /// Set the slash command configuration.
  setSlashCommandConfig,

  /// Set the editor schema configuration.
  setSchemaConfig,

  /// Update WebView height for keyboard handling.
  updateWebViewHeight,

  /// Inject custom CSS into the editor.
  injectCustomCss,

  /// Send toolbar popup response with selected value.
  toolbarPopupResponse,

  /// Set the transaction debounce duration.
  setDebounceDuration,

  /// Get the full document from the editor.
  getDocument,
}

/// Message types sent from JavaScript to Flutter.
enum JsToFlutterMessageType {
  /// Editor is ready and initialized.
  ready,

  /// New transactions are available.
  transactions,

  /// An error occurred in the JavaScript editor.
  error,

  /// Toolbar popup was clicked, requesting Flutter modal.
  toolbarPopupRequest,

  /// Full document response from get document request.
  document,

  /// Link was tapped in the editor.
  linkTap,
}

/// Base class for Flutter → JavaScript messages.
abstract class FlutterToJsMessage {
  /// Creates a new message instance.
  const FlutterToJsMessage();

  /// The message type.
  FlutterToJsMessageType get type;

  /// Converts this message to a JSON map.
  Map<String, dynamic> toJson();
}

/// Message to load a document into the editor.
class LoadDocumentMessage extends FlutterToJsMessage {
  /// Creates a new load document message.
  const LoadDocumentMessage({required this.document});

  /// The document to load.
  final Map<String, dynamic> document;

  @override
  FlutterToJsMessageType get type => FlutterToJsMessageType.loadDocument;

  @override
  Map<String, dynamic> toJson() {
    return {'type': 'load_document', 'data': document};
  }
}

/// Message to set the editor read-only state.
class SetReadonlyMessage extends FlutterToJsMessage {
  /// Creates a new set readonly message.
  const SetReadonlyMessage({required this.value});

  /// The read-only value.
  final bool value;

  @override
  FlutterToJsMessageType get type => FlutterToJsMessageType.setReadonly;

  @override
  Map<String, dynamic> toJson() {
    return {'type': 'set_readonly', 'value': value};
  }
}

/// Message to flush pending transactions.
class FlushMessage extends FlutterToJsMessage {
  /// Creates a new flush message.
  const FlushMessage();

  @override
  FlutterToJsMessageType get type => FlutterToJsMessageType.flush;

  @override
  Map<String, dynamic> toJson() {
    return {'type': 'flush'};
  }
}

/// Message to set the editor theme.
class SetThemeMessage extends FlutterToJsMessage {
  /// Creates a new set theme message.
  const SetThemeMessage({required this.theme});

  /// The theme configuration.
  final Map<String, dynamic> theme;

  @override
  FlutterToJsMessageType get type => FlutterToJsMessageType.setTheme;

  @override
  Map<String, dynamic> toJson() {
    return {'type': 'set_theme', 'data': theme};
  }
}

/// Message to set the toolbar configuration.
class SetToolbarConfigMessage extends FlutterToJsMessage {
  /// Creates a new set toolbar config message.
  const SetToolbarConfigMessage({required this.config});

  /// The toolbar configuration.
  final Map<String, dynamic> config;

  @override
  FlutterToJsMessageType get type => FlutterToJsMessageType.setToolbarConfig;

  @override
  Map<String, dynamic> toJson() {
    return {'type': 'set_toolbar_config', 'data': config};
  }
}

/// Message to set the slash command configuration.
class SetSlashCommandConfigMessage extends FlutterToJsMessage {
  /// Creates a new set slash command config message.
  const SetSlashCommandConfigMessage({required this.config});

  /// The slash command configuration.
  final Map<String, dynamic> config;

  @override
  FlutterToJsMessageType get type =>
      FlutterToJsMessageType.setSlashCommandConfig;

  @override
  Map<String, dynamic> toJson() {
    return {'type': 'set_slash_command_config', 'data': config};
  }
}

/// Message to set the editor schema configuration.
class SetSchemaConfigMessage extends FlutterToJsMessage {
  /// Creates a new set schema config message.
  const SetSchemaConfigMessage({
    this.config,
    this.isRequired = false,
  });

  /// The schema configuration.
  final Map<String, dynamic>? config;

  /// Whether the editor should wait for schema config before initializing.
  final bool isRequired;

  @override
  FlutterToJsMessageType get type => FlutterToJsMessageType.setSchemaConfig;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'set_schema_config',
      'data': config,
      'required': isRequired,
    };
  }
}

/// Message to update WebView bottom padding for keyboard handling.
///
/// Keyboard detection is handled on the JavaScript side using visualViewport API.
/// Flutter only controls the extra bottom padding value.
class UpdateWebViewHeightMessage extends FlutterToJsMessage {
  /// Creates a new update WebView bottom padding message.
  const UpdateWebViewHeightMessage({
    this.extraBottomPadding = 0,
  });

  /// Extra bottom padding in pixels (optional, defaults to 0).
  final int extraBottomPadding;

  @override
  FlutterToJsMessageType get type => FlutterToJsMessageType.updateWebViewHeight;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'update_webview_height',
      'extraBottomPadding': extraBottomPadding,
    };
  }
}

/// Message to inject custom CSS into the editor.
class InjectCustomCssMessage extends FlutterToJsMessage {
  /// Creates a new inject custom CSS message.
  const InjectCustomCssMessage({required this.css});

  /// The CSS to inject.
  final String css;

  @override
  FlutterToJsMessageType get type => FlutterToJsMessageType.injectCustomCss;

  @override
  Map<String, dynamic> toJson() {
    return {'type': 'inject_custom_css', 'css': css};
  }
}

/// Message to send toolbar popup response with selected value.
class ToolbarPopupResponseMessage extends FlutterToJsMessage {
  /// Creates a new toolbar popup response message.
  const ToolbarPopupResponseMessage({
    required this.requestId,
    required this.popupType,
    this.selectedValue,
  });

  /// The request ID to match with the original request.
  final String requestId;

  /// The type of popup (e.g., 'colorStyle', 'blockTypeSelect').
  final String popupType;

  /// The selected value (can be null if cancelled).
  final dynamic selectedValue;

  @override
  FlutterToJsMessageType get type =>
      FlutterToJsMessageType.toolbarPopupResponse;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'toolbar_popup_response',
      'requestId': requestId,
      'popupType': popupType,
      'selectedValue': selectedValue,
    };
  }
}

/// Message to set the transaction debounce duration.
class SetDebounceDurationMessage extends FlutterToJsMessage {
  /// Creates a new set debounce duration message.
  const SetDebounceDurationMessage({required this.durationMs});

  /// The debounce duration in milliseconds.
  final int durationMs;

  @override
  FlutterToJsMessageType get type => FlutterToJsMessageType.setDebounceDuration;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'set_debounce_duration',
      'durationMs': durationMs,
    };
  }
}

/// Message to get the full document from the editor.
class GetDocumentMessage extends FlutterToJsMessage {
  /// Creates a new get document message.
  const GetDocumentMessage({required this.requestId});

  /// Unique request ID for matching with response.
  final String requestId;

  @override
  FlutterToJsMessageType get type => FlutterToJsMessageType.getDocument;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'get_document',
      'requestId': requestId,
    };
  }
}

/// Base class for JavaScript → Flutter messages.
abstract class JsToFlutterMessage {
  /// Creates a new message instance.
  const JsToFlutterMessage();

  /// The message type.
  JsToFlutterMessageType get type;

  /// Creates a message from a JSON map.
  factory JsToFlutterMessage.fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String;

    // Convert snake_case to camelCase for enum matching
    // e.g., 'toolbar_popup_request' -> 'toolbarPopupRequest'
    String enumName = typeStr;
    if (typeStr.contains('_')) {
      final parts = typeStr.split('_');
      enumName =
          parts[0] +
          parts
              .sublist(1)
              .map((p) => p.isEmpty ? '' : p[0].toUpperCase() + p.substring(1))
              .join();
    }

    final type = JsToFlutterMessageType.values.firstWhere(
      (e) => e.name == enumName,
      orElse: () => JsToFlutterMessageType.error,
    );

    switch (type) {
      case JsToFlutterMessageType.ready:
        return ReadyMessage();
      case JsToFlutterMessageType.transactions:
        return TransactionsMessage.fromJson(json);
      case JsToFlutterMessageType.error:
        return ErrorMessage.fromJson(json);
      case JsToFlutterMessageType.toolbarPopupRequest:
        return ToolbarPopupRequestMessage.fromJson(json);
      case JsToFlutterMessageType.document:
        return DocumentMessage.fromJson(json);
      case JsToFlutterMessageType.linkTap:
        return LinkTapMessage.fromJson(json);
    }
  }
}

/// Message indicating the editor is ready.
class ReadyMessage extends JsToFlutterMessage {
  /// Creates a new ready message.
  const ReadyMessage();

  @override
  JsToFlutterMessageType get type => JsToFlutterMessageType.ready;
}

/// Message containing new transactions.
class TransactionsMessage extends JsToFlutterMessage {
  /// Creates a new transactions message.
  const TransactionsMessage({required this.data, this.timestamp});

  /// The transaction data.
  final List<Map<String, dynamic>> data;

  /// Optional timestamp.
  final int? timestamp;

  /// Creates a TransactionsMessage from a JSON map.
  factory TransactionsMessage.fromJson(Map<String, dynamic> json) {
    return TransactionsMessage(
      data: (json['data'] as List)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      timestamp: json['timestamp'] as int?,
    );
  }

  @override
  JsToFlutterMessageType get type => JsToFlutterMessageType.transactions;
}

/// Message indicating an error occurred.
class ErrorMessage extends JsToFlutterMessage {
  /// Creates a new error message.
  const ErrorMessage({required this.message});

  /// The error message.
  final String message;

  /// Creates an ErrorMessage from a JSON map.
  factory ErrorMessage.fromJson(Map<String, dynamic> json) {
    return ErrorMessage(message: json['message'] as String? ?? 'Unknown error');
  }

  @override
  JsToFlutterMessageType get type => JsToFlutterMessageType.error;
}

/// Message indicating a toolbar popup was clicked.
class ToolbarPopupRequestMessage extends JsToFlutterMessage {
  /// Creates a new toolbar popup request message.
  const ToolbarPopupRequestMessage({
    required this.requestId,
    required this.popupType,
    required this.options,
  });

  /// Unique request ID for matching with response.
  final String requestId;

  /// The type of popup (e.g., 'colorStyle', 'blockTypeSelect').
  final String popupType;

  /// Available options for the popup.
  final List<Map<String, dynamic>> options;

  /// Creates a ToolbarPopupRequestMessage from a JSON map.
  factory ToolbarPopupRequestMessage.fromJson(Map<String, dynamic> json) {
    return ToolbarPopupRequestMessage(
      requestId: json['requestId'] as String,
      popupType: json['popupType'] as String,
      options: (json['options'] as List)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );
  }

  @override
  JsToFlutterMessageType get type => JsToFlutterMessageType.toolbarPopupRequest;
}

/// Message containing the full document from get document request.
class DocumentMessage extends JsToFlutterMessage {
  /// Creates a new document message.
  const DocumentMessage({
    required this.requestId,
    required this.document,
  });

  /// Unique request ID for matching with original request.
  final String requestId;

  /// The document data.
  final Map<String, dynamic> document;

  /// Creates a DocumentMessage from a JSON map.
  factory DocumentMessage.fromJson(Map<String, dynamic> json) {
    return DocumentMessage(
      requestId: json['requestId'] as String,
      document: Map<String, dynamic>.from(json['document'] as Map),
    );
  }

  @override
  JsToFlutterMessageType get type => JsToFlutterMessageType.document;
}

/// Message indicating a link was tapped in the editor.
class LinkTapMessage extends JsToFlutterMessage {
  /// Creates a new link tap message.
  const LinkTapMessage({required this.url});

  /// The URL of the tapped link.
  final String url;

  /// Creates a LinkTapMessage from a JSON map.
  factory LinkTapMessage.fromJson(Map<String, dynamic> json) {
    return LinkTapMessage(url: json['url'] as String);
  }

  @override
  JsToFlutterMessageType get type => JsToFlutterMessageType.linkTap;
}
