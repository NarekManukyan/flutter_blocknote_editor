/// Theme configuration for BlockNote editor.
///
/// Allows customization of colors, borders, shadows, font, and border radius.
/// Supports both light and dark themes.
library;

import 'package:flutter/material.dart';

/// Converts a Flutter Color to a hex string (e.g., "#3f3f3f").
String _colorToHex(Color color) {
  return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}';
}

/// Parses a hex string to a Flutter Color.
Color _hexToColor(String hex) {
  final hexCode = hex.replaceAll('#', '');
  if (hexCode.length == 6) {
    return Color(int.parse('FF$hexCode', radix: 16));
  } else if (hexCode.length == 8) {
    return Color(int.parse(hexCode, radix: 16));
  }
  throw FormatException('Invalid hex color: $hex');
}

/// A color pair with text and background colors.
class BlockNoteColorPair {
  /// Creates a new color pair.
  const BlockNoteColorPair({
    required this.text,
    required this.background,
  });

  /// Text color.
  final Color text;

  /// Background color.
  final Color background;

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    return {
      'text': _colorToHex(text),
      'background': _colorToHex(background),
    };
  }

  /// Creates from JSON.
  factory BlockNoteColorPair.fromJson(Map<String, dynamic> json) {
    return BlockNoteColorPair(
      text: _hexToColor(json['text'] as String),
      background: _hexToColor(json['background'] as String),
    );
  }
}

/// Highlight color type.
enum BlockNoteHighlightColorType {
  /// Gray highlight color.
  gray,

  /// Brown highlight color.
  brown,

  /// Red highlight color.
  red,

  /// Orange highlight color.
  orange,

  /// Yellow highlight color.
  yellow,

  /// Green highlight color.
  green,

  /// Blue highlight color.
  blue,

  /// Purple highlight color.
  purple,

  /// Pink highlight color.
  pink;

  /// Gets the JSON key for this highlight color type.
  String get jsonKey => name;
}

/// Highlight colors configuration.
class BlockNoteHighlightColors {
  /// Creates a new highlight colors configuration.
  const BlockNoteHighlightColors({
    this.gray,
    this.brown,
    this.red,
    this.orange,
    this.yellow,
    this.green,
    this.blue,
    this.purple,
    this.pink,
  });

  /// Gray highlight color.
  final BlockNoteColorPair? gray;

  /// Brown highlight color.
  final BlockNoteColorPair? brown;

  /// Red highlight color.
  final BlockNoteColorPair? red;

  /// Orange highlight color.
  final BlockNoteColorPair? orange;

  /// Yellow highlight color.
  final BlockNoteColorPair? yellow;

  /// Green highlight color.
  final BlockNoteColorPair? green;

  /// Blue highlight color.
  final BlockNoteColorPair? blue;

  /// Purple highlight color.
  final BlockNoteColorPair? purple;

