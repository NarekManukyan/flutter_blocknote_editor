/// Toolbar configuration for BlockNote editor.
///
/// Allows customization of the formatting toolbar buttons and block type
/// select items.
library;

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'blocknote_block.dart';

part 'blocknote_toolbar_config.freezed.dart';
part 'blocknote_toolbar_config.g.dart';

/// Basic text styles for formatting toolbar buttons.
enum BlockNoteBasicTextStyle {
  /// Bold text style.
  bold,

  /// Italic text style.
  italic,

  /// Underline text style.
  underline,

  /// Strikethrough text style.
  strike,

  /// Code text style.
  code,
}

/// Toolbar button types.
enum BlockNoteToolbarButtonType {
  /// Block type select dropdown.
  blockTypeSelect,

  /// File caption button.
  fileCaptionButton,

  /// File replace button.
  fileReplaceButton,

  /// Basic text style button (bold, italic, underline, strike, code).
  basicTextStyleButton,

  /// Text align button (left, center, right).
  textAlignButton,

  /// Color style button.
  colorStyleButton,

  /// Nest block button.
  nestBlockButton,

  /// Unnest block button.
  unnestBlockButton,

  /// Create link button.
  createLinkButton,
}

/// Converts Flutter TextAlign to BlockNote text alignment string.
String _textAlignToBlockNote(TextAlign align) {
  switch (align) {
    case TextAlign.left:
      return 'left';
    case TextAlign.center:
      return 'center';
    case TextAlign.right:
      return 'right';
    case TextAlign.justify:
      return 'justify';
    case TextAlign.start:
      return 'left';
    case TextAlign.end:
      return 'right';
  }
}

/// Converts BlockNote text alignment string to Flutter TextAlign.
TextAlign _textAlignFromBlockNote(String align) {
  switch (align) {
    case 'left':
      return TextAlign.left;
    case 'center':
      return TextAlign.center;
    case 'right':
      return TextAlign.right;
    case 'justify':
      return TextAlign.justify;
    default:
      return TextAlign.left;
  }
}

/// Generates a unique key based on button type and properties.
String _generateToolbarButtonKey(
  BlockNoteToolbarButtonType type,
  BlockNoteBasicTextStyle? basicTextStyle,
  TextAlign? textAlignment,
) {
  switch (type) {
    case BlockNoteToolbarButtonType.basicTextStyleButton:
      if (basicTextStyle != null) {
        return '${type.name}_${basicTextStyle.name}';
      }
      return type.name;
    case BlockNoteToolbarButtonType.textAlignButton:
      if (textAlignment != null) {
        final alignStr = _textAlignToBlockNote(textAlignment);
        return '${type.name}_$alignStr';
      }
      return type.name;
    default:
      return type.name;
  }
}

/// Toolbar button configuration.
@freezed
sealed class BlockNoteToolbarButton with _$BlockNoteToolbarButton {
  /// Creates a new toolbar button configuration.
  ///
  /// If [key] is not provided, it will be auto-generated based on the button
  /// type and properties (e.g., "basicTextStyleButton_bold").
  const factory BlockNoteToolbarButton({
    /// Unique key for the button (used by React for list reconciliation).
    ///
    /// If not provided, will be auto-generated based on type and properties.
    String? key,

    /// Button type.
    required BlockNoteToolbarButtonType type,

    /// Basic text style (for BasicTextStyleButton).
    BlockNoteBasicTextStyle? basicTextStyle,

    /// Text alignment (for TextAlignButton).
    ///
    /// Only left, center, and right are supported by BlockNote.
    // ignore: invalid_annotation_target
    @JsonKey(
      fromJson: _textAlignFromBlockNoteNullable,
      toJson: _textAlignToBlockNoteNullable,
    )
    TextAlign? textAlignment,
  }) = _BlockNoteToolbarButton;

  /// Creates a BlockNoteToolbarButton from a JSON map.
  factory BlockNoteToolbarButton.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteToolbarButtonFromJson(json);
}

/// Extension to add effectiveKey getter.
extension BlockNoteToolbarButtonExtension on BlockNoteToolbarButton {
  /// Gets the effective key for this button.
  ///
  /// Returns the provided key or generates one based on type and properties.
  String get effectiveKey {
    if (key != null) return key!;
    return _generateToolbarButtonKey(type, basicTextStyle, textAlignment);
  }
}

/// Helper to convert TextAlign to JSON string (nullable).
String? _textAlignToBlockNoteNullable(TextAlign? align) {
  return align != null ? _textAlignToBlockNote(align) : null;
}

/// Helper to convert JSON string to TextAlign (nullable).
TextAlign? _textAlignFromBlockNoteNullable(String? align) {
  return align != null ? _textAlignFromBlockNote(align) : null;
}

/// Block type select item configuration.
@freezed
sealed class BlockNoteBlockTypeItem with _$BlockNoteBlockTypeItem {
  /// Creates a new block type item configuration.
  const factory BlockNoteBlockTypeItem({
    /// Block type.
    required BlockNoteBlockType type,

    /// Display title.
    required String title,

    /// Icon name or identifier (optional).
    String? icon,

    /// Group name (optional).
    String? group,
  }) = _BlockNoteBlockTypeItem;

  /// Creates a BlockNoteBlockTypeItem from a JSON map.
  factory BlockNoteBlockTypeItem.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteBlockTypeItemFromJson(json);
}

/// Toolbar configuration.
@freezed
sealed class BlockNoteToolbarConfig with _$BlockNoteToolbarConfig {
  /// Creates a new toolbar configuration.
  const factory BlockNoteToolbarConfig({
    /// Custom toolbar buttons (replaces default if provided).
    // ignore: invalid_annotation_target
    @JsonKey(toJson: _buttonsToJson)
    List<BlockNoteToolbarButton>? buttons,

    /// Custom block type select items (extends default if provided).
    List<BlockNoteBlockTypeItem>? blockTypeSelectItems,

    /// Whether the toolbar is enabled (default: true).
    @Default(true) bool enabled,
  }) = _BlockNoteToolbarConfig;

  /// Creates a BlockNoteToolbarConfig from a JSON map.
  factory BlockNoteToolbarConfig.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteToolbarConfigFromJson(json);
}

/// Helper to convert buttons to JSON with effectiveKey.
List<Map<String, dynamic>>? _buttonsToJson(
  List<BlockNoteToolbarButton>? buttons,
) {
  if (buttons == null) return null;
  return buttons.map((button) {
    final json = button.toJson();
    // Replace 'key' with effectiveKey if key was null
    if (button.key == null) {
      json['key'] = button.effectiveKey;
    }
    return json;
  }).toList();
}
