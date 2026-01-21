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

  /// Creates a BlockNoteToolbarButton from a JSON map.
  factory BlockNoteToolbarButton.fromJson(Map<String, dynamic> json) {
    return BlockNoteToolbarButton(
      key: json['key'] as String?,
      type: BlockNoteToolbarButtonType.values.byName(json['type'] as String),
      basicTextStyle: json['basicTextStyle'] == null
          ? null
          : BlockNoteBasicTextStyle.values
              .byName(json['basicTextStyle'] as String),
      textAlignment: _textAlignFromBlockNoteNullable(
        json['textAlignment'] as String?,
      ),
    );
  }

  /// Converts this toolbar button to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'type': type.name,
    };
    if (key != null) {
      json['key'] = key;
    }
    if (basicTextStyle != null) {
      json['basicTextStyle'] = basicTextStyle!.name;
    }
    if (textAlignment != null) {
      json['textAlignment'] = _textAlignToBlockNoteNullable(textAlignment);
    }
    return json;
  }

  BlockNoteToolbarButton copyWith({
    Object? key = _unset,
    BlockNoteToolbarButtonType? type,
    Object? basicTextStyle = _unset,
    Object? textAlignment = _unset,
  }) {
    return BlockNoteToolbarButton(
      key: identical(key, _unset) ? this.key : key as String?,
      type: type ?? this.type,
      basicTextStyle: identical(basicTextStyle, _unset)
          ? this.basicTextStyle
          : basicTextStyle as BlockNoteBasicTextStyle?,
      textAlignment: identical(textAlignment, _unset)
          ? this.textAlignment
          : textAlignment as TextAlign?,
    );
  }

  @override
  String toString() {
    return 'BlockNoteToolbarButton(key: $key, type: $type, basicTextStyle: $basicTextStyle, textAlignment: $textAlignment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteToolbarButton &&
            other.key == key &&
            other.type == type &&
            other.basicTextStyle == basicTextStyle &&
            other.textAlignment == textAlignment;
  }

  @override
  int get hashCode =>
      Object.hash(key, type, basicTextStyle, textAlignment);
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

  /// Creates a BlockNoteBlockTypeItem from a JSON map.
  factory BlockNoteBlockTypeItem.fromJson(Map<String, dynamic> json) {
    return BlockNoteBlockTypeItem(
      type: BlockNoteBlockType.values.byName(json['type'] as String),
      title: json['title'] as String? ?? '',
      icon: json['icon'] as String?,
      group: json['group'] as String?,
    );
  }

  /// Converts this block type item to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'type': type.name,
      'title': title,
    };
    if (icon != null) {
      json['icon'] = icon;
    }
    if (group != null) {
      json['group'] = group;
    }
    return json;
  }

  BlockNoteBlockTypeItem copyWith({
    BlockNoteBlockType? type,
    String? title,
    Object? icon = _unset,
    Object? group = _unset,
  }) {
    return BlockNoteBlockTypeItem(
      type: type ?? this.type,
      title: title ?? this.title,
      icon: identical(icon, _unset) ? this.icon : icon as String?,
      group: identical(group, _unset) ? this.group : group as String?,
    );
  }

  @override
  String toString() {
    return 'BlockNoteBlockTypeItem(type: $type, title: $title, icon: $icon, group: $group)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteBlockTypeItem &&
            other.type == type &&
            other.title == title &&
            other.icon == icon &&
            other.group == group;
  }

  @override
  int get hashCode => Object.hash(type, title, icon, group);
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

  /// Creates a BlockNoteToolbarConfig from a JSON map.
  factory BlockNoteToolbarConfig.fromJson(Map<String, dynamic> json) {
    return BlockNoteToolbarConfig(
      buttons: (json['buttons'] as List<dynamic>?)
          ?.whereType<Map>()
          .map((button) => BlockNoteToolbarButton.fromJson(
                Map<String, dynamic>.from(button),
              ))
          .toList(),
      blockTypeSelectItems: (json['blockTypeSelectItems'] as List<dynamic>?)
          ?.whereType<Map>()
          .map((item) => BlockNoteBlockTypeItem.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .toList(),
      enabled: json['enabled'] as bool? ?? true,
    );
  }

  /// Converts this toolbar config to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'enabled': enabled,
    };
    if (buttons != null) {
      json['buttons'] = _buttonsToJson(buttons);
    }
    if (blockTypeSelectItems != null) {
      json['blockTypeSelectItems'] =
          blockTypeSelectItems!.map((item) => item.toJson()).toList();
    }
    return json;
  }

  BlockNoteToolbarConfig copyWith({
    Object? buttons = _unset,
    Object? blockTypeSelectItems = _unset,
    bool? enabled,
  }) {
    return BlockNoteToolbarConfig(
      buttons: identical(buttons, _unset)
          ? this.buttons
          : buttons as List<BlockNoteToolbarButton>?,
      blockTypeSelectItems: identical(blockTypeSelectItems, _unset)
          ? this.blockTypeSelectItems
          : blockTypeSelectItems as List<BlockNoteBlockTypeItem>?,
      enabled: enabled ?? this.enabled,
    );
  }

  @override
  String toString() {
    return 'BlockNoteToolbarConfig(buttons: $buttons, blockTypeSelectItems: $blockTypeSelectItems, enabled: $enabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteToolbarConfig &&
            _listEquals(other.buttons, buttons) &&
            _listEquals(other.blockTypeSelectItems, blockTypeSelectItems) &&
            other.enabled == enabled;
  }

  @override
  int get hashCode =>
      Object.hash(_listHash(buttons), _listHash(blockTypeSelectItems), enabled);
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

const Object _unset = Object();

bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null || a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

int _listHash<T>(List<T>? list) {
  if (list == null) return 0;
  return Object.hashAll(list);
}
