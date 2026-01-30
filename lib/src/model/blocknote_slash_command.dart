/// Slash command configuration for BlockNote editor.
///
/// Allows customization of the slash menu items that appear when the user
/// types "/" in the editor.
library;

import 'dart:convert';

import 'package:flutter/services.dart';

/// Enumeration of default slash commands provided by BlockNote.
///
/// Use this enum to easily reference and specify which default slash commands
/// should be available in the slash menu.
enum BlockNoteDefaultSlashCommand {
  /// Paragraph/Text block command.
  paragraph,

  /// Heading level 1 command.
  heading1,

  /// Heading level 2 command.
  heading2,

  /// Heading level 3 command.
  heading3,

  /// Toggle heading level 1 command.
  toggleHeading1,

  /// Toggle heading level 2 command.
  toggleHeading2,

  /// Toggle heading level 3 command.
  toggleHeading3,

  /// Bullet list command.
  bulletList,

  /// Numbered list command.
  numberedList,

  /// Check list command.
  checkList,

  /// Quote block command.
  quote,

  /// Toggle list command.
  toggleList,

  /// Code block command.
  codeBlock,

  /// Image block command.
  image,

  /// Audio block command.
  audio,

  /// Video block command.
  video,

  /// File block command.
  file,

  /// Table block command.
  table;

  /// Returns the expected title for this default slash command.
  ///
  /// These titles match the default titles used by BlockNote's
  /// getDefaultReactSlashMenuItems function.
  String get title {
    switch (this) {
      case BlockNoteDefaultSlashCommand.paragraph:
        return 'Paragraph';
      case BlockNoteDefaultSlashCommand.heading1:
        return 'Heading 1';
      case BlockNoteDefaultSlashCommand.heading2:
        return 'Heading 2';
      case BlockNoteDefaultSlashCommand.heading3:
        return 'Heading 3';
      case BlockNoteDefaultSlashCommand.toggleHeading1:
        return 'Toggle Heading 1';
      case BlockNoteDefaultSlashCommand.toggleHeading2:
        return 'Toggle Heading 2';
      case BlockNoteDefaultSlashCommand.toggleHeading3:
        return 'Toggle Heading 3';
      case BlockNoteDefaultSlashCommand.bulletList:
        return 'Bullet List';
      case BlockNoteDefaultSlashCommand.numberedList:
        return 'Numbered List';
      case BlockNoteDefaultSlashCommand.checkList:
        return 'Check List';
      case BlockNoteDefaultSlashCommand.quote:
        return 'Quote';
      case BlockNoteDefaultSlashCommand.toggleList:
        return 'Toggle List';
      case BlockNoteDefaultSlashCommand.codeBlock:
        return 'Code Block';
      case BlockNoteDefaultSlashCommand.image:
        return 'Image';
      case BlockNoteDefaultSlashCommand.audio:
        return 'Audio';
      case BlockNoteDefaultSlashCommand.video:
        return 'Video';
      case BlockNoteDefaultSlashCommand.file:
        return 'File';
      case BlockNoteDefaultSlashCommand.table:
        return 'Table';
    }
  }
}

/// Icon for a slash command item.
///
/// Use [BlockNoteSlashCommandIcon.text] for emoji or short text,
/// [BlockNoteSlashCommandIcon.svg] for raw SVG content, or
/// [BlockNoteSlashCommandIcon.image] for PNG/JPEG via URL (including
/// data URLs from app assets).
sealed class BlockNoteSlashCommandIcon {
  /// Creates an icon (subclasses use this for const constructors).
  const BlockNoteSlashCommandIcon();

  /// Creates an icon from a JSON map.
  static BlockNoteSlashCommandIcon? fromJson(Object? json) {
    if (json == null) return null;
    if (json is String) {
      return BlockNoteSlashCommandIconText(json);
    }
    if (json is! Map<String, dynamic>) return null;
    final type = json['type'] as String?;
    switch (type) {
      case 'text':
        final value = json['value'] as String?;
        return value != null ? BlockNoteSlashCommandIconText(value) : null;
      case 'svg':
        final content = json['content'] as String?;
        return content != null ? BlockNoteSlashCommandIconSvg(content) : null;
      case 'image':
        final url = json['url'] as String?;
        return url != null ? BlockNoteSlashCommandIconImage(url) : null;
      default:
        return null;
    }
  }
}

/// Icon as emoji or short text (rendered in a span).
class BlockNoteSlashCommandIconText extends BlockNoteSlashCommandIcon {
  /// Creates a text/emoji icon.
  const BlockNoteSlashCommandIconText(this.value) : super();

