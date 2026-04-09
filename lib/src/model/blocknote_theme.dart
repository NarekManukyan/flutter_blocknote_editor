/// Theme configuration for BlockNote editor.
///
/// Allows customization of colors, borders, shadows, font, and border radius.
/// Supports both light and dark themes.
library;

import 'package:flutter/material.dart';

import '../utils/collection_utils.dart';

/// Converts a Flutter Color to a hex string (e.g., "#3f3f3f").
String _colorToHex(Color color) {
  final argb = color.toARGB32();
  return '#${argb.toRadixString(16).padLeft(8, '0').substring(2)}';
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

  /// Creates a BlockNoteColorPair from a JSON map.
  factory BlockNoteColorPair.fromJson(Map<String, dynamic> json) {
    return BlockNoteColorPair(
      text: _colorFromJson(json['text'] as String),
      background: _colorFromJson(json['background'] as String),
    );
  }

  /// Converts this color pair to JSON.
  Map<String, dynamic> toJson() {
    return {
      'text': _colorToJson(text),
      'background': _colorToJson(background),
    };
  }

  BlockNoteColorPair copyWith({
    Color? text,
    Color? background,
  }) {
    return BlockNoteColorPair(
      text: text ?? this.text,
      background: background ?? this.background,
    );
  }

  @override
  String toString() => 'BlockNoteColorPair(text: $text, background: $background)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteColorPair &&
            other.text == text &&
            other.background == background;
  }

  @override
  int get hashCode => Object.hash(text, background);
}

/// Helper to convert Color from JSON.
Color _colorFromJson(String hex) => _hexToColor(hex);

