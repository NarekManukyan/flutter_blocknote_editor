/// Message handling utilities for BlockNote editor.
library;

import 'package:flutter/foundation.dart';
import '../bridge/js_bridge.dart';
import '../bridge/message_types.dart';
import '../batching/transaction_batcher.dart';
import '../model/blocknote_transaction.dart';

/// Handles messages from the JavaScript bridge.
class MessageHandlers {
  /// Handles bridge messages and routes them to appropriate handlers.
  static void handleBridgeMessage({
    required JsToFlutterMessage message,
    required Function() onReady,
    required Function(TransactionsMessage) onTransactions,
    required Function(String) onError,
    required Function(ToolbarPopupRequestMessage) onToolbarPopupRequest,
    Function(DocumentMessage)? onDocument,
    Function(LinkTapMessage)? onLinkTap,
    required bool mounted,
  }) {
    if (!mounted) return;

    switch (message.type) {
      case JsToFlutterMessageType.ready:
        onReady();
        break;
      case JsToFlutterMessageType.transactions:
        onTransactions(message as TransactionsMessage);
        break;
      case JsToFlutterMessageType.error:
        onError((message as ErrorMessage).message);
        break;
      case JsToFlutterMessageType.toolbarPopupRequest:
        onToolbarPopupRequest(message as ToolbarPopupRequestMessage);
        break;
      case JsToFlutterMessageType.document:
        if (onDocument != null) {
          onDocument(message as DocumentMessage);
        }
        break;
      case JsToFlutterMessageType.linkTap:
        if (onLinkTap != null) {
          onLinkTap(message as LinkTapMessage);
        }
        break;
    }
  }

  /// Handles raw JavaScript messages (fallback).
  static void handleJsMessage({
    required String message,
    required JsBridge? bridge,
    required bool debugLogging,
  }) {
    if (debugLogging) {
      debugPrint('[BlockNoteEditor] Raw JS message: $message');
    }

    // Handle test messages (for debugging)
    if (message.contains('"type":"test"')) {
      if (debugLogging) {
        debugPrint('[BlockNoteEditor] Received test message from JS');
      }
      return;
    }

    if (bridge != null) {
      bridge.handleMessage(message);
    }
  }

  /// Handles transactions from JavaScript.
  ///
  /// Transactions are added to the batcher, which will send them to Flutter
  /// after the batch window expires or immediately on critical operations.
  static void handleTransactions({
    required TransactionsMessage message,
    required TransactionBatcher? batcher,
    required bool debugLogging,
    required Function(String) onError,
  }) {
    if (batcher == null) return;

    try {
      // Parse transactions from JSON
      final transactions = message.data
          .map((json) => BlockNoteTransaction.fromJson(json))
          .toList();

      // Add to batcher
      for (final transaction in transactions) {
        batcher.addTransaction(transaction);
      }
    } catch (e) {
      if (debugLogging) {
        debugPrint('[BlockNoteEditor] Error parsing transactions: $e');
      }
      onError('Failed to parse transactions: $e');
    }
  }

  /// Handles errors from JavaScript.
  static void handleError({
    required String message,
    required bool debugLogging,
  }) {
    if (debugLogging) {
      debugPrint('[BlockNoteEditor] Error: $message');
    }
    // Error handling can be extended here (e.g., show error UI)
  }
}
