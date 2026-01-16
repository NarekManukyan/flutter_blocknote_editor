/// BlockNote block types and structure definitions.
///
/// This file defines the data models for BlockNote blocks, matching the
/// BlockNoteJS schema. It supports standard blocks and provides extension
/// points for custom blocks (e.g., agenda_item).
library;

import 'package:json_annotation/json_annotation.dart';

part 'blocknote_block.g.dart';

/// Standard BlockNote block types.
enum BlockNoteBlockType {
  /// Paragraph block.
  paragraph,

  /// Heading block (h1, h2, h3).
  heading,

  /// Bullet list item.
  bulletListItem,

  /// Numbered list item.
  numberedListItem,

  /// Code block.
  codeBlock,

  /// Image block.
  image,

  /// Video block.
  video,

  /// File block.
  file,

  /// Table block.
  table,

  /// Custom block type (for future extensions like agenda_item).
  custom,
}

/// BlockNote block inline content types.
enum BlockNoteInlineContentType {
  /// Text content.
  text,

  /// Link content.
  link,

  /// Mention content.
  mention,
}

/// BlockNote block inline content.
///
/// Represents inline content within a block (text, links, mentions).
@JsonSerializable()
class BlockNoteInlineContent {
  /// Creates a new inline content instance.
  const BlockNoteInlineContent({
    required this.type,
    required this.text,
    this.styles,
    this.href,
    this.mentionId,
  });

  /// The type of inline content.
  @JsonKey(name: 'type', fromJson: _inlineContentTypeFromJson, toJson: _inlineContentTypeToJson)
  final BlockNoteInlineContentType type;

  /// The text content.
  final String text;

  /// Optional text styles (bold, italic, underline, etc.).
  final Map<String, bool>? styles;

  /// Optional href for link content.
  final String? href;

  /// Optional mention ID for mention content.
  @JsonKey(name: 'mentionId')
  final String? mentionId;

  /// Creates a BlockNoteInlineContent from a JSON map.
  factory BlockNoteInlineContent.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteInlineContentFromJson(json);

  /// Converts this instance to a JSON map.
  Map<String, dynamic> toJson() => _$BlockNoteInlineContentToJson(this);
}

/// BlockNote block structure.
///
/// Represents a single block in a BlockNote document. Blocks can contain
/// inline content, have properties, and reference parent/child blocks.
@JsonSerializable()
class BlockNoteBlock {
  /// Creates a new block instance.
  const BlockNoteBlock({
    required this.id,
    required this.type,
    this.content,
    this.props,
    this.children,
  });

  /// Unique identifier for this block.
  final String id;

  /// The type of this block.
  @JsonKey(name: 'type', fromJson: _blockTypeFromJson, toJson: _blockTypeToJson)
  final BlockNoteBlockType type;

  /// Inline content of this block (for text-based blocks).
  final List<BlockNoteInlineContent>? content;

  /// Block-specific properties (e.g., heading level, list item type).
  final Map<String, dynamic>? props;

  /// Child blocks (for nested structures like lists).
  final List<BlockNoteBlock>? children;

  /// Creates a BlockNoteBlock from a JSON map.
  factory BlockNoteBlock.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteBlockFromJson(json);

  /// Converts this instance to a JSON map.
  Map<String, dynamic> toJson() => _$BlockNoteBlockToJson(this);
}

/// Helper function to deserialize BlockNoteBlockType from JSON.
BlockNoteBlockType _blockTypeFromJson(String value) {
  return BlockNoteBlockType.values.firstWhere(
    (e) => e.name == value,
    orElse: () => BlockNoteBlockType.custom,
  );
}

/// Helper function to serialize BlockNoteBlockType to JSON.
String _blockTypeToJson(BlockNoteBlockType value) => value.name;

/// Helper function to deserialize BlockNoteInlineContentType from JSON.
BlockNoteInlineContentType _inlineContentTypeFromJson(String value) {
  return BlockNoteInlineContentType.values.firstWhere(
    (e) => e.name == value,
    orElse: () => BlockNoteInlineContentType.text,
  );
}

/// Helper function to serialize BlockNoteInlineContentType to JSON.
String _inlineContentTypeToJson(BlockNoteInlineContentType value) => value.name;
