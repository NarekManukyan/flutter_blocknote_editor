/**
 * Custom hook for handling editor ready state and initialization.
 */

import { useCallback, useEffect, useRef } from 'react';
import {
  serializeStyledText,
  serializeInlineContent,
  serializeTableContent,
  createSerializeBlock,
} from '../utils/blockSerialization';
import { blocksEqual, computeBlockDifferences } from '../utils/blockDiff';
import {
  getSelectionVisibility,
  scrollSelectionIntoView,
  setupFocusListeners,
} from '../utils/selectionVisibility';
import {
  createInitialOperations,
  sendTransactionsToFlutter,
} from '../utils/transactionSender';

/**
 * Manage editor readiness, initialize change listeners, and expose helpers for transaction flushing and serialization.
 * 
 * Initializes the editor-ready state, sends a ready signal, sets up debounced change handling that serializes top-level blocks and dispatches operations, exposes runtime helpers (sendPendingTransaction, resetPreviousBlocks, serializeBlock, updateDebounceDuration), and reports initialization errors when the editor is missing unless allowed.
 * @param {Object} editor - The BlockNote editor instance (or null/undefined when not present).
 * @param {Object} documentVersionRef - Mutable ref tracking the document version for outgoing transactions.
 * @param {Function} setIsLoading - Setter to update loading state.
 * @param {Function} setError - Setter to record an error message.
 * @param {boolean} allowMissingEditor - If true, skip setting an error when the editor is not provided.
 * @returns {boolean} `true` if the hook considers the editor ready, `false` otherwise.
 */