  /// The text or emoji to display (e.g. '📝' or 'P').
  final String value;

  /// Serializes to JSON.
  Map<String, dynamic> toJson() => {'type': 'text', 'value': value};
}

/// Icon as raw SVG markup (rendered inline).
class BlockNoteSlashCommandIconSvg extends BlockNoteSlashCommandIcon {
  /// Creates an SVG icon from raw SVG string.
  const BlockNoteSlashCommandIconSvg(this.content) : super();

  /// Raw SVG markup (e.g. from [rootBundle.loadString] of an .svg asset).
  final String content;

  /// Serializes to JSON.
  Map<String, dynamic> toJson() => {'type': 'svg', 'content': content};
}

/// Icon as an image URL (PNG, JPEG, or data URL from app assets).
class BlockNoteSlashCommandIconImage extends BlockNoteSlashCommandIcon {
  /// Creates an image icon from a URL.
  ///
  /// [url] can be:
  /// - A data URL (e.g. `data:image/png;base64,...`) from app assets.
  /// - An HTTP(S) URL.
  /// - Any URL the WebView can load.
  const BlockNoteSlashCommandIconImage(this.url) : super();

  /// Image URL (data URL, https:, or app-served URL).
  final String url;

  /// Creates an image icon by loading from an app asset (e.g. PNG, JPEG).
  ///
  /// Loads the asset as bytes, encodes as base64, and returns an icon with
  /// a data URL. For SVG assets use [BlockNoteSlashCommandIconSvg] with
  /// [rootBundle.loadString] instead.
  static Future<BlockNoteSlashCommandIconImage> fromAsset(
    String assetPath,
  ) async {
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();
    final base64 = base64Encode(bytes);
    final ext = assetPath.split('.').last.toLowerCase();
    const mimeByExt = {
      'png': 'image/png',
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'gif': 'image/gif',
      'webp': 'image/webp',
    };
    final mime = mimeByExt[ext] ?? 'image/png';
    return BlockNoteSlashCommandIconImage('data:$mime;base64,$base64');
  }

  /// Serializes to JSON.
  Map<String, dynamic> toJson() => {'type': 'image', 'url': url};
}

/// Slash command item configuration.
class BlockNoteSlashCommandItem {
  /// Creates a new slash command item.
  ///
  /// Provide exactly one of [onItemClick] (inline JS) or [onItemClickScriptPath]
  /// (asset path to a JS file). When both are provided, file is used first at
  /// resolution time; if the file cannot be loaded, inline is used.
  BlockNoteSlashCommandItem({
    required this.title,
    this.onItemClick,
    this.onItemClickScriptPath,
    this.subtext,
    this.badge,
    this.aliases,
    this.group,
    this.icon,
  }) : assert(
          (onItemClick != null && onItemClick.isNotEmpty) ||
              (onItemClickScriptPath != null &&
                  onItemClickScriptPath.isNotEmpty),
          'Either onItemClick or onItemClickScriptPath must be provided',
        );

  /// Title of the command item.
  final String title;

  /// Inline JavaScript code to execute when the item is clicked.
  ///
  /// The code is evaluated with `editor` in scope. Use for short handlers.
  /// Prefer [onItemClickScriptPath] for longer or reusable handlers.
  ///
  /// Either [onItemClick] or [onItemClickScriptPath] must be provided.
  /// When both are set, [onItemClickScriptPath] takes priority when
  /// resolving; if the file cannot be loaded, this value is used.
  final String? onItemClick;

  /// Asset path to a JavaScript file whose content is used as the click handler.
  ///
  /// When set, the file is loaded and its content is evaluated when the item
  /// is clicked (with `editor` in scope). Takes priority over [onItemClick]
  /// when resolving; if the file cannot be loaded, [onItemClick] is used.
  ///
  /// Either [onItemClick] or [onItemClickScriptPath] must be provided.
  final String? onItemClickScriptPath;

  /// Subtitle text (optional).
  final String? subtext;

  /// Badge text (optional, typically shows keyboard shortcut).
  final String? badge;

  /// Aliases for filtering (optional).
  final List<String>? aliases;

  /// Group name (optional).
  final String? group;

  /// Icon (optional).
  ///
  /// Can be a [String] (emoji or short text, backward compatible) or
  /// [BlockNoteSlashCommandIcon] for text, SVG, or image (e.g. PNG from
  /// app assets via data URL).
  final Object? icon;

