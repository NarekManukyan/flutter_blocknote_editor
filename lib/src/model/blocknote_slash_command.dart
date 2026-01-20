/// Slash command configuration for BlockNote editor.
///
/// Allows customization of the slash menu items that appear when the user
/// types "/" in the editor.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'blocknote_slash_command.freezed.dart';
part 'blocknote_slash_command.g.dart';

/// Slash command item configuration.
@freezed
sealed class BlockNoteSlashCommandItem with _$BlockNoteSlashCommandItem {
  /// Creates a new slash command item.
  const factory BlockNoteSlashCommandItem({
    /// Title of the command item.
    required String title,

    /// JavaScript function code to execute when the item is clicked.
    ///
    /// This should be a string containing JavaScript code that will be
    /// evaluated. The code has access to the `editor` variable.
    ///
    /// Example: "editor.insertBlocks([{type: 'paragraph', content: 'Hello'}], editor.getTextCursorPosition().block, 'after');"
    required String onItemClick,

    /// Subtitle text (optional).
    String? subtext,

    /// Badge text (optional, typically shows keyboard shortcut).
    String? badge,

    /// Aliases for filtering (optional).
    List<String>? aliases,

    /// Group name (optional).
    String? group,

    /// Icon identifier (optional).
    String? icon,
  }) = _BlockNoteSlashCommandItem;

  /// Creates a slash command that inserts a paragraph block.
  factory BlockNoteSlashCommandItem.paragraph({
    required String title,

    /// Optional text content for the inserted block.
    String? content,
    String? subtext,
    String? badge,
    List<String>? aliases,
    String? group,
    String? icon,
  }) {
    return BlockNoteSlashCommandItem(
      title: title,
      onItemClick: _insertParagraphJs(content: content),
      subtext: subtext,
      badge: badge,
      aliases: aliases,
      group: group,
      icon: icon,
    );
  }

  /// Creates a slash command that inserts a heading level 1 block.
  factory BlockNoteSlashCommandItem.heading1({
    required String title,

    /// Optional text content for the inserted block.
    String? content,
    String? subtext,
    String? badge,
    List<String>? aliases,
    String? group,
    String? icon,
  }) {
    return BlockNoteSlashCommandItem(
      title: title,
      onItemClick: _insertHeading1Js(content: content),
      subtext: subtext,
      badge: badge,
      aliases: aliases,
      group: group,
      icon: icon,
    );
  }

  /// Creates a slash command that inserts a heading level 2 block.
  factory BlockNoteSlashCommandItem.heading2({
    required String title,

    /// Optional text content for the inserted block.
    String? content,
    String? subtext,
    String? badge,
    List<String>? aliases,
    String? group,
    String? icon,
  }) {
    return BlockNoteSlashCommandItem(
      title: title,
      onItemClick: _insertHeading2Js(content: content),
      subtext: subtext,
      badge: badge,
      aliases: aliases,
      group: group,
      icon: icon,
    );
  }

  /// Creates a slash command that inserts a heading level 3 block.
  factory BlockNoteSlashCommandItem.heading3({
    required String title,

    /// Optional text content for the inserted block.
    String? content,
    String? subtext,
    String? badge,
    List<String>? aliases,
    String? group,
    String? icon,
  }) {
    return BlockNoteSlashCommandItem(
      title: title,
      onItemClick: _insertHeading3Js(content: content),
      subtext: subtext,
      badge: badge,
      aliases: aliases,
      group: group,
      icon: icon,
    );
  }

  /// Creates a slash command that inserts a quote block.
  factory BlockNoteSlashCommandItem.quote({
    required String title,

    /// Optional text content for the inserted block.
    String? content,
    String? subtext,
    String? badge,
    List<String>? aliases,
    String? group,
    String? icon,
  }) {
    return BlockNoteSlashCommandItem(
      title: title,
      onItemClick: _insertQuoteJs(content: content),
      subtext: subtext,
      badge: badge,
      aliases: aliases,
      group: group,
      icon: icon,
    );
  }

  /// Creates a slash command that inserts a toggle list item block.
  factory BlockNoteSlashCommandItem.toggleList({
    required String title,

    /// Optional text content for the inserted block.
    String? content,
    String? subtext,
    String? badge,
    List<String>? aliases,
    String? group,
    String? icon,
  }) {
    return BlockNoteSlashCommandItem(
      title: title,
      onItemClick: _insertToggleListItemJs(content: content),
      subtext: subtext,
      badge: badge,
      aliases: aliases,
      group: group,
      icon: icon,
    );
  }