/// Helper to convert Color to JSON.
String _colorToJson(Color color) => _colorToHex(color);

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
  pink,
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

  /// Creates a BlockNoteHighlightColors from a JSON map.
  factory BlockNoteHighlightColors.fromJson(Map<String, dynamic> json) {
    return BlockNoteHighlightColors(
      gray: _colorPairFromJson(json['gray']),
      brown: _colorPairFromJson(json['brown']),
      red: _colorPairFromJson(json['red']),
      orange: _colorPairFromJson(json['orange']),
      yellow: _colorPairFromJson(json['yellow']),
      green: _colorPairFromJson(json['green']),
      blue: _colorPairFromJson(json['blue']),
      purple: _colorPairFromJson(json['purple']),
      pink: _colorPairFromJson(json['pink']),
    );
  }

  /// Converts these highlight colors to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    _addIfNotNull(json, 'gray', gray?.toJson());
    _addIfNotNull(json, 'brown', brown?.toJson());
    _addIfNotNull(json, 'red', red?.toJson());
    _addIfNotNull(json, 'orange', orange?.toJson());
    _addIfNotNull(json, 'yellow', yellow?.toJson());
    _addIfNotNull(json, 'green', green?.toJson());
    _addIfNotNull(json, 'blue', blue?.toJson());
    _addIfNotNull(json, 'purple', purple?.toJson());
    _addIfNotNull(json, 'pink', pink?.toJson());
    return json;
  }

  BlockNoteHighlightColors copyWith({
    Object? gray = kUnset,
    Object? brown = kUnset,
    Object? red = kUnset,
    Object? orange = kUnset,
    Object? yellow = kUnset,
    Object? green = kUnset,
    Object? blue = kUnset,
    Object? purple = kUnset,
    Object? pink = kUnset,
  }) {
    return BlockNoteHighlightColors(
      gray: identical(gray, kUnset) ? this.gray : gray as BlockNoteColorPair?,
      brown:
          identical(brown, kUnset) ? this.brown : brown as BlockNoteColorPair?,
      red: identical(red, kUnset) ? this.red : red as BlockNoteColorPair?,
      orange: identical(orange, kUnset)
          ? this.orange
          : orange as BlockNoteColorPair?,
      yellow: identical(yellow, kUnset)
          ? this.yellow
          : yellow as BlockNoteColorPair?,
      green:
          identical(green, kUnset) ? this.green : green as BlockNoteColorPair?,
      blue: identical(blue, kUnset) ? this.blue : blue as BlockNoteColorPair?,
      purple: identical(purple, kUnset)
          ? this.purple
          : purple as BlockNoteColorPair?,
      pink: identical(pink, kUnset) ? this.pink : pink as BlockNoteColorPair?,
    );
  }

  @override
  String toString() {
    return 'BlockNoteHighlightColors(gray: $gray, brown: $brown, red: $red, orange: $orange, yellow: $yellow, green: $green, blue: $blue, purple: $purple, pink: $pink)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteHighlightColors &&
            other.gray == gray &&
            other.brown == brown &&
            other.red == red &&
            other.orange == orange &&
            other.yellow == yellow &&
            other.green == green &&
            other.blue == blue &&
            other.purple == purple &&
            other.pink == pink;
  }

  @override
  int get hashCode => Object.hash(
        gray,
        brown,
        red,
        orange,
        yellow,
        green,
        blue,
        purple,
        pink,
      );
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

  /// Creates a BlockNoteColorScheme from a JSON map.
  factory BlockNoteColorScheme.fromJson(Map<String, dynamic> json) {
    return BlockNoteColorScheme(
      editor: _colorPairFromJson(json['editor']),
      menu: _colorPairFromJson(json['menu']),
      tooltip: _colorPairFromJson(json['tooltip']),
      hovered: _colorPairFromJson(json['hovered']),
      selected: _colorPairFromJson(json['selected']),
      disabled: _colorPairFromJson(json['disabled']),
      shadow: _colorFromJsonNullable(json['shadow'] as String?),
      border: _colorFromJsonNullable(json['border'] as String?),
      sideMenu: _colorFromJsonNullable(json['sideMenu'] as String?),
      highlights: json['highlights'] == null
          ? null
          : BlockNoteHighlightColors.fromJson(
              Map<String, dynamic>.from(json['highlights'] as Map),
            ),
    );
  }

  /// Converts this color scheme to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    _addIfNotNull(json, 'editor', editor?.toJson());
    _addIfNotNull(json, 'menu', menu?.toJson());
    _addIfNotNull(json, 'tooltip', tooltip?.toJson());
    _addIfNotNull(json, 'hovered', hovered?.toJson());
    _addIfNotNull(json, 'selected', selected?.toJson());
    _addIfNotNull(json, 'disabled', disabled?.toJson());
    _addIfNotNull(json, 'shadow', _colorToJsonNullable(shadow));
    _addIfNotNull(json, 'border', _colorToJsonNullable(border));
    _addIfNotNull(json, 'sideMenu', _colorToJsonNullable(sideMenu));
    _addIfNotNull(json, 'highlights', highlights?.toJson());
    return json;
  }

  BlockNoteColorScheme copyWith({
    Object? editor = kUnset,
    Object? menu = kUnset,
    Object? tooltip = kUnset,
    Object? hovered = kUnset,
    Object? selected = kUnset,
    Object? disabled = kUnset,
    Object? shadow = kUnset,
    Object? border = kUnset,
    Object? sideMenu = kUnset,
    Object? highlights = kUnset,
  }) {
    return BlockNoteColorScheme(
      editor: identical(editor, kUnset)
          ? this.editor
          : editor as BlockNoteColorPair?,
      menu:
          identical(menu, kUnset) ? this.menu : menu as BlockNoteColorPair?,
      tooltip: identical(tooltip, kUnset)
          ? this.tooltip
          : tooltip as BlockNoteColorPair?,
      hovered: identical(hovered, kUnset)
          ? this.hovered
          : hovered as BlockNoteColorPair?,
      selected: identical(selected, kUnset)
          ? this.selected
          : selected as BlockNoteColorPair?,
      disabled: identical(disabled, kUnset)
          ? this.disabled
          : disabled as BlockNoteColorPair?,
      shadow:
          identical(shadow, kUnset) ? this.shadow : shadow as Color?,
      border:
          identical(border, kUnset) ? this.border : border as Color?,
      sideMenu: identical(sideMenu, kUnset)
          ? this.sideMenu
          : sideMenu as Color?,
      highlights: identical(highlights, kUnset)
          ? this.highlights
          : highlights as BlockNoteHighlightColors?,
    );
  }

  @override
  String toString() {
    return 'BlockNoteColorScheme(editor: $editor, menu: $menu, tooltip: $tooltip, hovered: $hovered, selected: $selected, disabled: $disabled, shadow: $shadow, border: $border, sideMenu: $sideMenu, highlights: $highlights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteColorScheme &&
            other.editor == editor &&
            other.menu == menu &&
            other.tooltip == tooltip &&
            other.hovered == hovered &&
            other.selected == selected &&
            other.disabled == disabled &&
            other.shadow == shadow &&
            other.border == border &&
            other.sideMenu == sideMenu &&
            other.highlights == highlights;
  }

  @override
  int get hashCode => Object.hash(
        editor,
        menu,
        tooltip,
        hovered,
        selected,
        disabled,
        shadow,
        border,
        sideMenu,
        highlights,
      );
}

