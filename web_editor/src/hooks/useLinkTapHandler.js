/**
 * Custom hook for intercepting link clicks in the BlockNote editor.
 * Prevents default navigation and sends link URL to Flutter.
 */

import { useEffect } from 'react';

/**
 * Intercepts link clicks in the editor and sends them to Flutter.
 *
 * Sets up a click event listener on the document that detects clicks on
 * anchor elements within the editor. When a link is clicked, prevents
 * default navigation and sends the URL to Flutter via BlockNoteChannel.
 *
 * @param {Object} editor - The BlockNote editor instance.
 */
export function useLinkTapHandler(editor) {
  useEffect(() => {
    if (!editor) {
      return;
    }

    // Find the editor container element
    // BlockNoteView renders the editor in a container with specific classes
    const findEditorContainer = () => {
      // Try to find the editor container by looking for BlockNote-specific classes
      const containers = document.querySelectorAll(
        '[class*="bn-editor"], [class*="blocknote"], [data-blocknote]',
      );
      if (containers.length > 0) {
        return containers[0];
      }

      // Fallback: look for the root element or body
      return document.body;
    };

    const handleClick = (event) => {
      // Find the clicked element or its parent that is an anchor tag
      let target = event.target;
      let anchorElement = null;

      // Traverse up the DOM tree to find an anchor element
      while (target && target !== document.body) {
        if (target.tagName === 'A' || target.tagName === 'a') {
          anchorElement = target;
          break;
        }
        target = target.parentElement;
      }

      if (!anchorElement) {
        return;
      }

      // Get the href attribute
      const href = anchorElement.getAttribute('href');
      if (!href) {
        return;
      }

      // Check if the link is within the editor
      const editorContainer = findEditorContainer();
      if (
        editorContainer &&
        !editorContainer.contains(anchorElement) &&
        !anchorElement.closest('[class*="bn-editor"]')
      ) {
        // Link is not in the editor, allow default behavior
        return;
      }

      // Prevent default navigation
      event.preventDefault();
      event.stopPropagation();

      // Send message to Flutter
      if (window.BlockNoteChannel && window.BlockNoteChannel.postMessage) {
        window.BlockNoteChannel.postMessage(
          JSON.stringify({
            type: 'link_tap',
            url: href,
          }),
        );
      } else {
        console.warn(
          '[BlockNote] BlockNoteChannel not available, cannot send link tap message',
        );
      }
    };

    // Add event listener to document for event delegation
    document.addEventListener('click', handleClick, true);

    return () => {
      document.removeEventListener('click', handleClick, true);
    };
  }, [editor]);
}
