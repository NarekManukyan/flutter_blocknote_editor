/// BlockNote document structure and schema versioning.
///
/// This file defines the document model that represents a complete
/// BlockNote document. Documents contain blocks and track schema versions
/// for future compatibility.
library;

import 'blocknote_block.dart';

/// BlockNote document schema version.
///
/// Used for schema versioning to support future migrations and compatibility.
class BlockNoteDocumentVersion {
  /// Creates a new document version.
  const BlockNoteDocumentVersion({
    this.major = 1,
    this.minor = 0,
    this.patch = 0,
  });

  final int major;
  final int minor;
  final int patch;

  /// Creates a BlockNoteDocumentVersion from a JSON map.
  factory BlockNoteDocumentVersion.fromJson(Map<String, dynamic> json) {
    return BlockNoteDocumentVersion(
      major: json['major'] as int? ?? 1,
      minor: json['minor'] as int? ?? 0,
      patch: json['patch'] as int? ?? 0,
    );
  }

  /// Converts this version to JSON.
  Map<String, dynamic> toJson() {
    return {
      'major': major,
      'minor': minor,
      'patch': patch,
    };
  }

  BlockNoteDocumentVersion copyWith({
    int? major,
    int? minor,
    int? patch,
  }) {
    return BlockNoteDocumentVersion(
      major: major ?? this.major,
      minor: minor ?? this.minor,
      patch: patch ?? this.patch,
    );
  }

  @override
  String toString() {
    return 'BlockNoteDocumentVersion(major: $major, minor: $minor, patch: $patch)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteDocumentVersion &&
            other.major == major &&
            other.minor == minor &&
            other.patch == patch;
  }

  @override
  int get hashCode => Object.hash(major, minor, patch);
}

/// BlockNote document structure.
///
/// Represents a complete BlockNote document containing blocks and metadata.
/// Documents are normalized and can be serialized to/from JSON for
/// communication with the JavaScript editor.
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

  /// Creates an empty document with a single paragraph block.
  factory BlockNoteDocument.empty() {
    return BlockNoteDocument(
      blocks: [
        BlockNoteBlock(
          id: 'root',
          type: BlockNoteBlockType.paragraph,
          content: BlockNoteBlockContent.inline(
            content: [
              BlockNoteInlineContent.text(text: ''),
            ],
          ),
        ),
      ],
    );
  }

  /// Creates a BlockNoteDocument from a JSON map.
  factory BlockNoteDocument.fromJson(Map<String, dynamic> json) {
    return BlockNoteDocument(
      blocks: (json['blocks'] as List<dynamic>? ?? [])
          .whereType<Map>()
          .map((block) => BlockNoteBlock.fromJson(
                Map<String, dynamic>.from(block),
              ))
          .toList(),
      version: json['version'] == null
          ? null
          : BlockNoteDocumentVersion.fromJson(
              Map<String, dynamic>.from(json['version'] as Map),
            ),
    );
  }

  /// Converts this document to JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'blocks': blocks.map((block) => block.toJson()).toList(),
    };
    if (version != null) {
      json['version'] = version!.toJson();
    }
    return json;
  }

  BlockNoteDocument copyWith({
    List<BlockNoteBlock>? blocks,
    Object? version = _unset,
  }) {
    return BlockNoteDocument(
      blocks: blocks ?? this.blocks,
      version: identical(version, _unset)
          ? this.version
          : version as BlockNoteDocumentVersion?,
    );
  }

  @override
  String toString() => 'BlockNoteDocument(blocks: $blocks, version: $version)';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is BlockNoteDocument &&
            _listEquals(other.blocks, blocks) &&
            other.version == version;
  }

  @override
  int get hashCode => Object.hash(_listHash(blocks), version);
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
