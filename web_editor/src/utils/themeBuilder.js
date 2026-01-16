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
    
    // BlockNote expects theme in a specific format
    // If light/dark are provided, use them; otherwise use colors directly
    let blockNoteTheme = {};
    if (themeClone.light || themeClone.dark) {
      if (themeClone.light) {
        blockNoteTheme.light = themeClone.light;
      }
      if (themeClone.dark) {
        blockNoteTheme.dark = themeClone.dark;
      }
      // Add borderRadius and fontFamily if provided
      if (themeClone.borderRadius !== undefined) {
        blockNoteTheme.borderRadius = themeClone.borderRadius;
      }
      if (themeClone.fontFamily) {
        blockNoteTheme.fontFamily = themeClone.fontFamily;
      }
    } else {
      // Use theme as-is (it should already be in the correct format)
      blockNoteTheme = themeClone;
    }
    
    // Ensure fontFamily is always set if provided in theme
    if (themeClone.fontFamily && !blockNoteTheme.fontFamily) {
      blockNoteTheme.fontFamily = themeClone.fontFamily;
    }
    
    console.log('[BlockNote] Converted theme:', blockNoteTheme);
    return blockNoteTheme;
  } catch (error) {
    console.error('[BlockNote] Error converting theme:', error, theme);
    return null;
  }
}
