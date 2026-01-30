/**
 * Custom hook for applying theme background color.
 * Syncs the editor's appearance (light/dark) and background to the page using .bn-container
 * so the padding area matches the editor and follows system/theme appearance.
 */

import { useEffect } from 'react';
import {
  setTheme,
  syncEditorAppearanceToPage,
} from '../utils/webViewHeightManager';

/**
 * Sync the editor's background and data-color-scheme to the page (html, body, #root).
 * Uses .bn-container's appearance so it follows the editor's light/dark theme.
 *
 * @param {object} theme - Theme object from Flutter (stored for webViewHeightManager).
 * @param {object} blockNoteTheme - BlockNote theme instance; when present we sync after the editor has rendered.
 */
export function useThemeBackground(theme, blockNoteTheme) {
  useEffect(() => {
    setTheme(theme);

    // Sync from .bn-container once it's in the DOM (editor may not be mounted yet)
    const rafId = requestAnimationFrame(() => {
      syncEditorAppearanceToPage();
      requestAnimationFrame(syncEditorAppearanceToPage);
    });

    let observer = null;
    const timeoutId = setTimeout(() => {
      const container = document.querySelector('.bn-container');
      if (container) {
        observer = new MutationObserver(() => {
          syncEditorAppearanceToPage();
        });
        observer.observe(container, {
          attributes: true,
          attributeFilter: ['data-color-scheme', 'class'],
        });
      }
    }, 300);

    return () => {
      cancelAnimationFrame(rafId);
      clearTimeout(timeoutId);
      if (observer) {
        observer.disconnect();
      }
    };
  }, [theme, blockNoteTheme]);
}
