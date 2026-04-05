/**
 * Custom hook for intercepting link clicks in the BlockNote editor.
 * Prevents default navigation and sends link URL to Flutter.
 */

import { useEffect } from 'react';
import { sendToFlutter } from '../utils/flutterBridge';

/**
 * Intercepts link clicks in the editor and sends them to Flutter.
 * @param {Object} editor - The BlockNote editor instance.
 */
export function useLinkTapHandler(editor) {
  useEffect(() => {
    if (!editor) return;

    const handleClick = (event) => {
      // Walk up DOM to find anchor element
      let target = event.target;
      while (target && target !== document.body) {
        if (target.tagName === 'A') break;
        target = target.parentElement;
      }

      if (!target || target.tagName !== 'A') return;

      const href = target.getAttribute('href');
      if (!href) return;

      // Check if the link is within the editor
      const editorContainer =
        document.querySelector('[class*="bn-editor"]') || document.body;
      if (
        !editorContainer.contains(target) &&
        !target.closest('[class*="bn-editor"]')
      ) {
        return;
      }

      event.preventDefault();
      event.stopPropagation();

      sendToFlutter('link_tap', { url: href });
    };

    document.addEventListener('click', handleClick, true);
    return () => document.removeEventListener('click', handleClick, true);
  }, [editor]);
}
