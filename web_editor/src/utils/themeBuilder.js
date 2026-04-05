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

    let blockNoteTheme = {};
    if (cloned.light || cloned.dark) {
      if (cloned.light) blockNoteTheme.light = cloned.light;
      if (cloned.dark) blockNoteTheme.dark = cloned.dark;
      if (cloned.borderRadius !== undefined) blockNoteTheme.borderRadius = cloned.borderRadius;
      if (cloned.fontFamily) blockNoteTheme.fontFamily = cloned.fontFamily;
    } else {
      blockNoteTheme = cloned;
    }

    // Ensure fontFamily propagates
    if (cloned.fontFamily && !blockNoteTheme.fontFamily) {
      blockNoteTheme.fontFamily = cloned.fontFamily;
    }

    debugLog('Converted theme:', blockNoteTheme);
    return blockNoteTheme;
  } catch (error) {
    console.error('[BlockNote] Error converting theme:', error);
    return null;
  }
}
