/// BlockNote block types and structure definitions.
///
/// This file defines the data models for BlockNote blocks, matching the
/// BlockNoteJS schema. It supports standard blocks and provides extension
/// points for custom blocks (e.g., agenda_item).
library;

/// Standard BlockNote block types.
enum BlockNoteBlockType {
  /// Paragraph block.
  paragraph,

  /// Heading block (h1, h2, h3).
  heading,

  /// Quote block.
  quote,

  /// Bullet list item.
  bulletListItem,

  /// Numbered list item.
  numberedListItem,

  /// Check list item.
  checkListItem,

  /// Toggle list item.
  toggleListItem,

  /// Code block.
  codeBlock,

  /// Audio block.
  audio,

  /// Image block.
  image,

  /// Video block.
  video,

  /// File block.
  file,

  /// Table block.
  table,

  /// Column block.
  column,

  /// Column list block.
  columnList,

  /// Custom block type (for future extensions like agenda_item).
  custom,
}

/// BlockNote styled text content.
class BlockNoteStyledText {
  /// Creates a new styled text instance.
  const BlockNoteStyledText({
    this.type = 'text',
    required this.text,
    this.styles,
  });

  /// The type of inline content.
  final String type;

  /// The text content.
  final String text;

  /// Optional text styles (bold, italic, underline, textColor, backgroundColor, etc.).
  /// Can contain boolean values (bold, italic, underline, strike) and string values (textColor, backgroundColor).
  final Map<String, dynamic>? styles;

  /// Creates a BlockNoteStyledText from a JSON map.
  factory BlockNoteStyledText.fromJson(Map<String, dynamic> json) {
    return BlockNoteStyledText(
      type: json['type'] as String? ?? 'text',
      text: json['text'] as String? ?? '',
      styles: _mapFromJson(json['styles']),
    );
  }

  /// Converts this styled text to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'type': type,
      'text': text,
    };
    if (styles != null) {
      json['styles'] = styles;
    }
    return json;
  }

  /// Creates a copy with optional updates.
  BlockNoteStyledText copyWith({
    String? type,
    String? text,
    Object? styles = _unset,
  }) {
    return BlockNoteStyledText(
      type: type ?? this.type,
      text: text ?? this.text,
      styles: identical(styles, _unset)
          ? this.styles
          : styles as Map<String, dynamic>?,
    );
  }

  @override
  String toString() {
    return 'BlockNoteStyledText(type: $type, text: $text, styles: $styles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteStyledText &&
            other.type == type &&
            other.text == text &&
            _mapEquals(other.styles, styles);
  }

  @override
  int get hashCode => Object.hash(type, text, _mapHash(styles));
}

/// BlockNote block inline content.
///
/// Represents inline content within a block (text, links, custom inline content).
sealed class BlockNoteInlineContent {
  const BlockNoteInlineContent();

  /// Text inline content.
  factory BlockNoteInlineContent.text({
    String? type,
    required String text,
    Map<String, dynamic>? styles,
  }) {
    return BlockNoteTextContent(
      type: type ?? 'text',
      text: text,
      styles: styles,
    );
  }

  /// Link inline content.
  factory BlockNoteInlineContent.link({
    String? type,
    required List<BlockNoteStyledText> content,
    required String href,
  }) {
    return BlockNoteLinkContent(
      type: type ?? 'link',
      content: content,
      href: href,
    );
  }

  /// Custom inline content.
  factory BlockNoteInlineContent.custom({
    required String type,
    List<BlockNoteStyledText>? content,
    Map<String, dynamic>? props,
  }) {
    return BlockNoteCustomInlineContent(
      type: type,
      content: content,
      props: props ?? const <String, dynamic>{},
    );
  }

  /// Creates a BlockNoteInlineContent from a JSON map.
  factory BlockNoteInlineContent.fromJson(Map<String, dynamic> json) =>
      BlockNoteInlineContentConverter.fromJson(json);

  /// Converts this inline content to JSON.
  Map<String, dynamic> toJson() => BlockNoteInlineContentConverter.toJson(this);
}

/// Text inline content.
class BlockNoteTextContent extends BlockNoteInlineContent {
  const BlockNoteTextContent({
    this.type = 'text',
    required this.text,
    this.styles,
  });

  /// The type of inline content.
  final String type;

  /// The text content.
  final String text;

  /// Optional text styles.
  final Map<String, dynamic>? styles;

  BlockNoteTextContent copyWith({
    String? type,
    String? text,
    Object? styles = _unset,
  }) {
    return BlockNoteTextContent(
      type: type ?? this.type,
      text: text ?? this.text,
      styles: identical(styles, _unset)
          ? this.styles
          : styles as Map<String, dynamic>?,
    );
  }