  /// Pink highlight color.
  final BlockNoteColorPair? pink;

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (gray != null) {
      json[BlockNoteHighlightColorType.gray.jsonKey] = gray!.toJson();
    }
    if (brown != null) {
      json[BlockNoteHighlightColorType.brown.jsonKey] = brown!.toJson();
    }
    if (red != null) {
      json[BlockNoteHighlightColorType.red.jsonKey] = red!.toJson();
    }
    if (orange != null) {
      json[BlockNoteHighlightColorType.orange.jsonKey] = orange!.toJson();
    }
    if (yellow != null) {
      json[BlockNoteHighlightColorType.yellow.jsonKey] = yellow!.toJson();
    }
    if (green != null) {
      json[BlockNoteHighlightColorType.green.jsonKey] = green!.toJson();
    }
    if (blue != null) {
      json[BlockNoteHighlightColorType.blue.jsonKey] = blue!.toJson();
    }
    if (purple != null) {
      json[BlockNoteHighlightColorType.purple.jsonKey] = purple!.toJson();
    }
    if (pink != null) {
      json[BlockNoteHighlightColorType.pink.jsonKey] = pink!.toJson();
    }
    return json;
  }

  /// Creates from JSON.
  factory BlockNoteHighlightColors.fromJson(Map<String, dynamic> json) {
    return BlockNoteHighlightColors(
      gray: json[BlockNoteHighlightColorType.gray.jsonKey] != null
          ? BlockNoteColorPair.fromJson(
              json[BlockNoteHighlightColorType.gray.jsonKey]
                  as Map<String, dynamic>,
            )
          : null,
      brown: json[BlockNoteHighlightColorType.brown.jsonKey] != null
          ? BlockNoteColorPair.fromJson(
              json[BlockNoteHighlightColorType.brown.jsonKey]
                  as Map<String, dynamic>,
            )
          : null,
      red: json[BlockNoteHighlightColorType.red.jsonKey] != null
          ? BlockNoteColorPair.fromJson(
              json[BlockNoteHighlightColorType.red.jsonKey]
                  as Map<String, dynamic>,
            )
          : null,
      orange: json[BlockNoteHighlightColorType.orange.jsonKey] != null
          ? BlockNoteColorPair.fromJson(
              json[BlockNoteHighlightColorType.orange.jsonKey]
                  as Map<String, dynamic>,
            )
          : null,
      yellow: json[BlockNoteHighlightColorType.yellow.jsonKey] != null
          ? BlockNoteColorPair.fromJson(
              json[BlockNoteHighlightColorType.yellow.jsonKey]
                  as Map<String, dynamic>,
            )
          : null,
      green: json[BlockNoteHighlightColorType.green.jsonKey] != null
          ? BlockNoteColorPair.fromJson(
              json[BlockNoteHighlightColorType.green.jsonKey]
                  as Map<String, dynamic>,
            )
          : null,
      blue: json[BlockNoteHighlightColorType.blue.jsonKey] != null
          ? BlockNoteColorPair.fromJson(
              json[BlockNoteHighlightColorType.blue.jsonKey]
                  as Map<String, dynamic>,
            )
          : null,
      purple: json[BlockNoteHighlightColorType.purple.jsonKey] != null
          ? BlockNoteColorPair.fromJson(
              json[BlockNoteHighlightColorType.purple.jsonKey]
                  as Map<String, dynamic>,
            )
          : null,
      pink: json[BlockNoteHighlightColorType.pink.jsonKey] != null
          ? BlockNoteColorPair.fromJson(
              json[BlockNoteHighlightColorType.pink.jsonKey]
                  as Map<String, dynamic>,
            )
          : null,
    );
  }
}

/// Color scheme configuration.
class BlockNoteColorScheme {
  /// Creates a new color scheme.
  const BlockNoteColorScheme({
    this.editor,
    this.menu,
    this.tooltip,
    this.hovered,
    this.selected,
    this.disabled,
    this.shadow,
    this.border,
    this.sideMenu,
    this.highlights,
  });

  /// Editor text and background colors.
  final BlockNoteColorPair? editor;

  /// Menu text and background colors.
  final BlockNoteColorPair? menu;

  /// Tooltip text and background colors.
  final BlockNoteColorPair? tooltip;

  /// Hovered element text and background colors.
  final BlockNoteColorPair? hovered;

  /// Selected element text and background colors.
  final BlockNoteColorPair? selected;

  /// Disabled element text and background colors.
  final BlockNoteColorPair? disabled;

  /// Shadow color.
  final Color? shadow;

  /// Border color.
  final Color? border;

  /// Side menu color.
  final Color? sideMenu;

