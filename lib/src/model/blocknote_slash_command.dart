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