export function useEditorReady(
  editor,
  documentVersionRef,
  setIsLoading,
  setError,
  allowMissingEditor,
) {
  const isReadyRef = useRef(false);
  const debounceTimeoutRef = useRef(null);
  const previousBlocksRef = useRef(null);
  const debounceDurationRef = useRef(window.__blockNoteDebounceDuration ?? 300);
  const isReady = Boolean(editor);

  // Update debounce duration function (exposed globally)
  useEffect(() => {
    if (editor && isReady) {
      window.updateDebounceDuration = (durationMs) => {
        if (typeof durationMs === 'number' && durationMs >= 0) {
          debounceDurationRef.current = durationMs;
        }
      };
    }
    return () => {
      if (window.updateDebounceDuration) {
        delete window.updateDebounceDuration;
      }
    };
  }, [editor, isReady]);

  // Create serialization functions with proper dependencies
  const serializeStyledTextFn = useCallback(
    (item) => serializeStyledText(item),
    [],
  );
  const serializeInlineContentFn = useCallback(
    (item) => serializeInlineContent(item, serializeStyledTextFn),
    [serializeStyledTextFn],
  );
  const serializeTableContentFn = useCallback(
    (tableContent) =>
      serializeTableContent(tableContent, serializeInlineContentFn),
    [serializeInlineContentFn],
  );
  const serializeBlockFn = useCallback(
    (block) =>
      createSerializeBlock(
        serializeInlineContentFn,
        serializeTableContentFn,
      )(block),
    [serializeInlineContentFn, serializeTableContentFn],
  );

  const blocksEqualFn = useCallback(
    (block1, block2) => blocksEqual(block1, block2),
    [],
  );
  const computeBlockDifferencesFn = useCallback(
    (previousBlocks, currentBlocks) =>
      computeBlockDifferences(previousBlocks, currentBlocks, blocksEqualFn),
    [blocksEqualFn],
  );
  const getSelectionVisibilityFn = useCallback(
    (view, root) => getSelectionVisibility(view, root),
    [],
  );

  // Function to send transactions immediately
  const sendTransactions = useCallback(() => {
    if (!editor) return;

    try {
      const currentBlocks = editor.topLevelBlocks || [];
      const serializedCurrentBlocks =
        currentBlocks.length > 0
          ? currentBlocks.map((block) => serializeBlockFn(block))
          : null;

      const operations =
        previousBlocksRef.current === null
          ? createInitialOperations(serializedCurrentBlocks)
          : computeBlockDifferencesFn(
              previousBlocksRef.current,
              serializedCurrentBlocks,
            );

      sendTransactionsToFlutter(operations, documentVersionRef);

      // Update previous blocks reference for next comparison
      previousBlocksRef.current = serializedCurrentBlocks;
    } catch (error) {
      window.BlockNoteChannel.postMessage(
        JSON.stringify({
          type: 'error',
          data: { message: 'Error processing editor change: ' + error.message },
        }),
      );
    }
  }, [editor, documentVersionRef, serializeBlockFn, computeBlockDifferencesFn]);

  // Function to flush pending transactions immediately (clears debounce)
  const flushTransactions = useCallback(() => {
    // Clear any pending debounce timeout
    if (debounceTimeoutRef.current) {
      clearTimeout(debounceTimeoutRef.current);
      debounceTimeoutRef.current = null;
    }
    // Send transactions immediately
    sendTransactions();
  }, [sendTransactions]);

  // Function to reset previous blocks reference (called after document load)
  const resetPreviousBlocks = useCallback(() => {
    if (!editor) return;

    const currentBlocks = editor.topLevelBlocks || [];
    previousBlocksRef.current =
      currentBlocks.length > 0
        ? currentBlocks.map((block) => serializeBlockFn(block))
        : null;
  }, [editor, serializeBlockFn]);

  // Expose functions for external use
  useEffect(() => {
    if (editor && isReady) {
      window.sendPendingTransaction = flushTransactions;
      window.resetPreviousBlocks = resetPreviousBlocks;
      window.serializeBlock = serializeBlockFn;
    }
    return () => {
      if (window.sendPendingTransaction === flushTransactions) {
        delete window.sendPendingTransaction;
      }
      if (window.resetPreviousBlocks === resetPreviousBlocks) {
        delete window.resetPreviousBlocks;
      }
      if (window.serializeBlock === serializeBlockFn) {
        delete window.serializeBlock;
      }
    };
  }, [
    editor,
    isReady,
    flushTransactions,
    resetPreviousBlocks,
    serializeBlockFn,
  ]);

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

    if (!isReadyRef.current) {
      console.log('[BlockNote] Editor initialized, sending ready message');
      setIsLoading(false);
      isReadyRef.current = true;

      // Send ready message to Flutter
      try {
        window.BlockNoteChannel.postMessage(
          JSON.stringify({
            type: 'ready',
          }),
        );
      } catch (err) {
        console.error('[BlockNote] Error sending ready message:', err);
      }

      // Initialize previous blocks reference with current state
      const initialBlocks = editor.topLevelBlocks || [];
      previousBlocksRef.current =
        initialBlocks.length > 0
          ? initialBlocks.map((block) => serializeBlockFn(block))
          : null;

      // Set up change listener with debouncing
      editor.onChange(() => {
        // Clear existing timeout
        if (debounceTimeoutRef.current) {
          clearTimeout(debounceTimeoutRef.current);
        }

        // Set new timeout to send transaction after debounce delay
        debounceTimeoutRef.current = setTimeout(() => {
          sendTransactions();
          debounceTimeoutRef.current = null;
        }, debounceDurationRef.current);
      });

      // Set up selection change listener to ensure automatic scroll-to-selection works
      if (editor._tiptapEditor) {
        const tiptapEditor = editor._tiptapEditor;

        // Listen for selection updates
        tiptapEditor.on('selectionUpdate', () => {
          setTimeout(() => {
            try {
              const proseMirrorView = tiptapEditor.view;
              if (proseMirrorView) {
                const root = document.getElementById('root');
                scrollSelectionIntoView(proseMirrorView, root);
              }
            } catch {
              // Silently fail - BlockNote should handle this automatically
            }
          }, 10);
        });

        // Set up focus listeners
        setupFocusListeners(tiptapEditor, getSelectionVisibilityFn);
      }
    }

    // Cleanup function
    return () => {
      if (debounceTimeoutRef.current) {
        clearTimeout(debounceTimeoutRef.current);
        debounceTimeoutRef.current = null;
      }
    };
  }, [
    editor,
    documentVersionRef,
    getSelectionVisibilityFn,
    serializeBlockFn,
    setIsLoading,
    setError,
    sendTransactions,
    allowMissingEditor,
  ]);

  return isReady;
}