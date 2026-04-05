/**
 * Theme building utility for BlockNote editor.
 * Converts Flutter theme format to BlockNote format.
 */

import { debugLog } from './flutterBridge';

/**
 * Converts a Flutter theme to BlockNote theme format.
 * @param {Object} theme - Theme object from Flutter
 * @returns {Object|null} BlockNote theme object or null if invalid
 */
export function buildBlockNoteTheme(theme) {
  if (!theme) return null;

  try {
    debugLog('Processing theme:', theme);
    // Deep clone to avoid mutation issues
    const cloned = JSON.parse(JSON.stringify(theme));

    // Extract fontFamily from Flutter's font config ({family, files}) or direct fontFamily
    const fontFamily = cloned.font?.family || cloned.fontFamily;
    // Remove font object so it doesn't leak into BlockNote theme
    delete cloned.font;

    let blockNoteTheme = {};
    if (cloned.light || cloned.dark) {
      if (cloned.light) blockNoteTheme.light = cloned.light;
      if (cloned.dark) blockNoteTheme.dark = cloned.dark;
      if (cloned.borderRadius !== undefined) blockNoteTheme.borderRadius = cloned.borderRadius;
      if (fontFamily) blockNoteTheme.fontFamily = fontFamily;
    } else {
      blockNoteTheme = cloned;
    }

    // Ensure fontFamily propagates
    if (fontFamily && !blockNoteTheme.fontFamily) {
      blockNoteTheme.fontFamily = fontFamily;
    }

    debugLog('Converted theme:', blockNoteTheme);
    return blockNoteTheme;
  } catch (error) {
    console.error('[BlockNote] Error converting theme:', error);
    return null;
  }
}
