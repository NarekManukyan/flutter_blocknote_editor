/// Slash command configuration for BlockNote editor.
///
/// Allows customization of the slash menu items that appear when the user
/// types "/" in the editor.
library;

/// Slash command item configuration.
class BlockNoteSlashCommandItem {
  /// Creates a new slash command item.
  const BlockNoteSlashCommandItem({
    required this.title,
    required this.onItemClick,
    this.subtext,
    this.badge,
    this.aliases,
    this.group,
    this.icon,
  });

  /// Title of the command item.
  final String title;

  /// JavaScript function code to execute when the item is clicked.
  ///
  /// This should be a string containing JavaScript code that will be
  /// evaluated. The code has access to the `editor` variable.
  ///
  /// Example: "editor.insertBlocks([{type: 'paragraph', content: 'Hello'}], editor.getTextCursorPosition().block, 'after');"
  final String onItemClick;

  /// Subtitle text (optional).
  final String? subtext;

  /// Badge text (optional, typically shows keyboard shortcut).
  final String? badge;

  /// Aliases for filtering (optional).
  final List<String>? aliases;

  /// Group name (optional).
  final String? group;

  /// Icon identifier (optional).
  final String? icon;

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'title': title,
      'onItemClick': onItemClick,
    };
    if (subtext != null) json['subtext'] = subtext;
    if (badge != null) json['badge'] = badge;
    if (aliases != null) json['aliases'] = aliases;
    if (group != null) json['group'] = group;
    if (icon != null) json['icon'] = icon;
    return json;
  }
}

/// Slash command configuration.
class BlockNoteSlashCommandConfig {
  /// Creates a new slash command configuration.
  const BlockNoteSlashCommandConfig({
    this.items,
    this.enabled = true,
    this.triggerCharacter = '/',
  });

  /// Custom slash command items (extends default if provided).
  final List<BlockNoteSlashCommandItem>? items;

  /// Whether the slash menu is enabled (default: true).
  final bool enabled;

  /// Trigger character (default: '/').
  final String triggerCharacter;

  /// Converts to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'enabled': enabled,
      'triggerCharacter': triggerCharacter,
    };
    if (items != null) {
      json['items'] = items!.map((i) => i.toJson()).toList();
    }
    return json;
  }
}