  @override
  String toString() {
    return 'BlockNoteTextContent(type: $type, text: $text, styles: $styles)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteTextContent &&
            other.type == type &&
            other.text == text &&
            _mapEquals(other.styles, styles);
  }

  @override
  int get hashCode => Object.hash(type, text, _mapHash(styles));
}

/// Link inline content.
class BlockNoteLinkContent extends BlockNoteInlineContent {
  const BlockNoteLinkContent({
    this.type = 'link',
    required this.content,
    required this.href,
  });

  /// The type of inline content.
  final String type;

  /// The styled text content inside the link.
  final List<BlockNoteStyledText> content;

  /// The link href.
  final String href;

  BlockNoteLinkContent copyWith({
    String? type,
    List<BlockNoteStyledText>? content,
    String? href,
  }) {
    return BlockNoteLinkContent(
      type: type ?? this.type,
      content: content ?? this.content,
      href: href ?? this.href,
    );
  }

  @override
  String toString() {
    return 'BlockNoteLinkContent(type: $type, content: $content, href: $href)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteLinkContent &&
            other.type == type &&
            other.href == href &&
            _listEquals(other.content, content);
  }

  @override
  int get hashCode => Object.hash(type, href, _listHash(content));
}

/// Custom inline content.
class BlockNoteCustomInlineContent extends BlockNoteInlineContent {
  const BlockNoteCustomInlineContent({
    required this.type,
    this.content,
    this.props = const <String, dynamic>{},
  });

  /// The custom inline content type.
  final String type;

  /// Optional styled text content.
  final List<BlockNoteStyledText>? content;

  /// Custom properties for the inline content.
  final Map<String, dynamic> props;

  BlockNoteCustomInlineContent copyWith({
    String? type,
    Object? content = _unset,
    Map<String, dynamic>? props,
  }) {
    return BlockNoteCustomInlineContent(
      type: type ?? this.type,
      content: identical(content, _unset)
          ? this.content
          : content as List<BlockNoteStyledText>?,
      props: props ?? this.props,
    );
  }

  @override
  String toString() {
    return 'BlockNoteCustomInlineContent(type: $type, content: $content, props: $props)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteCustomInlineContent &&
            other.type == type &&
            _listEquals(other.content, content) &&
            _mapEquals(other.props, props);
  }

  @override
  int get hashCode => Object.hash(type, _listHash(content), _mapHash(props));
}

/// BlockNote table content structure.
class BlockNoteTableContent {
  /// Creates a new table content instance.
  const BlockNoteTableContent({
    this.type = 'tableContent',
    required this.rows,
  });

  /// The table content type.
  final String type;

  /// Table rows containing cell content.
  final List<BlockNoteTableRow> rows;

  /// Creates a BlockNoteTableContent from a JSON map.
  factory BlockNoteTableContent.fromJson(Map<String, dynamic> json) {
    return BlockNoteTableContent(
      type: json['type'] as String? ?? 'tableContent',
      rows: (json['rows'] as List<dynamic>? ?? [])
          .whereType<Map>()
          .map((row) => BlockNoteTableRow.fromJson(
                Map<String, dynamic>.from(row),
              ))
          .toList(),
    );
  }

  /// Converts this table content to JSON.
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'rows': rows.map((row) => row.toJson()).toList(),
    };
  }

  BlockNoteTableContent copyWith({
    String? type,
    List<BlockNoteTableRow>? rows,
  }) {
    return BlockNoteTableContent(
      type: type ?? this.type,
      rows: rows ?? this.rows,
    );
  }

  @override
  String toString() => 'BlockNoteTableContent(type: $type, rows: $rows)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteTableContent &&
            other.type == type &&
            _listEquals(other.rows, rows);
  }

  @override
  int get hashCode => Object.hash(type, _listHash(rows));
}

/// BlockNote table row structure.
class BlockNoteTableRow {
  /// Creates a new table row instance.
  const BlockNoteTableRow({
    required this.cells,
  });

  /// Table cells (each cell is an array of inline content).
  final List<List<BlockNoteInlineContent>> cells;

  /// Creates a BlockNoteTableRow from a JSON map.
  factory BlockNoteTableRow.fromJson(Map<String, dynamic> json) {
    return BlockNoteTableRow(
      cells: _tableCellsFromJson(json['cells']),
    );
  }

  /// Converts this table row to JSON.
  Map<String, dynamic> toJson() {
    return {
      'cells': _tableCellsToJson(cells),
    };
  }

  BlockNoteTableRow copyWith({
    List<List<BlockNoteInlineContent>>? cells,
  }) {
    return BlockNoteTableRow(
      cells: cells ?? this.cells,
    );
  }

