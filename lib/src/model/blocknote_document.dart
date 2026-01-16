/// BlockNote document structure and schema versioning.
///
/// This file defines the document model that represents a complete
/// BlockNote document. Documents contain blocks and track schema versions
/// for future compatibility.
library;

import 'package:json_annotation/json_annotation.dart';
import 'blocknote_block.dart';

part 'blocknote_document.g.dart';

/// BlockNote document schema version.
///
/// Used for schema versioning to support future migrations and compatibility.
@JsonSerializable()
class BlockNoteDocumentVersion {
  /// Creates a new document version.
  const BlockNoteDocumentVersion({
    this.major = 1,
    this.minor = 0,
    this.patch = 0,
  });

  /// Major version number.
  final int major;

  /// Minor version number.
  final int minor;

  /// Patch version number.
  final int patch;

  /// Creates a BlockNoteDocumentVersion from a JSON map.
  factory BlockNoteDocumentVersion.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteDocumentVersionFromJson(json);

  /// Converts this instance to a JSON map.
  Map<String, dynamic> toJson() => _$BlockNoteDocumentVersionToJson(this);

  @override
  String toString() => '$major.$minor.$patch';
}

/// BlockNote document structure.
///
/// Represents a complete BlockNote document containing blocks and metadata.
/// Documents are normalized and can be serialized to/from JSON for
/// communication with the JavaScript editor.
@JsonSerializable()
class BlockNoteDocument {
  /// Creates a new document instance.
  const BlockNoteDocument({
    required this.blocks,
    this.version,
  });

  /// The blocks that make up this document.
  final List<BlockNoteBlock> blocks;

  /// Optional schema version for future compatibility.
  final BlockNoteDocumentVersion? version;

  /// Creates a BlockNoteDocument from a JSON map.
  factory BlockNoteDocument.fromJson(Map<String, dynamic> json) =>
      _$BlockNoteDocumentFromJson(json);

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

  /// Converts this instance to a JSON map.
  Map<String, dynamic> toJson() => _$BlockNoteDocumentToJson(this);
}
