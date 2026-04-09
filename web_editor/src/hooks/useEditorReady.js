/**
 * Custom hook for handling editor ready state and initialization.
 */

import { useCallback, useEffect, useRef } from 'react';
import { createSerializeBlock, serializeInlineContent, serializeStyledText, serializeTableContent } from '../utils/blockSerialization';
import { computeBlockDifferences } from '../utils/blockDiff';
import {
  getSelectionVisibility,
  scrollSelectionIntoView,
  setupFocusListeners,
  setupChecklistBlurOnToggle,
} from '../utils/selectionVisibility';
import {
  createInitialOperations,
  sendTransactionsToFlutter,
} from '../utils/transactionSender';
import { sendToFlutter, sendErrorToFlutter } from '../utils/flutterBridge';

// Create stable serializer (pure functions, no need for useCallback)
const serializeBlock = createSerializeBlock(
  (item) => serializeInlineContent(item, serializeStyledText),
  (tableContent) =>
    serializeTableContent(tableContent, (item) =>
      serializeInlineContent(item, serializeStyledText),
    ),
);

/**
 * Serialize top-level blocks from the editor.
 * @param {Object} editor
 * @returns {Array|null}
 */
function serializeTopLevelBlocks(editor) {
  const blocks = editor.topLevelBlocks || [];
  return blocks.length > 0 ? blocks.map(serializeBlock) : null;
}

/**
 * Manage editor readiness, change listeners, and transaction dispatch.
 *
 * @param {Object} editor - The BlockNote editor instance.
 * @param {Object} refs - Shared mutable refs with documentVersion, hasLoadedDocument, etc.
 * @param {Function} setIsLoading - Loading state setter.
 * @param {Function} setError - Error state setter.
 * @param {boolean} allowMissingEditor - Skip error when editor is absent.
 * @returns {boolean} Whether the editor is ready.
 */
export function useEditorReady(editor, refs, setIsLoading, setError, allowMissingEditor) {
  const hasInitializedRef = useRef(false);
  const debounceTimeoutRef = useRef(null);
  const previousBlocksRef = useRef(null);
  const debounceDurationRef = useRef(window.__blockNoteDebounceDuration ?? 300);
  const sendTransactionsRef = useRef(null);
  const isReady = Boolean(editor);

  // Expose debounce duration updater
  useEffect(() => {
    if (!editor || !isReady) return;

    window.updateDebounceDuration = (durationMs) => {
      if (typeof durationMs === 'number' && durationMs >= 0) {
        debounceDurationRef.current = durationMs;
      }
    };
    return () => {
      delete window.updateDebounceDuration;
    };
  }, [editor, isReady]);

  // Send transactions immediately
  const sendTransactions = useCallback(() => {
    if (!editor) return;

    try {
      const serializedCurrentBlocks = serializeTopLevelBlocks(editor);
      const operations =
        previousBlocksRef.current === null
          ? createInitialOperations(editor, serializedCurrentBlocks)
          : computeBlockDifferences(editor, previousBlocksRef.current, serializedCurrentBlocks);

      sendTransactionsToFlutter(operations, refs);
      previousBlocksRef.current = serializedCurrentBlocks;
    } catch (error) {
      sendErrorToFlutter('Error processing editor change: ' + error.message);
    }
  }, [editor, refs]);

  // Keep ref in sync every render so the onChange closure always calls the latest version.
  sendTransactionsRef.current = sendTransactions;

  // Flush pending transactions (clear debounce + send)
  const flushTransactions = useCallback(() => {
    if (debounceTimeoutRef.current) {
      clearTimeout(debounceTimeoutRef.current);
      debounceTimeoutRef.current = null;
    }
    sendTransactions();
  }, [sendTransactions]);

  // Reset previous blocks baseline (called after document load)
  const resetPreviousBlocks = useCallback(() => {
    if (!editor) return;
    previousBlocksRef.current = serializeTopLevelBlocks(editor);
  }, [editor]);

  // Expose functions globally for Flutter access; store resetPreviousBlocks in refs (not window)
  useEffect(() => {
    if (!editor || !isReady) return;

    window.sendPendingTransaction = flushTransactions;
    window.serializeBlock = serializeBlock;
    refs.resetPreviousBlocks = resetPreviousBlocks;

    return () => {
      if (window.sendPendingTransaction === flushTransactions) delete window.sendPendingTransaction;
      if (window.serializeBlock === serializeBlock) delete window.serializeBlock;
      if (refs.resetPreviousBlocks === resetPreviousBlocks) refs.resetPreviousBlocks = null;
    };
  }, [editor, isReady, flushTransactions, resetPreviousBlocks, refs]);

  // Main initialization effect
  useEffect(() => {
    if (!editor) {
      if (allowMissingEditor) {
        setIsLoading(true);
        return;
      }
      setError('Editor not created');
      setIsLoading(false);
      return;
    }

    if (!hasInitializedRef.current) {
      setIsLoading(false);
      hasInitializedRef.current = true;

      sendToFlutter('ready');

      // Initialize baseline for diff tracking
      previousBlocksRef.current = serializeTopLevelBlocks(editor);

      // Debounced change listener — closure calls ref so it always invokes the latest sendTransactions.
      const onChangeCleanup = editor.onChange(() => {
        if (debounceTimeoutRef.current) {
          clearTimeout(debounceTimeoutRef.current);
        }
        debounceTimeoutRef.current = setTimeout(() => {
          sendTransactionsRef.current?.();
          debounceTimeoutRef.current = null;
        }, debounceDurationRef.current);
      });

      // Selection + focus handling via tiptap internals
      const tiptapEditor = editor._tiptapEditor;
      if (tiptapEditor) {
        tiptapEditor.on('selectionUpdate', () => {
          setTimeout(() => {
            try {
              const view = tiptapEditor.view;
              if (view) {
                const root = document.getElementById('root');
                scrollSelectionIntoView(view, root);
              }
            } catch {
              // BlockNote handles this automatically
            }
          }, 10);
        });

        setupFocusListeners(tiptapEditor, getSelectionVisibility);
        setupChecklistBlurOnToggle(tiptapEditor);
      }

      return () => {
        if (debounceTimeoutRef.current) {
          clearTimeout(debounceTimeoutRef.current);
          debounceTimeoutRef.current = null;
        }
        // Call BlockNote onChange cleanup if it returned one
        if (typeof onChangeCleanup === 'function') {
          onChangeCleanup();
        }
      };
    }

    return () => {
      if (debounceTimeoutRef.current) {
        clearTimeout(debounceTimeoutRef.current);
        debounceTimeoutRef.current = null;
      }
    };
  }, [editor, setIsLoading, setError, allowMissingEditor]);

  return isReady;
}
