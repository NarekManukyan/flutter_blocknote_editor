/**
 * Initialize the bidirectional Flutter↔JS communication channel.
 * Sets up window.BlockNoteChannel for outgoing messages and
 * window.handleFlutterMessage for incoming messages.
 */

import { sendErrorToFlutter } from '../utils/flutterBridge';

/**
 * Initialize the outgoing message channel to Flutter.
 */
export function initBlockNoteChannel() {
  window.BlockNoteChannel = {
    postMessage(message) {
      try {
        if (window.onMessage) {
          window.onMessage.postMessage(message);
        } else {
          console.log('[BlockNote] Message (no channel):', message);
        }
      } catch (err) {
        console.error('[BlockNote] Error posting message:', err);
      }
    },
  };
}

/**
 * Parse incoming Flutter message data into a JS object.
 * Handles string, object, and escaped JSON string formats.
 * @param {*} messageData
 * @returns {Object}
 */
function parseMessageData(messageData) {
  if (typeof messageData === 'object' && messageData !== null) {
    return messageData;
  }

  if (typeof messageData === 'string') {
    try {
      return JSON.parse(messageData);
    } catch (parseError) {
      try {
        const unescaped = messageData.replace(/\\"/g, '"').replace(/\\'/g, "'");
        return JSON.parse(unescaped);
      } catch {
        throw parseError;
      }
    }
  }

  return messageData;
}

/**
 * Set up the incoming message handler from Flutter.
 * Dispatches parsed messages as 'flutterMessage' CustomEvents.
 */
export function initFlutterMessageHandler() {
  window.handleFlutterMessage = function (messageData) {
    try {
      const message = parseMessageData(messageData);

      if (message?.type === 'set_schema_config') {
        window.__blockNotePendingSchemaConfig = message;
      }

      window.dispatchEvent(
        new CustomEvent('flutterMessage', { detail: message }),
      );
    } catch (error) {
      console.error('[BlockNote] Failed to handle message:', error);
      sendErrorToFlutter('Failed to handle message: ' + error.message);
    }
  };
}

/**
 * Set up global error handlers that forward errors to Flutter.
 */
export function initGlobalErrorHandlers() {
  window.addEventListener('error', (event) => {
    const errorMsg = event.error ? event.error.toString() : event.message;
    sendErrorToFlutter(errorMsg);
    console.error('[BlockNote] Error:', errorMsg);
  });

  window.addEventListener('unhandledrejection', (event) => {
    const reason = event.reason ? event.reason.toString() : 'Unknown';
    sendErrorToFlutter('Unhandled Promise Rejection: ' + reason);
    console.error('[BlockNote] Promise Rejection:', reason);
  });
}
