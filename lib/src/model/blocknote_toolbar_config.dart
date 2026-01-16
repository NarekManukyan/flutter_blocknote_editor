/// Toolbar configuration for BlockNote editor.
///
/// Allows customization of the formatting toolbar buttons and block type
/// select items.
library;

import 'package:flutter/material.dart';
import 'blocknote_block.dart';

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

/// Toolbar button configuration.
class BlockNoteToolbarButton {
  /// Creates a new toolbar button configuration.
  ///
  /// If [key] is not provided, it will be auto-generated based on the button
  /// type and properties (e.g., "basicTextStyleButton_bold").
  const BlockNoteToolbarButton({
    this.key,
    required this.type,
    this.basicTextStyle,
    this.textAlignment,
  });

  /// Unique key for the button (used by React for list reconciliation).
  ///
  /// If not provided, will be auto-generated based on type and properties.
  final String? key;

  /// Button type.
  final BlockNoteToolbarButtonType type;

  /// Basic text style (for BasicTextStyleButton).
  final BlockNoteBasicTextStyle? basicTextStyle;

  /// Text alignment (for TextAlignButton).
  ///
  /// Only left, center, and right are supported by BlockNote.
  final TextAlign? textAlignment;

  /// Gets the effective key for this button.
  ///
  /// Returns the provided key or generates one based on type and properties.
  String get effectiveKey {
    if (key != null) return key!;
    return _generateKey();
  }

  /// Generates a unique key based on button type and properties.
  String _generateKey() {
    switch (type) {
      case BlockNoteToolbarButtonType.basicTextStyleButton:
        if (basicTextStyle != null) {
          return '${type.name}_${basicTextStyle!.name}';
        }
        return type.name;
      case BlockNoteToolbarButtonType.textAlignButton:
        if (textAlignment != null) {
          final alignStr = _textAlignToBlockNote(textAlignment!);
          return '${type.name}_$alignStr';
        }
        return type.name;
      default:
        return type.name;
    }
  }

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'key': effectiveKey,
      'type': type.name,
    };
    if (basicTextStyle != null) {
      json['basicTextStyle'] = basicTextStyle!.name;
    }
    if (textAlignment != null) {
      // Convert Flutter TextAlign to BlockNote format
      json['textAlignment'] = _textAlignToBlockNote(textAlignment!);
    }
    return json;
  }
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
      return 'left'; // Default to left for start
    case TextAlign.end:
      return 'right'; // Default to right for end
  }
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

/// Block type select item configuration.
class BlockNoteBlockTypeItem {
  /// Creates a new block type item configuration.
  const BlockNoteBlockTypeItem({
    required this.type,
    required this.title,
    this.icon,
    this.group,
  });

  /// Block type.
  final BlockNoteBlockType type;

  /// Display title.
  final String title;

  /// Icon name or identifier (optional).
  final String? icon;

  /// Group name (optional).
  final String? group;

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'type': type.name,
      'title': title,
    };
    if (icon != null) json['icon'] = icon;
    if (group != null) json['group'] = group;
    return json;
  }
}

/// Toolbar configuration.
class BlockNoteToolbarConfig {
  /// Creates a new toolbar configuration.
  const BlockNoteToolbarConfig({
    this.buttons,
    this.blockTypeSelectItems,
    this.enabled = true,
  });

  /// Custom toolbar buttons (replaces default if provided).
  final List<BlockNoteToolbarButton>? buttons;

  /// Custom block type select items (extends default if provided).
  final List<BlockNoteBlockTypeItem>? blockTypeSelectItems;

  /// Whether the toolbar is enabled (default: true).
  final bool enabled;

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'enabled': enabled,
    };
    if (buttons != null) {
      json['buttons'] = buttons!.map((b) => b.toJson()).toList();
    }
    if (blockTypeSelectItems != null) {
      json['blockTypeSelectItems'] =
          blockTypeSelectItems!.map((i) => i.toJson()).toList();
    }
    return json;
  }
}
