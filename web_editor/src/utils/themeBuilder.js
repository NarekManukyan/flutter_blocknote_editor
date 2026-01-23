/**
 * Theme building utility for BlockNote editor.
 * Converts Flutter theme format to BlockNote format.
 */

/**
 * Converts a Flutter theme to BlockNote theme format.
 * @param {Object} theme - Theme object from Flutter
 * @returns {Object|null} BlockNote theme object or null if invalid
 */
export function buildBlockNoteTheme(theme) {
  if (!theme) {
    return null;
  }

  try {
    console.log('[BlockNote] Processing theme:', theme);
    // Deep clone to avoid mutation issues
    const themeClone = JSON.parse(JSON.stringify(theme));

    // BlockNote expects theme with light/dark properties
    const blockNoteTheme = {};

    // Add light theme if provided
    if (themeClone.light) {
      blockNoteTheme.light = themeClone.light;
    }

    // Add dark theme if provided
    if (themeClone.dark) {
      blockNoteTheme.dark = themeClone.dark;
    }

    // Add borderRadius if provided
    if (themeClone.borderRadius !== undefined) {
      blockNoteTheme.borderRadius = themeClone.borderRadius;
    }

    // Add font configuration if provided
    if (themeClone.font) {
      blockNoteTheme.font = themeClone.font;
    }

    // Only return theme if it has at least light or dark
    if (!blockNoteTheme.light && !blockNoteTheme.dark) {
      console.warn(
        '[BlockNote] Theme has no light or dark colors, returning null',
      );
      return null;
    }

    console.log('[BlockNote] Converted theme:', blockNoteTheme);
    return blockNoteTheme;
  } catch (error) {
    console.error('[BlockNote] Error converting theme:', error, theme);
    return null;
  }
}