/// Helper to convert Color from JSON (nullable).
Color? _colorFromJsonNullable(String? hex) =>
    hex != null ? _hexToColor(hex) : null;

/// Helper to convert Color to JSON (nullable).
String? _colorToJsonNullable(Color? color) =>
    color != null ? _colorToHex(color) : null;

/// Font file format.
enum BlockNoteFontFormat {
  /// WOFF2 format (recommended, best compression).
  woff2,

  /// WOFF format.
  woff,

  /// TrueType font format.
  ttf,

  /// OpenType font format.
  otf,
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

  /// Creates a BlockNoteFontFile from a JSON map.
  factory BlockNoteFontFile.fromJson(Map<String, dynamic> json) {
    final weightValue = json['weight'] as int?;
    final styleValue = json['style'] as String?;
    return BlockNoteFontFile(
      path: json['path'] as String? ?? '',
      format: BlockNoteFontFormat.values.byName(json['format'] as String),
      weight: weightValue == null ? null : _fontWeightFromJson(weightValue),
      style: styleValue == null ? null : _fontStyleFromJson(styleValue),
    );
  }

  /// Converts this font file to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'path': path,
      'format': format.name,
    };
    if (weight != null) {
      json['weight'] = _fontWeightToJson(weight);
    }
    if (style != null) {
      json['style'] = _fontStyleToJson(style);
    }
    return json;
  }

  BlockNoteFontFile copyWith({
    String? path,
    BlockNoteFontFormat? format,
    Object? weight = kUnset,
    Object? style = kUnset,
  }) {
    return BlockNoteFontFile(
      path: path ?? this.path,
      format: format ?? this.format,
      weight: identical(weight, kUnset) ? this.weight : weight as FontWeight?,
      style: identical(style, kUnset) ? this.style : style as FontStyle?,
    );
  }

  @override
  String toString() {
    return 'BlockNoteFontFile(path: $path, format: $format, weight: $weight, style: $style)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteFontFile &&
            other.path == path &&
            other.format == format &&
            other.weight == weight &&
            other.style == style;
  }

  @override
  int get hashCode => Object.hash(path, format, weight, style);
}

/// Extension for BlockNoteFontFile to add CSS-related getters.
extension BlockNoteFontFileExtension on BlockNoteFontFile {
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

/// Gets the CSS format string.
extension BlockNoteFontFormatExtension on BlockNoteFontFormat {
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

/// Helper to convert FontWeight from JSON.
FontWeight _fontWeightFromJson(int value) {
  // FontWeight values are typically 100-900 in increments of 100
  // Clamp to valid range and find closest match
  final clamped = (value.clamp(100, 900) / 100).round() * 100;
  return FontWeight.values.firstWhere(
    (w) => w.value == clamped,
    orElse: () => FontWeight.normal,
  );
}

/// Helper to convert FontWeight to JSON.
int? _fontWeightToJson(FontWeight? weight) => weight?.value;

/// Helper to convert FontStyle from JSON.
FontStyle _fontStyleFromJson(String value) {
  switch (value) {
    case 'normal':
      return FontStyle.normal;
    case 'italic':
      return FontStyle.italic;
    default:
      return FontStyle.normal;
  }
}

/// Helper to convert FontStyle to JSON.
String _fontStyleToJson(FontStyle? style) {
  if (style == null) return 'normal';
  switch (style) {
    case FontStyle.normal:
      return 'normal';
    case FontStyle.italic:
      return 'italic';
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

  /// Creates a BlockNoteFontConfig from a JSON map.
  factory BlockNoteFontConfig.fromJson(Map<String, dynamic> json) {
    return BlockNoteFontConfig(
      family: json['family'] as String? ?? '',
      files: (json['files'] as List<dynamic>? ?? [])
          .whereType<Map>()
          .map((file) => BlockNoteFontFile.fromJson(
                Map<String, dynamic>.from(file),
              ))
          .toList(),
    );
  }

  /// Converts this font configuration to JSON.
  Map<String, dynamic> toJson() {
    return {
      'family': family,
      'files': files.map((file) => file.toJson()).toList(),
    };
  }

  BlockNoteFontConfig copyWith({
    String? family,
    List<BlockNoteFontFile>? files,
  }) {
    return BlockNoteFontConfig(
      family: family ?? this.family,
      files: files ?? this.files,
    );
  }

  @override
  String toString() => 'BlockNoteFontConfig(family: $family, files: $files)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteFontConfig &&
            other.family == family &&
            listEquals(other.files, files);
  }

  @override
  int get hashCode => Object.hash(family, listHash(files));
}

/// Extension for BlockNoteFontFile to add toCssSrc method.
extension BlockNoteFontFileCssExtension on BlockNoteFontFile {
  /// Converts to CSS src format.
  String toCssSrc() {
    return 'url("$path") format("${format.cssFormat}")';
  }
}

/// Extension for BlockNoteFontConfig to add generateCss method.
extension BlockNoteFontConfigExtension on BlockNoteFontConfig {
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
    this.font,
    this.light,
    this.dark,
  });

