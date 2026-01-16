/// Theme configuration for BlockNote editor.
///
/// Allows customization of colors, borders, shadows, font, and border radius.
/// Supports both light and dark themes.
library;

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'blocknote_theme.freezed.dart';
part 'blocknote_theme.g.dart';

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
@freezed
sealed class BlockNoteColorPair with _$BlockNoteColorPair {
  /// Creates a new color pair.
  const factory BlockNoteColorPair({
    /// Text color.
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
    required Color text,

    /// Background color.
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
    required Color background,
  }) = _BlockNoteColorPair;

  /// Creates a BlockNoteColorPair from a JSON map.
  factory BlockNoteColorPair.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteColorPairFromJson(json);
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
  pink;
}

/// Highlight colors configuration.
@freezed
sealed class BlockNoteHighlightColors with _$BlockNoteHighlightColors {
  /// Creates a new highlight colors configuration.
  const factory BlockNoteHighlightColors({
    /// Gray highlight color.
    BlockNoteColorPair? gray,

    /// Brown highlight color.
    BlockNoteColorPair? brown,

    /// Red highlight color.
    BlockNoteColorPair? red,

    /// Orange highlight color.
    BlockNoteColorPair? orange,

    /// Yellow highlight color.
    BlockNoteColorPair? yellow,

    /// Green highlight color.
    BlockNoteColorPair? green,

    /// Blue highlight color.
    BlockNoteColorPair? blue,

    /// Purple highlight color.
    BlockNoteColorPair? purple,

    /// Pink highlight color.
    BlockNoteColorPair? pink,
  }) = _BlockNoteHighlightColors;

  /// Creates a BlockNoteHighlightColors from a JSON map.
  factory BlockNoteHighlightColors.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteHighlightColorsFromJson(json);
}

/// Color scheme configuration.
@freezed
sealed class BlockNoteColorScheme with _$BlockNoteColorScheme {
  /// Creates a new color scheme.
  const factory BlockNoteColorScheme({
    /// Editor text and background colors.
    BlockNoteColorPair? editor,

    /// Menu text and background colors.
    BlockNoteColorPair? menu,

    /// Tooltip text and background colors.
    BlockNoteColorPair? tooltip,

    /// Hovered element text and background colors.
    BlockNoteColorPair? hovered,

    /// Selected element text and background colors.
    BlockNoteColorPair? selected,

    /// Disabled element text and background colors.
    BlockNoteColorPair? disabled,

    /// Shadow color.
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _colorFromJsonNullable, toJson: _colorToJsonNullable)
    Color? shadow,

    /// Border color.
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _colorFromJsonNullable, toJson: _colorToJsonNullable)
    Color? border,

    /// Side menu color.
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _colorFromJsonNullable, toJson: _colorToJsonNullable)
    Color? sideMenu,

    /// Highlight colors.
    BlockNoteHighlightColors? highlights,
  }) = _BlockNoteColorScheme;

  /// Creates a BlockNoteColorScheme from a JSON map.
  factory BlockNoteColorScheme.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteColorSchemeFromJson(json);
}

/// Helper to convert Color from JSON (nullable).
Color? _colorFromJsonNullable(String? hex) => hex != null ? _hexToColor(hex) : null;

/// Helper to convert Color to JSON (nullable).
String? _colorToJsonNullable(Color? color) => color != null ? _colorToHex(color) : null;

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
}

/// A font file for custom font configuration.
///
/// Represents a single font file with its path, format, weight, and style.
@freezed
sealed class BlockNoteFontFile with _$BlockNoteFontFile {
  /// Creates a new font file configuration.
  const factory BlockNoteFontFile({
    /// Path to the font file (relative to the asset server root).
    ///
    /// Example: './fonts/custom-font.woff2' or 'fonts/custom-font.woff2'
    required String path,

    /// Font file format.
    required BlockNoteFontFormat format,

    /// Font weight using Flutter's FontWeight enum.
    ///
    /// Common values: FontWeight.normal (400), FontWeight.bold (700)
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _fontWeightFromJson, toJson: _fontWeightToJson)
    FontWeight? weight,

    /// Font style using Flutter's FontStyle enum.
    ///
    /// Common values: FontStyle.normal, FontStyle.italic
    // ignore: invalid_annotation_target
    @JsonKey(fromJson: _fontStyleFromJson, toJson: _fontStyleToJson)
    FontStyle? style,
  }) = _BlockNoteFontFile;

  /// Creates a BlockNoteFontFile from a JSON map.
  factory BlockNoteFontFile.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteFontFileFromJson(json);
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
@freezed
sealed class BlockNoteFontConfig with _$BlockNoteFontConfig {
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
  const factory BlockNoteFontConfig({
    /// Font family name (CSS font-family string).
    required String family,

    /// Font files for @font-face declarations.
    ///
    /// If empty, the font is assumed to be a system font.
    @Default([]) List<BlockNoteFontFile> files,
  }) = _BlockNoteFontConfig;

  /// Creates a BlockNoteFontConfig from a JSON map.
  factory BlockNoteFontConfig.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteFontConfigFromJson(json);
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
@freezed
sealed class BlockNoteTheme with _$BlockNoteTheme {
  /// Creates a new theme configuration.
  const factory BlockNoteTheme({
    /// Colors for both light and dark themes (if light/dark not specified).
    BlockNoteColorScheme? colors,

    /// Border radius in pixels.
    double? borderRadius,

    /// Font configuration using Flutter-friendly API.
    ///
    /// Supports both system fonts and custom font files with automatic CSS generation.
    BlockNoteFontConfig? font,

    /// Light theme colors (overrides colors).
    BlockNoteColorScheme? light,

    /// Dark theme colors (overrides colors).
    BlockNoteColorScheme? dark,
  }) = _BlockNoteTheme;

  /// Creates a BlockNoteTheme from a JSON map.
  factory BlockNoteTheme.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteThemeFromJson(json);
}

/// Extension for BlockNoteTheme to add helper methods.
extension BlockNoteThemeExtension on BlockNoteTheme {
  /// Generates custom CSS for font @font-face declarations if needed.
  String? generateFontCss() {
    return font?.generateCss();
  }
}
