/// CSS utilities for BlockNote editor.
library;

import 'blocknote_editor.dart';

/// Gets the effective CSS to inject (from customCss and/or theme font).
class CssUtils {
  /// Gets the effective CSS for a widget.
  ///
  /// Combines custom CSS from [widget.customCss] with font CSS from
  /// [widget.theme] if available.
  static String? getEffectiveCss(BlockNoteEditor widget) {
    String? css = widget.customCss;
    if (widget.theme != null) {
      final fontCss = widget.theme!.generateFontCss();
      if (fontCss != null) {
        css = css != null ? '$css\n$fontCss' : fontCss;
      }
    }
    return css;
  }
}