  /// Creates a slash command that inserts a bullet list item block.
  factory BlockNoteSlashCommandItem.bulletList({
    required String title,

    /// Optional text content for the inserted block.
    String? content,
    String? subtext,
    String? badge,
    List<String>? aliases,
    String? group,
    String? icon,
  }) {
    return BlockNoteSlashCommandItem(
      title: title,
      onItemClick: _insertBulletListItemJs(content: content),
      subtext: subtext,
      badge: badge,
      aliases: aliases,
      group: group,
      icon: icon,
    );
  }

  /// Creates a slash command that inserts a numbered list item block.
  factory BlockNoteSlashCommandItem.numberedList({
    required String title,

    /// Optional text content for the inserted block.
    String? content,
    String? subtext,
    String? badge,
    List<String>? aliases,
    String? group,
    String? icon,
  }) {
    return BlockNoteSlashCommandItem(
      title: title,
      onItemClick: _insertNumberedListItemJs(content: content),
      subtext: subtext,
      badge: badge,
      aliases: aliases,
      group: group,
      icon: icon,
    );
  }

  /// Creates a slash command that inserts a check list item block.
  factory BlockNoteSlashCommandItem.checkList({
    required String title,

    /// Optional text content for the inserted block.
    String? content,
    String? subtext,
    String? badge,
    List<String>? aliases,
    String? group,
    String? icon,
  }) {
    return BlockNoteSlashCommandItem(
      title: title,
      onItemClick: _insertCheckListItemJs(content: content),
      subtext: subtext,
      badge: badge,
      aliases: aliases,
      group: group,
      icon: icon,
    );
  }

  static String _insertParagraphJs({String? content}) {
    return _insertBlockJs(type: 'paragraph', content: content);
  }

  static String _insertHeading1Js({String? content}) {
    return _insertBlockJs(
      type: 'heading',
      propsJs: '{ level: 1 }',
      content: content,
    );
  }

  static String _insertHeading2Js({String? content}) {
    return _insertBlockJs(
      type: 'heading',
      propsJs: '{ level: 2 }',
      content: content,
    );
  }

  static String _insertHeading3Js({String? content}) {
    return _insertBlockJs(
      type: 'heading',
      propsJs: '{ level: 3 }',
      content: content,
    );
  }

  static String _insertQuoteJs({String? content}) {
    return _insertBlockJs(type: 'quote', content: content);
  }

  static String _insertToggleListItemJs({String? content}) {
    return _insertBlockJs(type: 'toggleListItem', content: content);
  }

  static String _insertBulletListItemJs({String? content}) {
    return _insertBlockJs(type: 'bulletListItem', content: content);
  }

  static String _insertNumberedListItemJs({String? content}) {
    return _insertBlockJs(type: 'numberedListItem', content: content);
  }

  static String _insertCheckListItemJs({String? content}) {
    return _insertBlockJs(type: 'checkListItem', content: content);
  }

  static String _insertBlockJs({
    required String type,
    String? propsJs,
    String? content,
  }) {
    final contentJs = _buildTextContentJs(content);
    final propsSegment = propsJs == null ? '' : ', props: $propsJs';
    return "editor.insertBlocks([{type: '$type'$propsSegment, content: $contentJs}], editor.getTextCursorPosition().block, 'after');";
  }

  static String _buildTextContentJs(String? content) {
    if (content == null || content.isEmpty) {
      return '[]';
    }

    final escapedContent = _escapeJsString(content);
    return "[{type: 'text', text: '$escapedContent'}]";
  }

  static String _escapeJsString(String value) {
    return value.replaceAll('\\', r'\\').replaceAll("'", r"\'");
  }

  /// Creates a BlockNoteSlashCommandItem from a JSON map.
  factory BlockNoteSlashCommandItem.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteSlashCommandItemFromJson(json);
}

/// Slash command configuration.
@freezed
sealed class BlockNoteSlashCommandConfig with _$BlockNoteSlashCommandConfig {
  /// Creates a new slash command configuration.
  const factory BlockNoteSlashCommandConfig({
    /// Custom slash command items (extends default if provided).
    List<BlockNoteSlashCommandItem>? items,

    /// Whether the slash menu is enabled (default: true).
    @Default(true) bool enabled,

    /// Trigger character (default: '/').
    @Default('/') String triggerCharacter,
  }) = _BlockNoteSlashCommandConfig;

  /// Creates a BlockNoteSlashCommandConfig from a JSON map.
  factory BlockNoteSlashCommandConfig.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteSlashCommandConfigFromJson(json);
}