  /// Colors for both light and dark themes (if light/dark not specified).
  final BlockNoteColorScheme? colors;

  /// Border radius in pixels.
  final double? borderRadius;

  /// Font configuration using Flutter-friendly API.
  ///
  /// Supports both system fonts and custom font files with automatic CSS generation.
  final BlockNoteFontConfig? font;

  /// Light theme colors (overrides colors).
  final BlockNoteColorScheme? light;

  /// Dark theme colors (overrides colors).
  final BlockNoteColorScheme? dark;

  /// Creates a BlockNoteTheme from a JSON map.
  factory BlockNoteTheme.fromJson(Map<String, dynamic> json) {
    return BlockNoteTheme(
      colors: json['colors'] == null
          ? null
          : BlockNoteColorScheme.fromJson(
              Map<String, dynamic>.from(json['colors'] as Map),
            ),
      borderRadius: (json['borderRadius'] as num?)?.toDouble(),
      font: json['font'] == null
          ? null
          : BlockNoteFontConfig.fromJson(
              Map<String, dynamic>.from(json['font'] as Map),
            ),
      light: json['light'] == null
          ? null
          : BlockNoteColorScheme.fromJson(
              Map<String, dynamic>.from(json['light'] as Map),
            ),
      dark: json['dark'] == null
          ? null
          : BlockNoteColorScheme.fromJson(
              Map<String, dynamic>.from(json['dark'] as Map),
            ),
    );
  }

  /// Converts this theme to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    _addIfNotNull(json, 'colors', colors?.toJson());
    _addIfNotNull(json, 'borderRadius', borderRadius);
    _addIfNotNull(json, 'font', font?.toJson());
    _addIfNotNull(json, 'light', light?.toJson());
    _addIfNotNull(json, 'dark', dark?.toJson());
    return json;
  }

  BlockNoteTheme copyWith({
    Object? colors = kUnset,
    Object? borderRadius = kUnset,
    Object? font = kUnset,
    Object? light = kUnset,
    Object? dark = kUnset,
  }) {
    return BlockNoteTheme(
      colors: identical(colors, kUnset) ? this.colors : colors as BlockNoteColorScheme?,
      borderRadius: identical(borderRadius, kUnset)
          ? this.borderRadius
          : borderRadius as double?,
      font: identical(font, kUnset) ? this.font : font as BlockNoteFontConfig?,
      light: identical(light, kUnset) ? this.light : light as BlockNoteColorScheme?,
      dark: identical(dark, kUnset) ? this.dark : dark as BlockNoteColorScheme?,
    );
  }

  @override
  String toString() {
    return 'BlockNoteTheme(colors: $colors, borderRadius: $borderRadius, font: $font, light: $light, dark: $dark)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteTheme &&
            other.colors == colors &&
            other.borderRadius == borderRadius &&
            other.font == font &&
            other.light == light &&
            other.dark == dark;
  }

  @override
  int get hashCode =>
      Object.hash(colors, borderRadius, font, light, dark);
}

/// Extension for BlockNoteTheme to add helper methods.
extension BlockNoteThemeExtension on BlockNoteTheme {
  /// Generates custom CSS for font @font-face declarations if needed.
  String? generateFontCss() {
    return font?.generateCss();
  }
}

BlockNoteColorPair? _colorPairFromJson(Object? value) {
  if (value is Map) {
    return BlockNoteColorPair.fromJson(Map<String, dynamic>.from(value));
  }
  return null;
}

void _addIfNotNull(
  Map<String, dynamic> target,
  String key,
  Object? value,
) {
  if (value != null) {
    target[key] = value;
  }
}

