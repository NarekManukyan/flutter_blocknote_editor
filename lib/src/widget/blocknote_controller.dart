/// BlockNote editor controller for programmatic operations.
///
/// This controller provides methods to interact with the BlockNote editor
/// programmatically, including getting the full document, setting configuration,
/// and loading documents. It avoids large data transfers on every change by
/// providing on-demand document retrieval.
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../bridge/js_bridge.dart';
import '../model/blocknote_document.dart';
import '../model/blocknote_toolbar_config.dart';
import '../model/blocknote_slash_command.dart';

/// Controller for programmatic operations on a BlockNote editor.
///
/// Provides methods to:
/// - Get the full document on-demand
/// - Set editor configuration (read-only, toolbar, slash commands, schema, etc.)
/// - Load documents
/// - Flush pending transactions
///
/// Note: Theme changes should be handled via the `BlockNoteEditor` widget's
/// `theme` prop, which automatically adapts to system brightness changes.
///
/// The controller is initialized when the editor is ready and can be accessed
/// via the `onControllerReady` callback in `BlockNoteEditor`.
class BlockNoteController {
  /// Creates a new BlockNote controller.
  ///
  /// The controller must be initialized with a bridge before use.
  BlockNoteController({
    this.debugLogging = false,
  });

  /// Whether debug logging is enabled.
  final bool debugLogging;

  /// The JavaScript bridge for communication.
  JsBridge? _bridge;

  /// Whether the controller is ready (bridge is set).
  bool get isReady => _bridge != null;

  /// Pending document request completers, keyed by request ID.
  final Map<String, Completer<BlockNoteDocument>> _pendingDocumentRequests =
      <String, Completer<BlockNoteDocument>>{};

  /// Initialize the controller with a JavaScript bridge.
  ///
  /// This is called internally by BlockNoteEditor when the editor is ready.
  void initialize(JsBridge bridge) {
    if (_bridge != null) {
      if (debugLogging) {
        debugPrint('[BlockNoteController] Already initialized');
      }
      return;
    }
    _bridge = bridge;
    if (debugLogging) {
      debugPrint('[BlockNoteController] Initialized');
    }
  }

  /// Gets the full document from the editor.
  ///
  /// Returns the complete document structure. This is an on-demand operation
  /// that avoids large data transfers on every change.
  ///
  /// Throws [StateError] if the controller is not ready.
  Future<BlockNoteDocument> getDocument() async {
    if (_bridge == null) {
      throw StateError(
        'BlockNoteController is not ready. Ensure the editor is initialized.',
      );
    }

    final requestId = _generateRequestId();
    final completer = Completer<BlockNoteDocument>();
    _pendingDocumentRequests[requestId] = completer;

    try {
      await _bridge!.getDocument(requestId: requestId);

      // Wait for response with timeout
      return await completer.future.timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          _pendingDocumentRequests.remove(requestId);
          throw TimeoutException(
            'getDocument() timed out after 10 seconds',
            const Duration(seconds: 10),
          );
        },
      );
    } catch (e) {
      _pendingDocumentRequests.remove(requestId);
      rethrow;
    }
  }

  /// Completes a pending document request.
  ///
  /// This is called internally when a document response is received.
  void _completeDocumentRequest(String requestId, BlockNoteDocument document) {
    final completer = _pendingDocumentRequests.remove(requestId);
    if (completer != null && !completer.isCompleted) {
      completer.complete(document);
    } else if (debugLogging) {
      debugPrint(
        '[BlockNoteController] No pending request found for ID: $requestId',
      );
    }
  }

  /// Completes a pending document request with an error.
  ///
  /// This is called internally when a document request fails.
  void _completeDocumentRequestWithError(String requestId, Object error) {
    final completer = _pendingDocumentRequests.remove(requestId);
    if (completer != null && !completer.isCompleted) {
      completer.completeError(error);
    } else if (debugLogging) {
      debugPrint(
        '[BlockNoteController] No pending request found for ID: $requestId',
      );
    }
  }

  /// Generates a unique request ID for document requests.
  String _generateRequestId() {
    return 'doc_${DateTime.now().millisecondsSinceEpoch}_${_pendingDocumentRequests.length}';
  }

  /// Sets the editor read-only state.
  ///
  /// Throws [StateError] if the controller is not ready.
  Future<void> setReadonly(bool value) async {
    if (_bridge == null) {
      throw StateError(
        'BlockNoteController is not ready. Ensure the editor is initialized.',
      );
    }
    await _bridge!.setReadonly(value);
  }

  /// Sets the toolbar configuration.
  ///
  /// Throws [StateError] if the controller is not ready.
  Future<void> setToolbarConfig(BlockNoteToolbarConfig config) async {
    if (_bridge == null) {
      throw StateError(
        'BlockNoteController is not ready. Ensure the editor is initialized.',
      );
    }
    await _bridge!.setToolbarConfig(config.toJson());
  }

  /// Sets the slash command configuration.
  ///
  /// Throws [StateError] if the controller is not ready.
  Future<void> setSlashCommandConfig(
    BlockNoteSlashCommandConfig config,
  ) async {
    if (_bridge == null) {
      throw StateError(
        'BlockNoteController is not ready. Ensure the editor is initialized.',
      );
    }
    await _bridge!.setSlashCommandConfig(config.toJson());
  }

  /// Sets the schema configuration.
  ///
  /// Throws [StateError] if the controller is not ready.
  Future<void> setSchemaConfig(
    Map<String, dynamic>? config, {
    bool isRequired = false,
  }) async {
    if (_bridge == null) {
      throw StateError(
        'BlockNoteController is not ready. Ensure the editor is initialized.',
      );
    }
    await _bridge!.setSchemaConfig(config, isRequired: isRequired);
  }

  /// Loads a document into the editor.
  ///
  /// Throws [StateError] if the controller is not ready.
  Future<void> loadDocument(BlockNoteDocument document) async {
    if (_bridge == null) {
      throw StateError(
        'BlockNoteController is not ready. Ensure the editor is initialized.',
      );
    }
    await _bridge!.loadDocument(document.toJson());
  }

  /// Flushes pending transactions immediately.
  ///
  /// Throws [StateError] if the controller is not ready.
  Future<void> flush() async {
    if (_bridge == null) {
      throw StateError(
        'BlockNoteController is not ready. Ensure the editor is initialized.',
      );
    }
    await _bridge!.flush();
  }

  /// Internal method to handle document response from JavaScript.
  ///
  /// This is called by BlockNoteEditor when a document message is received.
  void handleDocumentResponse(String requestId, BlockNoteDocument document) {
    _completeDocumentRequest(requestId, document);
  }

  /// Internal method to handle document error from JavaScript.
  ///
  /// This is called by BlockNoteEditor when a document request fails.
  void handleDocumentError(String requestId, String error) {
    _completeDocumentRequestWithError(
      requestId,
      Exception('Failed to get document: $error'),
    );
  }
}
