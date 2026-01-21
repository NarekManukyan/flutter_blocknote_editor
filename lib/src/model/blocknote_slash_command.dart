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
  factory BlockNoteSlashCommandItem.fromJson(Map<String, dynamic> json) {
    return BlockNoteSlashCommandItem(
      title: json['title'] as String? ?? '',
      onItemClick: json['onItemClick'] as String? ?? '',
      subtext: json['subtext'] as String?,
      badge: json['badge'] as String?,
      aliases: (json['aliases'] as List<dynamic>?)
          ?.whereType<String>()
          .toList(),
      group: json['group'] as String?,
      icon: json['icon'] as String?,
    );
  }

  /// Converts this slash command item to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'title': title,
      'onItemClick': onItemClick,
    };
    if (subtext != null) {
      json['subtext'] = subtext;
    }
    if (badge != null) {
      json['badge'] = badge;
    }
    if (aliases != null) {
      json['aliases'] = aliases;
    }
    if (group != null) {
      json['group'] = group;
    }
    if (icon != null) {
      json['icon'] = icon;
    }
    return json;
  }

  BlockNoteSlashCommandItem copyWith({
    String? title,
    String? onItemClick,
    Object? subtext = _unset,
    Object? badge = _unset,
    Object? aliases = _unset,
    Object? group = _unset,
    Object? icon = _unset,
  }) {
    return BlockNoteSlashCommandItem(
      title: title ?? this.title,
      onItemClick: onItemClick ?? this.onItemClick,
      subtext: identical(subtext, _unset) ? this.subtext : subtext as String?,
      badge: identical(badge, _unset) ? this.badge : badge as String?,
      aliases: identical(aliases, _unset)
          ? this.aliases
          : aliases as List<String>?,
      group: identical(group, _unset) ? this.group : group as String?,
      icon: identical(icon, _unset) ? this.icon : icon as String?,
    );
  }

  @override
  String toString() {
    return 'BlockNoteSlashCommandItem(title: $title, onItemClick: $onItemClick, subtext: $subtext, badge: $badge, aliases: $aliases, group: $group, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteSlashCommandItem &&
            other.title == title &&
            other.onItemClick == onItemClick &&
            other.subtext == subtext &&
            other.badge == badge &&
            _listEquals(other.aliases, aliases) &&
            other.group == group &&
            other.icon == icon;
  }

  @override
  int get hashCode => Object.hash(
        title,
        onItemClick,
        subtext,
        badge,
        _listHash(aliases),
        group,
        icon,
      );
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

  /// Creates a BlockNoteSlashCommandConfig from a JSON map.
  factory BlockNoteSlashCommandConfig.fromJson(Map<String, dynamic> json) {
    return BlockNoteSlashCommandConfig(
      items: (json['items'] as List<dynamic>?)
          ?.whereType<Map>()
          .map((item) => BlockNoteSlashCommandItem.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .toList(),
      enabled: json['enabled'] as bool? ?? true,
      triggerCharacter: json['triggerCharacter'] as String? ?? '/',
    );
  }

  /// Converts this slash command config to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'enabled': enabled,
      'triggerCharacter': triggerCharacter,
    };
    if (items != null) {
      json['items'] = items!.map((item) => item.toJson()).toList();
    }
    return json;
  }

  BlockNoteSlashCommandConfig copyWith({
    Object? items = _unset,
    bool? enabled,
    String? triggerCharacter,
  }) {
    return BlockNoteSlashCommandConfig(
      items: identical(items, _unset)
          ? this.items
          : items as List<BlockNoteSlashCommandItem>?,
      enabled: enabled ?? this.enabled,
      triggerCharacter: triggerCharacter ?? this.triggerCharacter,
    );
  }

  @override
  String toString() {
    return 'BlockNoteSlashCommandConfig(items: $items, enabled: $enabled, triggerCharacter: $triggerCharacter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteSlashCommandConfig &&
            _listEquals(other.items, items) &&
            other.enabled == enabled &&
            other.triggerCharacter == triggerCharacter;
  }

  @override
  int get hashCode =>
      Object.hash(_listHash(items), enabled, triggerCharacter);
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