  /// Highlight colors.
  final BlockNoteHighlightColors? highlights;

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (editor != null) json['editor'] = editor!.toJson();
    if (menu != null) json['menu'] = menu!.toJson();
    if (tooltip != null) json['tooltip'] = tooltip!.toJson();
    if (hovered != null) json['hovered'] = hovered!.toJson();
    if (selected != null) json['selected'] = selected!.toJson();
    if (disabled != null) json['disabled'] = disabled!.toJson();
    if (shadow != null) json['shadow'] = _colorToHex(shadow!);
    if (border != null) json['border'] = _colorToHex(border!);
    if (sideMenu != null) json['sideMenu'] = _colorToHex(sideMenu!);
    if (highlights != null) json['highlights'] = highlights!.toJson();
    return json;
  }

  /// Creates from JSON.
  factory BlockNoteColorScheme.fromJson(Map<String, dynamic> json) {
    return BlockNoteColorScheme(
      editor: json['editor'] != null
          ? BlockNoteColorPair.fromJson(
              json['editor'] as Map<String, dynamic>,
            )
          : null,
      menu: json['menu'] != null
          ? BlockNoteColorPair.fromJson(
              json['menu'] as Map<String, dynamic>,
            )
          : null,
      tooltip: json['tooltip'] != null
          ? BlockNoteColorPair.fromJson(
              json['tooltip'] as Map<String, dynamic>,
            )
          : null,
      hovered: json['hovered'] != null
          ? BlockNoteColorPair.fromJson(
              json['hovered'] as Map<String, dynamic>,
            )
          : null,
      selected: json['selected'] != null
          ? BlockNoteColorPair.fromJson(
              json['selected'] as Map<String, dynamic>,
            )
          : null,
      disabled: json['disabled'] != null
          ? BlockNoteColorPair.fromJson(
              json['disabled'] as Map<String, dynamic>,
            )
          : null,
      shadow: json['shadow'] != null
          ? _hexToColor(json['shadow'] as String)
          : null,
      border: json['border'] != null
          ? _hexToColor(json['border'] as String)
          : null,
      sideMenu: json['sideMenu'] != null
          ? _hexToColor(json['sideMenu'] as String)
          : null,
      highlights: json['highlights'] != null
          ? BlockNoteHighlightColors.fromJson(
              json['highlights'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

/// Font file format.
enum BlockNoteFontFormat {
  /// WOFF2 format (recommended, best compression).
  woff2,

  /// WOFF format.
  woff,

  /// TrueType font format.
  ttf,

  /// OpenType font format.
  otf;

  /// Gets the CSS format string.
  String get cssFormat {
    switch (this) {
      case BlockNoteFontFormat.woff2:
        return 'woff2';
      case BlockNoteFontFormat.woff:
        return 'woff';
      case BlockNoteFontFormat.ttf:
        return 'truetype';
      case BlockNoteFontFormat.otf:
        return 'opentype';
    }
  }
}

/// A font file for custom font configuration.
///
/// Represents a single font file with its path, format, weight, and style.
class BlockNoteFontFile {
  /// Creates a new font file configuration.
  const BlockNoteFontFile({
    required this.path,
    required this.format,
    this.weight,
    this.style,
  });

  /// Path to the font file (relative to the asset server root).
  ///
  /// Example: './fonts/custom-font.woff2' or 'fonts/custom-font.woff2'
  final String path;

  /// Font file format.
  final BlockNoteFontFormat format;

  /// Font weight using Flutter's FontWeight enum.
  ///
  /// Common values: FontWeight.normal (400), FontWeight.bold (700)
  final FontWeight? weight;

  /// Font style using Flutter's FontStyle enum.
  ///
  /// Common values: FontStyle.normal, FontStyle.italic
  final FontStyle? style;

  /// Converts to CSS src format.
  String toCssSrc() {
    return 'url("$path") format("${format.cssFormat}")';
  }

  /// Gets the CSS font-weight value.
  int? get cssWeight => weight?.value;

  /// Gets the CSS font-style value.
  String? get cssStyle {
    if (style == null) return null;
    switch (style!) {
      case FontStyle.normal:
        return 'normal';
      case FontStyle.italic:
        return 'italic';
    }
  }
}

/// Font configuration for BlockNote editor.
///
/// Allows specifying custom fonts using Flutter-friendly API instead of raw CSS.
/// Supports both system fonts (no files needed) and custom font files.
class BlockNoteFontConfig {
  /// Creates a new font configuration.
  ///
  /// [family] is the font family name (e.g., 'CustomFont', 'Georgia').
  /// [files] is optional - if provided, @font-face CSS will be generated.
  /// If [files] is empty, [family] should be a system font.
  ///
  /// Example with system font:
  /// ```dart
  /// BlockNoteFontConfig(
  ///   family: "'Georgia', 'Times New Roman', serif",
  /// )
  /// ```
  ///
  /// Example with custom font files:
  /// ```dart
  /// BlockNoteFontConfig(
  ///   family: 'CustomFont',
  ///   files: [
  ///     BlockNoteFontFile(
  ///       path: './fonts/custom-font.woff2',
  ///       format: BlockNoteFontFormat.woff2,
  ///       weight: FontWeight.normal,
  ///       style: FontStyle.normal,
  ///     ),
  ///   ],
  /// )
  /// ```
  const BlockNoteFontConfig({
    required this.family,
    this.files = const [],
  });

  /// Font family name (CSS font-family string).
  final String family;

  /// Font files for @font-face declarations.
  ///
  /// If empty, the font is assumed to be a system font.
  final List<BlockNoteFontFile> files;

  /// Generates CSS @font-face declarations if files are provided.
  String? generateCss() {
    if (files.isEmpty) {
      return null;
    }

    final buffer = StringBuffer();
    for (final file in files) {
      buffer.writeln('@font-face {');
      buffer.writeln('  font-family: "$family";');
      buffer.write('  src: ${file.toCssSrc()};');
      if (file.cssWeight != null) {
        buffer.writeln();
        buffer.writeln('  font-weight: ${file.cssWeight};');
      } else {
        buffer.writeln();
      }
      if (file.cssStyle != null) {
        buffer.writeln('  font-style: ${file.cssStyle};');
      }
      buffer.writeln('}');
    }
    return buffer.toString();
  }
}

/// Theme configuration for BlockNote editor.
class BlockNoteTheme {
  /// Creates a new theme configuration.
  const BlockNoteTheme({
    this.colors,
    this.borderRadius,
    this.fontFamily,
    this.font,
    this.light,
    this.dark,
  });

  /// Colors for both light and dark themes (if light/dark not specified).
  final BlockNoteColorScheme? colors;

  /// Border radius in pixels.
  final double? borderRadius;

  /// Font family (CSS font-family string).
  ///
  /// **Deprecated**: Use [font] instead for a more Flutter-friendly API.
  /// This field is kept for backwards compatibility.
  @Deprecated('Use font instead')
  final String? fontFamily;

  /// Font configuration using Flutter-friendly API.
  ///
  /// Prefer this over [fontFamily] as it supports both system fonts
  /// and custom font files with automatic CSS generation.
  final BlockNoteFontConfig? font;

  /// Light theme colors (overrides colors).
  final BlockNoteColorScheme? light;

  /// Dark theme colors (overrides colors).
  final BlockNoteColorScheme? dark;

  /// Gets the effective font family string.
  ///
  /// Returns [font].family if [font] is provided, otherwise [fontFamily].
  String? get effectiveFontFamily {
    return font?.family ?? fontFamily;
  }

  /// Generates custom CSS for font @font-face declarations if needed.
  String? generateFontCss() {
    return font?.generateCss();
  }

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (colors != null) json['colors'] = colors!.toJson();
    if (borderRadius != null) json['borderRadius'] = borderRadius;
    // Use effective font family (from font config or legacy fontFamily)
    final effectiveFamily = effectiveFontFamily;
    if (effectiveFamily != null) {
      json['fontFamily'] = effectiveFamily;
    }
    if (light != null) json['light'] = light!.toJson();
    if (dark != null) json['dark'] = dark!.toJson();
    return json;
  }

  /// Creates from JSON.
  factory BlockNoteTheme.fromJson(Map<String, dynamic> json) {
    return BlockNoteTheme(
      colors: json['colors'] != null
          ? BlockNoteColorScheme.fromJson(
              json['colors'] as Map<String, dynamic>,
            )
          : null,
      borderRadius: json['borderRadius'] as double?,
      fontFamily: json['fontFamily'] as String?,
      light: json['light'] != null
          ? BlockNoteColorScheme.fromJson(
              json['light'] as Map<String, dynamic>,
            )
          : null,
      dark: json['dark'] != null
          ? BlockNoteColorScheme.fromJson(
              json['dark'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}
