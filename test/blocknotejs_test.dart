import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_blocknote_editor/flutter_blocknote_editor.dart';

void main() {
  group('BlockNoteEditor', () {
    test('should create empty document', () {
      final document = BlockNoteDocument.empty();
      expect(document.blocks, isNotEmpty);
      expect(document.blocks.first.type, BlockNoteBlockType.paragraph);
    });

    test('should serialize and deserialize document', () {
      final document = BlockNoteDocument(
        blocks: [
          BlockNoteBlock(
            id: 'block1',
            type: BlockNoteBlockType.paragraph,
            content: [
              BlockNoteInlineContent(
                type: BlockNoteInlineContentType.text,
                text: 'Test content',
              ),
            ],
          ),
        ],
      );

      final json = document.toJson();
      final deserialized = BlockNoteDocument.fromJson(json);

      expect(deserialized.blocks.length, equals(1));
      expect(deserialized.blocks.first.id, equals('block1'));
      expect(deserialized.blocks.first.content?.first.text, equals('Test content'));
    });

    test('should serialize and deserialize transaction', () {
      final transaction = BlockNoteTransaction(
        baseVersion: 1,
        operations: [
          BlockNoteTransactionOp(
            operation: BlockNoteTransactionOperation.insert,
            blockId: 'block1',
            block: BlockNoteBlock(
              id: 'block1',
              type: BlockNoteBlockType.paragraph,
              content: [
                BlockNoteInlineContent(
                  type: BlockNoteInlineContentType.text,
                  text: 'New block',
                ),
              ],
            ),
            index: 0,
          ),
        ],
        timestamp: 1234567890,
      );

      final json = transaction.toJson();
      final deserialized = BlockNoteTransaction.fromJson(json);

      expect(deserialized.baseVersion, equals(1));
      expect(deserialized.operations.length, equals(1));
      expect(deserialized.operations.first.operation, equals(BlockNoteTransactionOperation.insert));
      expect(deserialized.operations.first.blockId, equals('block1'));
      expect(deserialized.timestamp, equals(1234567890));
    });

    test('should handle block with inline content', () {
      final block = BlockNoteBlock(
        id: 'block1',
        type: BlockNoteBlockType.heading,
        content: [
          BlockNoteInlineContent(
            type: BlockNoteInlineContentType.text,
            text: 'Heading',
            styles: {'bold': true},
          ),
        ],
        props: {'level': 1},
      );

      final json = block.toJson();
      final deserialized = BlockNoteBlock.fromJson(json);

      expect(deserialized.type, equals(BlockNoteBlockType.heading));
      expect(deserialized.content?.first.text, equals('Heading'));
      expect(deserialized.content?.first.styles?['bold'], isTrue);
      expect(deserialized.props?['level'], equals(1));
    });

    test('should handle nested blocks', () {
      final block = BlockNoteBlock(
        id: 'parent',
        type: BlockNoteBlockType.bulletListItem,
        content: [
          BlockNoteInlineContent(
            type: BlockNoteInlineContentType.text,
            text: 'Parent item',
          ),
        ],
        children: [
          BlockNoteBlock(
            id: 'child',
            type: BlockNoteBlockType.bulletListItem,
            content: [
              BlockNoteInlineContent(
                type: BlockNoteInlineContentType.text,
                text: 'Child item',
              ),
            ],
          ),
        ],
      );

      final json = block.toJson();
      final deserialized = BlockNoteBlock.fromJson(json);

      expect(deserialized.children, isNotEmpty);
      expect(deserialized.children?.first.id, equals('child'));
    });

    test('should handle document version', () {
      final document = BlockNoteDocument(
        blocks: [
          BlockNoteBlock(
            id: 'block1',
            type: BlockNoteBlockType.paragraph,
            content: [
              BlockNoteInlineContent(
                type: BlockNoteInlineContentType.text,
                text: 'Test',
              ),
            ],
          ),
        ],
        version: const BlockNoteDocumentVersion(major: 1, minor: 0, patch: 0),
      );

      final json = document.toJson();
      final deserialized = BlockNoteDocument.fromJson(json);

      expect(deserialized.version?.major, equals(1));
      expect(deserialized.version?.minor, equals(0));
      expect(deserialized.version?.patch, equals(0));
    });
  });
}