  @override
  String toString() => 'BlockNoteTableRow(cells: $cells)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BlockNoteTableRow) return false;
    if (cells.length != other.cells.length) return false;
    for (var i = 0; i < cells.length; i++) {
      if (!_listEquals(cells[i], other.cells[i])) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode {
    return Object.hashAll(
      cells.map((cell) => _listHash(cell)),
    );
  }
}

/// Union type for block content.
sealed class BlockNoteBlockContent {
  const BlockNoteBlockContent();

  /// Inline content array.
  factory BlockNoteBlockContent.inline({
    required List<BlockNoteInlineContent> content,
  }) = BlockNoteInlineContentList;

  /// Table content structure.
  factory BlockNoteBlockContent.table({
    required BlockNoteTableContent content,
  }) = BlockNoteTableBlockContent;
}

class BlockNoteInlineContentList extends BlockNoteBlockContent {
  const BlockNoteInlineContentList({
    required this.content,
  });

  final List<BlockNoteInlineContent> content;

  BlockNoteInlineContentList copyWith({
    List<BlockNoteInlineContent>? content,
  }) {
    return BlockNoteInlineContentList(
      content: content ?? this.content,
    );
  }

  @override
  String toString() => 'BlockNoteInlineContentList(content: $content)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteInlineContentList &&
            _listEquals(other.content, content);
  }

  @override
  int get hashCode => _listHash(content);
}

class BlockNoteTableBlockContent extends BlockNoteBlockContent {
  const BlockNoteTableBlockContent({
    required this.content,
  });

  final BlockNoteTableContent content;

  BlockNoteTableBlockContent copyWith({
    BlockNoteTableContent? content,
  }) {
    return BlockNoteTableBlockContent(
      content: content ?? this.content,
    );
  }

  @override
  String toString() => 'BlockNoteTableBlockContent(content: $content)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteTableBlockContent && other.content == content;
  }

  @override
  int get hashCode => content.hashCode;
}

/// BlockNote block structure.
///
/// Represents a single block in a BlockNote document. Blocks can contain
/// inline content, have properties, and reference parent/child blocks.
class BlockNoteBlock {
  /// Creates a new block instance.
  const BlockNoteBlock({
    required this.id,
    required this.type,
    this.customType,
    this.content,
    this.props,
    this.children,
  });

  /// Unique identifier for this block.
  final String id;

  /// The type of this block.
  final BlockNoteBlockType type;

  /// Custom block type name when [type] is [BlockNoteBlockType.custom].
  final String? customType;

  /// Content of this block (inline content or table content).
  final BlockNoteBlockContent? content;

  /// Block-specific properties (e.g., heading level, list item type).
  final Map<String, dynamic>? props;

  /// Child blocks (for nested structures like lists).
  final List<BlockNoteBlock>? children;

  /// Creates a BlockNoteBlock from a JSON map.
  factory BlockNoteBlock.fromJson(Map<String, dynamic> json) {
    final typeName = json['type'] as String? ?? '';
    final parsedType = BlockNoteBlockType.values.firstWhere(
      (type) => type.name == typeName,
      orElse: () => BlockNoteBlockType.custom,
    );
    return BlockNoteBlock(
      id: json['id'] as String? ?? '',
      type: parsedType,
      customType: parsedType == BlockNoteBlockType.custom ? typeName : null,
      content: _blockContentFromJson(json['content']),
      props: _mapFromJson(json['props']),
      children: (json['children'] as List<dynamic>?)
          ?.whereType<Map>()
          .map((child) => BlockNoteBlock.fromJson(
                Map<String, dynamic>.from(child),
              ))
          .toList(),
    );
  }

  /// Converts this block to JSON.
  Map<String, dynamic> toJson() {
    final resolvedType =
        type == BlockNoteBlockType.custom && customType != null
            ? customType!
            : type.name;
    final json = <String, dynamic>{
      'id': id,
      'type': resolvedType,
    };
    final contentJson = _blockContentToJson(content);
    if (contentJson != null) {
      json['content'] = contentJson;
    }
    if (props != null) {
      json['props'] = props;
    }
    if (children != null) {
      json['children'] = children!.map((child) => child.toJson()).toList();
    }
    return json;
  }

  BlockNoteBlock copyWith({
    String? id,
    BlockNoteBlockType? type,
    Object? customType = _unset,
    Object? content = _unset,
    Object? props = _unset,
    Object? children = _unset,
  }) {
    return BlockNoteBlock(
      id: id ?? this.id,
      type: type ?? this.type,
      customType: identical(customType, _unset)
          ? this.customType
          : customType as String?,
      content: identical(content, _unset)
          ? this.content
          : content as BlockNoteBlockContent?,
      props: identical(props, _unset)
          ? this.props
          : props as Map<String, dynamic>?,
      children: identical(children, _unset)
          ? this.children
          : children as List<BlockNoteBlock>?,
    );
  }

