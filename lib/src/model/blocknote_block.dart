/// BlockNote block types and structure definitions.
///
/// This file defines the data models for BlockNote blocks, matching the
/// BlockNoteJS schema. It supports standard blocks and provides extension
/// points for custom blocks (e.g., agenda_item).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'blocknote_block.freezed.dart';
part 'blocknote_block.g.dart';

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
@freezed
sealed class BlockNoteInlineContent with _$BlockNoteInlineContent {
  /// Creates a new inline content instance.
  const factory BlockNoteInlineContent({
    /// The type of inline content.
    required BlockNoteInlineContentType type,

    /// The text content.
    required String text,

    /// Optional text styles (bold, italic, underline, textColor, backgroundColor, etc.).
    /// Can contain boolean values (bold, italic, underline, strike) and string values (textColor, backgroundColor).
    Map<String, dynamic>? styles,

    /// Optional href for link content.
    String? href,

    /// Optional mention ID for mention content.
    String? mentionId,
  }) = _BlockNoteInlineContent;

  /// Creates a BlockNoteInlineContent from a JSON map.
  factory BlockNoteInlineContent.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteInlineContentFromJson(json);
}

/// BlockNote block structure.
///
/// Represents a single block in a BlockNote document. Blocks can contain
/// inline content, have properties, and reference parent/child blocks.
@freezed
sealed class BlockNoteBlock with _$BlockNoteBlock {
  /// Creates a new block instance.
  const factory BlockNoteBlock({
    /// Unique identifier for this block.
    required String id,

    /// The type of this block.
    required BlockNoteBlockType type,

    /// Inline content of this block (for text-based blocks).
    List<BlockNoteInlineContent>? content,

    /// Block-specific properties (e.g., heading level, list item type).
    Map<String, dynamic>? props,

    /// Child blocks (for nested structures like lists).
    List<BlockNoteBlock>? children,
  }) = _BlockNoteBlock;

  /// Creates a BlockNoteBlock from a JSON map.
  factory BlockNoteBlock.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteBlockFromJson(json);
}
