/**
 * Custom hook for applying theme background color.
 * Extracted from App.jsx to reduce complexity.
 */

import { useEffect } from 'react';

/**
 * Apply the editor background color from the provided theme to the document root, html, body, and #root elements.
 *
 * @param {object} theme - Theme object expected to contain color definitions; the hook reads `colors.editor.background` or falls back to `light`/`dark`.
 * @param {object} blockNoteTheme - BlockNote theme instance whose presence and changes trigger the background synchronization.
 */
export function useThemeBackground(theme, blockNoteTheme) {
  useEffect(() => {
    if (!theme || !blockNoteTheme) {
      return;
    }

    const colors = theme.colors || theme.light || theme.dark;
    const editorBackground = colors?.editor?.background;

    if (!editorBackground) {
      return;
    }

    const bgColor = editorBackground.startsWith('#')
      ? editorBackground
      : `#${editorBackground}`;

    const html = document.documentElement;
    const body = document.body;
    const root = document.getElementById('root');

    if (html) {
      html.style.backgroundColor = bgColor;
    }
    if (body) {
      body.style.backgroundColor = bgColor;
    }
    if (root) {
      root.style.backgroundColor = bgColor;
    }
  }, [theme, blockNoteTheme]);
}
