/// BlockNote document structure and schema versioning.
///
/// This file defines the document model that represents a complete
/// BlockNote document. Documents contain blocks and track schema versions
/// for future compatibility.
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'blocknote_block.dart';

part 'blocknote_document.freezed.dart';
part 'blocknote_document.g.dart';

/// BlockNote document schema version.
///
/// Used for schema versioning to support future migrations and compatibility.
@freezed
sealed class BlockNoteDocumentVersion with _$BlockNoteDocumentVersion {
  /// Creates a new document version.
  const factory BlockNoteDocumentVersion({
    @Default(1) int major,
    @Default(0) int minor,
    @Default(0) int patch,
  }) = _BlockNoteDocumentVersion;

  /// Creates a BlockNoteDocumentVersion from a JSON map.
  factory BlockNoteDocumentVersion.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteDocumentVersionFromJson(json);
}

/// BlockNote document structure.
///
/// Represents a complete BlockNote document containing blocks and metadata.
/// Documents are normalized and can be serialized to/from JSON for
/// communication with the JavaScript editor.
@freezed
sealed class BlockNoteDocument with _$BlockNoteDocument {
  /// Creates a new document instance.
  const factory BlockNoteDocument({
    /// The blocks that make up this document.
    required List<BlockNoteBlock> blocks,

    /// Optional schema version for future compatibility.
    BlockNoteDocumentVersion? version,
  }) = _BlockNoteDocument;

  /// Creates an empty document with a single paragraph block.
  factory BlockNoteDocument.empty() {
    return BlockNoteDocument(
      blocks: [
        BlockNoteBlock(
          id: 'root',
          type: BlockNoteBlockType.paragraph,
          content: [
            BlockNoteInlineContent(
              type: BlockNoteInlineContentType.text,
              text: '',
            ),
          ],
        ),
      ],
    );
  }

  /// Creates a BlockNoteDocument from a JSON map.
  factory BlockNoteDocument.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteDocumentFromJson(json);
}
