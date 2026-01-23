/**
 * Custom hook for applying theme background color.
 * Extracted from App.jsx to reduce complexity.
 */

import { useEffect } from 'react';

/**
 * Applies theme background color to page elements.
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
