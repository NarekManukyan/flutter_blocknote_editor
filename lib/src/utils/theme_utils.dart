/// Theme utilities for BlockNote editor.
///
/// Provides helper functions for theme selection and conversion based on
/// app appearance (light/dark mode).
library;

import 'package:flutter/material.dart';
import '../model/blocknote_theme.dart';

/// Theme utilities for BlockNote editor.
class ThemeUtils {
  /// Gets the effective theme based on app appearance.
  ///
  /// Selects light or dark theme based on the current brightness mode
  /// from the app's theme (not device brightness). Returns null if no
  /// theme is configured.
  ///
  /// The returned theme JSON will contain only the color scheme that
  /// matches the current app appearance, along with other theme properties
  /// like borderRadius and font.
  static Map<String, dynamic>? getEffectiveTheme(
    BlockNoteTheme? theme,
    BuildContext context,
  ) {
    if (theme == null) {
      return null;
    }

    // Get app brightness (not device brightness)
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    // Select theme based on app appearance
    final selectedColorScheme = isDark
        ? (theme.dark ?? theme.light)
        : (theme.light ?? theme.dark);

    if (selectedColorScheme == null) {
      return null;
    }

    // Build theme JSON with only the selected color scheme
    final themeJson = <String, dynamic>{};
    if (isDark && theme.dark != null) {
      themeJson['dark'] = theme.dark!.toJson();
    } else if (!isDark && theme.light != null) {
      themeJson['light'] = theme.light!.toJson();
    } else {
      // Fallback: use whichever is available
      if (theme.dark != null) {
        themeJson['dark'] = theme.dark!.toJson();
      }
      if (theme.light != null) {
        themeJson['light'] = theme.light!.toJson();
      }
    }

    // Add other theme properties
    if (theme.borderRadius != null) {
      themeJson['borderRadius'] = theme.borderRadius;
    }
    if (theme.font != null) {
      themeJson['font'] = theme.font!.toJson();
    }

    return themeJson;
  }

  /// Gets the color scheme for the current app appearance.
  ///
  /// Returns the appropriate color scheme (light or dark) based on the
  /// app's current brightness mode. Falls back to the other if the
  /// preferred one is not available.
  static BlockNoteColorScheme? getColorSchemeForAppearance(
    BlockNoteTheme? theme,
    BuildContext context,
  ) {
    if (theme == null) {
      return null;
    }

    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    return isDark
        ? (theme.dark ?? theme.light)
        : (theme.light ?? theme.dark);
  }
}