  @override
  String toString() {
    return 'BlockNoteBlock(id: $id, type: $type, customType: $customType, content: $content, props: $props, children: $children)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteBlock &&
            other.id == id &&
            other.type == type &&
            other.customType == customType &&
            other.content == content &&
            _mapEquals(other.props, props) &&
            _listEquals(other.children, children);
  }

  @override
  int get hashCode => Object.hash(
        id,
        type,
        customType,
        content,
        _mapHash(props),
        _listHash(children),
      );
}

/// JSON converters for inline content and block content.
class BlockNoteInlineContentConverter {
  static BlockNoteInlineContent fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? 'text';

    switch (type) {
      case 'text':
        return BlockNoteTextContent(
          text: json['text'] as String? ?? '',
          styles: _mapFromJson(json['styles']),
        );
      case 'link':
        return BlockNoteLinkContent(
          content: _styledTextListFromJson(json['content']) ?? [],
          href: json['href'] as String? ?? '',
        );
      default:
        return BlockNoteCustomInlineContent(
          type: type,
          content: _styledTextListFromJson(json['content']),
          props: _mapFromJson(json['props']) ?? const <String, dynamic>{},
        );
    }
  }

  static Map<String, dynamic> toJson(BlockNoteInlineContent content) {
    if (content is BlockNoteTextContent) {
      final json = <String, dynamic>{
        'type': content.type,
        'text': content.text,
      };
      if (content.styles != null) {
        json['styles'] = content.styles;
      }
      return json;
    }

    if (content is BlockNoteLinkContent) {
      return {
        'type': content.type,
        'content': content.content.map((item) => item.toJson()).toList(),
        'href': content.href,
      };
    }

    if (content is BlockNoteCustomInlineContent) {
      return {
        'type': content.type,
        if (content.content != null)
          'content': content.content!.map((item) => item.toJson()).toList(),
        'props': content.props,
      };
    }

    return const <String, dynamic>{};
  }
}

BlockNoteBlockContent? _blockContentFromJson(Object? json) {
  if (json == null) {
    return null;
  }

  if (json is List) {
    return BlockNoteBlockContent.inline(
      content: json
          .whereType<Map>()
          .map((e) => BlockNoteInlineContent.fromJson(
                Map<String, dynamic>.from(e),
              ))
          .toList(),
    );
  }

  if (json is Map) {
    final map = Map<String, dynamic>.from(json);
    if (map['type'] == 'tableContent') {
      return BlockNoteBlockContent.table(
        content: BlockNoteTableContent.fromJson(map),
      );
    }
  }

  return null;
}

Object? _blockContentToJson(BlockNoteBlockContent? content) {
  if (content == null) {
    return null;
  }

  if (content is BlockNoteInlineContentList) {
    return content.content.map((item) => item.toJson()).toList();
  }

  if (content is BlockNoteTableBlockContent) {
    return content.content.toJson();
  }

  return null;
}

List<List<BlockNoteInlineContent>> _tableCellsFromJson(Object? json) {
  if (json is! List) {
    return <List<BlockNoteInlineContent>>[];
  }

  return json
      .whereType<List>()
      .map(
        (cell) => cell
            .whereType<Map>()
            .map((item) => BlockNoteInlineContent.fromJson(
                  Map<String, dynamic>.from(item),
                ))
            .toList(),
      )
      .toList();
}

Object _tableCellsToJson(List<List<BlockNoteInlineContent>> cells) {
  return cells
      .map((cell) => cell.map((item) => item.toJson()).toList())
      .toList();
}

Map<String, dynamic>? _mapFromJson(Object? value) {
  if (value is Map) {
    return value.map((key, entry) => MapEntry(key.toString(), entry));
  }
  return null;
}

List<BlockNoteStyledText>? _styledTextListFromJson(Object? value) {
  if (value is! List) {
    return null;
  }

  return value
      .whereType<Map>()
      .map((item) => BlockNoteStyledText.fromJson(
            Map<String, dynamic>.from(item),
          ))
      .toList();
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

bool _mapEquals<K, V>(Map<K, V>? a, Map<K, V>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null || a.length != b.length) return false;
  for (final entry in a.entries) {
    if (!b.containsKey(entry.key)) return false;
    if (b[entry.key] != entry.value) return false;
  }
  return true;
}

int _listHash<T>(List<T>? list) {
  if (list == null) return 0;
  return Object.hashAll(list);
}

int _mapHash<K, V>(Map<K, V>? map) {
  if (map == null) return 0;
  return Object.hashAll(
    map.entries.map((entry) => Object.hash(entry.key, entry.value)),
  );
}
