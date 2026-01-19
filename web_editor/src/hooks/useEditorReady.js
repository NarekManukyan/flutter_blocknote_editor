/**
 * Custom hook for handling editor ready state and initialization.
 */

import { useCallback, useEffect, useRef } from 'react';

/**
 * Custom hook to handle editor ready state and send ready message.
 * @param {Object} editor - The BlockNote editor instance
 * @param {Object} documentVersionRef - Ref to track document version
 * @param {Function} setIsLoading - Function to set loading state
 * @param {Function} setError - Function to set error state
 * @returns {boolean} Whether editor is ready
 */
export function useEditorReady(
  editor,
  documentVersionRef,
  setIsLoading,
  setError,
) {
  const isReadyRef = useRef(false);
  const debounceTimeoutRef = useRef(null);
  const previousBlocksRef = useRef(null);
  const isReady = Boolean(editor);

  // Debounce delay in milliseconds (300ms default)
  const DEBOUNCE_DELAY = 300;

  // Helper function to serialize a block for transmission
  const serializeBlock = useCallback((block) => {
    const serializeBlockInner = (node) => {
      if (!node) return null;

      const serialized = {
        id: node.id,
        type: node.type,
      };

      // Include content if present
      if (node.content && Array.isArray(node.content)) {
        serialized.content = node.content.map((item) => {
          const contentItem = {
            type: item.type || 'text',
            text: item.text || '',
          };

          // Include styles if present
          if (item.styles && typeof item.styles === 'object') {
            contentItem.styles = item.styles;
          }

          // Include href for links
          if (item.href != null) {
            contentItem.href = item.href;
          }

          // Include mentionId for mentions
          if (item.mentionId != null) {
            contentItem.mentionId = item.mentionId;
          }

          return contentItem;
        });
      }

      // Include props if present
      if (node.props && typeof node.props === 'object') {
        serialized.props = node.props;
      }

      // Include children if present (recursively)
      if (
        node.children &&
        Array.isArray(node.children) &&
        node.children.length > 0
      ) {
        serialized.children = node.children
          .map((child) => serializeBlockInner(child))
          .filter(Boolean);
      }

      return serialized;
    };

    return serializeBlockInner(block);
  }, []);

  const getSelectionVisibility = useCallback((view, root) => {
    if (!view || !root) return null;
    const selection = view.state?.selection;
    if (!selection) return null;
    const fromCoords = view.coordsAtPos(selection.from);
    const toCoords = view.coordsAtPos(selection.to);
    const selectionTop = Math.min(fromCoords.top, toCoords.top);
    const selectionBottom = Math.max(fromCoords.bottom, toCoords.bottom);
    const rootRect = root.getBoundingClientRect();
    const isVisible =
      selectionTop >= rootRect.top && selectionBottom <= rootRect.bottom;
    return {
      isVisible,
      selectionTop,
      selectionBottom,
      rootTop: rootRect.top,
      rootBottom: rootRect.bottom,
    };
  }, []);

  // Helper function to check if two blocks are equal
  const blocksEqual = useCallback((block1, block2) => {
    const blocksEqualInner = (left, right) => {
      if (!left && !right) return true;
      if (!left || !right) return false;
      if (left.id !== right.id) return false;
      if (left.type !== right.type) return false;

      // Compare content
      const content1 = JSON.stringify(left.content || []);
      const content2 = JSON.stringify(right.content || []);
      if (content1 !== content2) return false;

      // Compare props
      const props1 = JSON.stringify(left.props || {});
      const props2 = JSON.stringify(right.props || {});
      if (props1 !== props2) return false;

      // Compare children recursively
      const children1 = left.children || [];
      const children2 = right.children || [];
      if (children1.length !== children2.length) return false;
      for (let i = 0; i < children1.length; i++) {
        if (!blocksEqualInner(children1[i], children2[i])) return false;
      }

      return true;
    };

    return blocksEqualInner(block1, block2);
  }, []);

  // Function to compute differences between previous and current blocks
  const computeBlockDifferences = useCallback(
    (previousBlocks, currentBlocks) => {
      const operations = [];

      // Create maps for quick lookup
      const previousMap = new Map();
      const currentMap = new Map();

      if (previousBlocks) {
        previousBlocks.forEach((block, index) => {
          if (block && block.id) {
            previousMap.set(block.id, { block, index });
          }
        });
      }

      if (currentBlocks) {
        currentBlocks.forEach((block, index) => {
          if (block && block.id) {
            currentMap.set(block.id, { block, index });
          }
        });
      }

      // Find deleted blocks (in previous but not in current)
      for (const blockId of previousMap.keys()) {
        if (!currentMap.has(blockId)) {
          operations.push({
            operation: 'delete',
            blockId: blockId,
          });
        }
      }

      // Find inserted and updated blocks
      currentMap.forEach(({ block: currBlock, index: currIndex }, blockId) => {
        const prevEntry = previousMap.get(blockId);

        if (!prevEntry) {
          // New block - insert
          operations.push({
            operation: 'insert',
            blockId: blockId,
            block: currBlock,
            index: currIndex,
          });
        } else {
          // Existing block - check if it changed
          const prevBlock = prevEntry.block;
          const prevIndex = prevEntry.index;

          // Check if block content changed
          if (!blocksEqual(prevBlock, currBlock)) {
            // Block content changed - update
            operations.push({
              operation: 'update',
              blockId: blockId,
              block: currBlock,
            });
          }

          // Check if block moved (position changed)
          // Note: We send move separately even if content also changed
          if (prevIndex !== currIndex) {
            operations.push({
              operation: 'move',
              blockId: blockId,
              index: currIndex,
            });
          }
        }
      });

      return operations;
    },
    [blocksEqual],
  );

  // Function to send transactions immediately
  const sendTransactions = useCallback(() => {
    if (!editor) return;

    try {
      const currentBlocks = editor.topLevelBlocks || [];
      const serializedCurrentBlocks =
        currentBlocks.length > 0
          ? currentBlocks.map((block) => serializeBlock(block))
          : null;

      let operations = [];

      if (previousBlocksRef.current === null) {
        // First time - send all blocks as updates
        operations = serializedCurrentBlocks
          ? serializedCurrentBlocks.map((block, index) => ({
              operation: 'update',
              blockId: block.id || `block_${index}`,
              block: block,
            }))
          : [
              {
                operation: 'update',
                blockId: 'root',
                block: null,
              },
            ];
      } else {
        // Compute differences
        operations = computeBlockDifferences(
          previousBlocksRef.current,
          serializedCurrentBlocks,
        );
      }

      // Only send if there are changes
      if (operations.length > 0) {
        const transactions = [
          {
            baseVersion: documentVersionRef.current,
            operations: operations,
          },
        ];

        documentVersionRef.current++;

        window.BlockNoteChannel.postMessage(
          JSON.stringify({
            type: 'transactions',
            data: transactions,
            timestamp: Date.now(),
          }),
        );
      }

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
  }, [editor, documentVersionRef, serializeBlock, computeBlockDifferences]);

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
        ? currentBlocks.map((block) => serializeBlock(block))
        : null;
  }, [editor, serializeBlock]);

  // Expose functions for external use
  useEffect(() => {
    if (editor && isReady) {
      window.sendPendingTransaction = flushTransactions;
      window.resetPreviousBlocks = resetPreviousBlocks;
    }
    return () => {
      if (window.sendPendingTransaction === flushTransactions) {
        delete window.sendPendingTransaction;
      }
      if (window.resetPreviousBlocks === resetPreviousBlocks) {
        delete window.resetPreviousBlocks;
      }
    };
  }, [editor, isReady, flushTransactions, resetPreviousBlocks]);

  useEffect(() => {
    if (!editor) {
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
          ? initialBlocks.map((block) => serializeBlock(block))
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
        }, DEBOUNCE_DELAY);
      });

      // Set up selection change listener to ensure automatic scroll-to-selection works
      if (editor._tiptapEditor) {
        const tiptapEditor = editor._tiptapEditor;

        // Listen for selection updates
        tiptapEditor.on('selectionUpdate', () => {
          // Use a small delay to ensure DOM has updated
          setTimeout(() => {
            try {
              const proseMirrorView = tiptapEditor.view;
              if (proseMirrorView) {
                const visualViewport = window.visualViewport;
                if (!visualViewport) {
                  return;
                }
                if (visualViewport.height >= window.innerHeight - 24) {
                  return;
                }
                const root = document.getElementById('root');
                const visibility = getSelectionVisibility(
                  proseMirrorView,
                  root,
                );
                if (visibility && visibility.isVisible) {
                  return;
                }
                // Trigger ProseMirror's built-in scroll-to-selection
                proseMirrorView.dispatch(
                  proseMirrorView.state.tr.scrollIntoView(),
                );
              }
            } catch {
              // Silently fail - BlockNote should handle this automatically
            }
          }, 10);
        });

        // Also listen for focus events on the editor DOM
        const setupFocusListeners = () => {
          try {
            const proseMirrorView = tiptapEditor.view;
            if (!proseMirrorView || !proseMirrorView.dom) {
              // Editor not mounted yet, try again later
              setTimeout(setupFocusListeners, 100);
              return;
            }

            const editorDOM = proseMirrorView.dom;
            const handleFocus = () => {
              // Small delay to let selection update
              setTimeout(() => {
                try {
                  const currentView = tiptapEditor.view;
                  if (currentView && currentView.dom) {
                    const visualViewport = window.visualViewport;
                    if (!visualViewport) {
                      return;
                    }
                    if (visualViewport.height >= window.innerHeight - 24) {
                      return;
                    }
                    const root = document.getElementById('root');
                    const visibility = getSelectionVisibility(
                      currentView,
                      root,
                    );
                    if (visibility && visibility.isVisible) {
                      return;
                    }
                    currentView.dispatch(currentView.state.tr.scrollIntoView());
                  }
                } catch {
                  // Silently fail
                }
              }, 50);
            };

            editorDOM.addEventListener('focus', handleFocus, true);
            editorDOM.addEventListener('click', handleFocus, true);
          } catch {
            setTimeout(setupFocusListeners, 200);
          }
        };

        // Try to set up listeners immediately, but retry if editor isn't ready
        setupFocusListeners();
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
    getSelectionVisibility,
    serializeBlock,
    setIsLoading,
    setError,
    sendTransactions,
  ]);

  return isReady;
}