  /// Creates a slash command that inserts a paragraph block.
  factory BlockNoteSlashCommandItem.paragraph({
    required String title,

    /// Optional text content for the inserted block.
    String? content,
    String? subtext,
    String? badge,
    List<String>? aliases,
    String? group,

    /// Optional icon: [String] (emoji/text) or [BlockNoteSlashCommandIcon].
    Object? icon,
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

    /// Optional icon: [String] (emoji/text) or [BlockNoteSlashCommandIcon].
    Object? icon,
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

    /// Optional icon: [String] (emoji/text) or [BlockNoteSlashCommandIcon].
    Object? icon,
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

    /// Optional icon: [String] (emoji/text) or [BlockNoteSlashCommandIcon].
    Object? icon,
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

    /// Optional icon: [String] (emoji/text) or [BlockNoteSlashCommandIcon].
    Object? icon,
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

    /// Optional icon: [String] (emoji/text) or [BlockNoteSlashCommandIcon].
    Object? icon,
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

    /// Optional icon: [String] (emoji/text) or [BlockNoteSlashCommandIcon].
    Object? icon,
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

    /// Optional icon: [String] (emoji/text) or [BlockNoteSlashCommandIcon].
    Object? icon,
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

    /// Optional icon: [String] (emoji/text) or [BlockNoteSlashCommandIcon].
    Object? icon,
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
    final iconJson = json['icon'];
    final Object? parsedIcon = iconJson == null
        ? null
        : iconJson is String
            ? iconJson
            : BlockNoteSlashCommandIcon.fromJson(iconJson);
    final title = json['title'] as String? ?? '';
    final parsedInline = json['onItemClick'] as String?;
    final parsedPath = json['onItemClickScriptPath'] as String?;
    final hasInline = parsedInline != null && parsedInline.isNotEmpty;
    final hasPath = parsedPath != null && parsedPath.isNotEmpty;
    final String? onItemClick = hasInline
        ? parsedInline
        : (hasPath ? null : 'void 0;'); // no-op when neither in JSON
    final String? onItemClickScriptPath = hasPath ? parsedPath : null;
    return BlockNoteSlashCommandItem(
      title: title,
      onItemClick: onItemClick,
      onItemClickScriptPath: onItemClickScriptPath,
      subtext: json['subtext'] as String?,
      badge: json['badge'] as String?,
      aliases: (json['aliases'] as List<dynamic>?)
          ?.whereType<String>()
          .toList(),
      group: json['group'] as String?,
      icon: parsedIcon,
    );
  }

  /// Converts this slash command item to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'title': title};
    if (onItemClick != null) {
      json['onItemClick'] = onItemClick;
    }
    if (onItemClickScriptPath != null) {
      json['onItemClickScriptPath'] = onItemClickScriptPath;
    }
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
      switch (icon!) {
        case BlockNoteSlashCommandIconText e:
          json['icon'] = e.toJson();
        case BlockNoteSlashCommandIconSvg e:
          json['icon'] = e.toJson();
        case BlockNoteSlashCommandIconImage e:
          json['icon'] = e.toJson();
        default:
          json['icon'] = icon as String;
      }
    }
    return json;
  }

  BlockNoteSlashCommandItem copyWith({
    String? title,
    String? onItemClick,
    Object? onItemClickScriptPath = _unset,
    Object? subtext = _unset,
    Object? badge = _unset,
    Object? aliases = _unset,
    Object? group = _unset,
    Object? icon = _unset,
  }) {
    return BlockNoteSlashCommandItem(
      title: title ?? this.title,
      onItemClick: onItemClick ?? this.onItemClick,
      onItemClickScriptPath: identical(onItemClickScriptPath, _unset)
          ? this.onItemClickScriptPath
          : onItemClickScriptPath as String?,
      subtext: identical(subtext, _unset) ? this.subtext : subtext as String?,
      badge: identical(badge, _unset) ? this.badge : badge as String?,
      aliases: identical(aliases, _unset)
          ? this.aliases
          : aliases as List<String>?,
      group: identical(group, _unset) ? this.group : group as String?,
      icon: identical(icon, _unset) ? this.icon : icon,
    );
  }

  @override
  String toString() {
    return 'BlockNoteSlashCommandItem(title: $title, onItemClick: $onItemClick, onItemClickScriptPath: $onItemClickScriptPath, subtext: $subtext, badge: $badge, aliases: $aliases, group: $group, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteSlashCommandItem &&
            other.title == title &&
            other.onItemClick == onItemClick &&
            other.onItemClickScriptPath == onItemClickScriptPath &&
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
        onItemClickScriptPath,
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
    this.availableSlashCommands,
  });

  /// Custom slash command items (extends default if provided).
  final List<BlockNoteSlashCommandItem>? items;

  /// Whether the slash menu is enabled (default: true).
  final bool enabled;

  /// Trigger character (default: '/').
  final String triggerCharacter;

  /// List of default slash commands that should be available.
  ///
  /// If provided, only the default commands specified in this list will be
  /// shown in the slash menu. If null, all default commands are shown.
  ///
  /// Can contain [BlockNoteDefaultSlashCommand] enum values or custom title
  /// strings. Only commands matching these titles will be included from the
  /// default slash menu items.
  ///
  /// Example:
  /// ```dart
  /// BlockNoteSlashCommandConfig(
  ///   availableSlashCommands: [
  ///     BlockNoteDefaultSlashCommand.paragraph,
  ///     BlockNoteDefaultSlashCommand.heading1,
  ///     BlockNoteDefaultSlashCommand.heading2,
  ///     BlockNoteDefaultSlashCommand.heading3,
  ///   ],
  /// )
  /// ```
  final List<dynamic>? availableSlashCommands;

  /// Creates a BlockNoteSlashCommandConfig from a JSON map.
  factory BlockNoteSlashCommandConfig.fromJson(Map<String, dynamic> json) {
    final availableCommandsJson =
        json['availableSlashCommands'] as List<dynamic>?;
    final availableCommands = availableCommandsJson?.map((item) {
      if (item is String) {
        // Try to match by enum title first
        try {
          return BlockNoteDefaultSlashCommand.values.firstWhere(
            (e) => e.title == item,
          );
        } catch (_) {
          // If not found as enum title, treat as custom title string
          return item;
        }
      }
      return item;
    }).toList();

    return BlockNoteSlashCommandConfig(
      items: (json['items'] as List<dynamic>?)
          ?.whereType<Map>()
          .map((item) => BlockNoteSlashCommandItem.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .toList(),
      enabled: json['enabled'] as bool? ?? true,
      triggerCharacter: json['triggerCharacter'] as String? ?? '/',
      availableSlashCommands: availableCommands,
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
    if (availableSlashCommands != null) {
      json['availableSlashCommands'] = availableSlashCommands!.map((item) {
        if (item is BlockNoteDefaultSlashCommand) {
          return item.title;
        }
        return item.toString();
      }).toList();
    }
    return json;
  }

  /// Converts this config to JSON with [onItemClickScriptPath] resolved.
  ///
  /// For each item: if [onItemClickScriptPath] is set, loads the asset and
  /// uses its content for `onItemClick`; if the file cannot be loaded, uses
  /// [onItemClick] if set. Otherwise uses [onItemClick]. Use this before
  /// sending config to the web view.
  Future<Map<String, dynamic>> toJsonResolved() async {
    final json = toJson();
    if (items == null || items!.isEmpty) {
      return json;
    }
    final resolvedItems = <Map<String, dynamic>>[];
    for (final item in items!) {
      final map = item.toJson();
      String? resolvedHandler;
      if (item.onItemClickScriptPath != null) {
        try {
          resolvedHandler =
              await rootBundle.loadString(item.onItemClickScriptPath!);
        } catch (_) {
          resolvedHandler = item.onItemClick;
        }
      } else {
        resolvedHandler = item.onItemClick;
      }
      if (resolvedHandler != null) {
        map['onItemClick'] = resolvedHandler;
      }
      map.remove('onItemClickScriptPath');
      resolvedItems.add(map);
    }
    json['items'] = resolvedItems;
    return json;
  }

  BlockNoteSlashCommandConfig copyWith({
    Object? items = _unset,
    bool? enabled,
    String? triggerCharacter,
    Object? availableSlashCommands = _unset,
  }) {
    return BlockNoteSlashCommandConfig(
      items: identical(items, _unset)
          ? this.items
          : items as List<BlockNoteSlashCommandItem>?,
      enabled: enabled ?? this.enabled,
      triggerCharacter: triggerCharacter ?? this.triggerCharacter,
      availableSlashCommands: identical(availableSlashCommands, _unset)
          ? this.availableSlashCommands
          : availableSlashCommands as List<dynamic>?,
    );
  }

  @override
  String toString() {
    return 'BlockNoteSlashCommandConfig(items: $items, enabled: $enabled, triggerCharacter: $triggerCharacter, availableSlashCommands: $availableSlashCommands)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteSlashCommandConfig &&
            _listEquals(other.items, items) &&
            other.enabled == enabled &&
            other.triggerCharacter == triggerCharacter &&
            _listEquals(other.availableSlashCommands, availableSlashCommands);
  }

  @override
  int get hashCode => Object.hash(
        _listHash(items),
        enabled,
        triggerCharacter,
        _listHash(availableSlashCommands),
      );
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
