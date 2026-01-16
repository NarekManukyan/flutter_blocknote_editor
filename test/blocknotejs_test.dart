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

  group('BlockNoteDocument JSON Parsing', () {
    test('should parse document with empty styles maps', () {
      final jsonData = {
        'blocks': [
          {
            'id': 'block1',
            'type': 'heading',
            'content': [
              {'type': 'text', 'text': 'Welcome to BlockNote Editor'},
            ],
            'props': {'level': 1},
          },
          {
            'id': 'block2',
            'type': 'paragraph',
            'content': [
              {
                'type': 'text',
                'text': 'Test content',
                'styles': {},
              },
            ],
          },
        ],
      };

      final document = BlockNoteDocument.fromJson(jsonData);

      expect(document.blocks.length, equals(2));
      expect(document.blocks.first.type, equals(BlockNoteBlockType.heading));
      expect(document.blocks[1].content?.first.text, equals('Test content'));
      // Empty styles map should be treated as null or empty map
      expect(
        document.blocks[1].content?.first.styles,
        anyOf(isNull, isEmpty),
      );
    });

    test('should parse complex document with various block types', () {
      final jsonData = {
        'blocks': [
          {
            'id': 'block1',
            'type': 'heading',
            'content': [
              {'type': 'text', 'text': 'Welcome to BlockNote Editor'},
            ],
            'props': {'level': 1},
          },
          {
            'id': 'block2',
            'type': 'paragraph',
            'content': [
              {
                'type': 'text',
                'text':
                    'This is a sample document loaded from JSON. It demonstrates various block types and formatting options available in the BlockNote editor.',
              },
            ],
          },
          {
            'id': 'block3',
            'type': 'heading',
            'content': [
              {'type': 'text', 'text': 'Features'},
            ],
            'props': {'level': 2},
          },
          {
            'id': 'block4',
            'type': 'bulletListItem',
            'content': [
              {
                'type': 'text',
                'text': 'Rich text editing with formatting options',
              },
            ],
          },
          {
            'id': 'block5',
            'type': 'bulletListItem',
            'content': [
              {
                'type': 'text',
                'text':
                    'Multiple block types (headings, lists, code blocks, etc.)',
              },
            ],
          },
          {
            'id': 'block6',
            'type': 'bulletListItem',
            'content': [
              {
                'type': 'text',
                'text': 'Nested structures and hierarchical content',
              },
            ],
          },
          {
            'id': 'block7',
            'type': 'heading',
            'content': [
              {'type': 'text', 'text': 'Try It Out'},
            ],
            'props': {'level': 2},
          },
          {
            'id': 'block8',
            'type': 'paragraph',
            'content': [
              {
                'type': 'text',
                'text':
                    'You can edit this document, add new blocks, format text, and see all changes reflected in real-time. The editor supports ',
                'styles': {},
              },
              {
                'type': 'text',
                'text': 'bold',
                'styles': {'bold': true},
              },
              {'type': 'text', 'text': ', ', 'styles': {}},
              {
                'type': 'text',
                'text': 'italic',
                'styles': {'italic': true},
              },
              {'type': 'text', 'text': ', and ', 'styles': {}},
              {
                'type': 'text',
                'text': 'underline',
                'styles': {'underline': true},
              },
              {'type': 'text', 'text': ' formatting.'},
            ],
          },
          {
            'id': 'block9',
            'type': 'numberedListItem',
            'content': [
              {'type': 'text', 'text': 'First numbered item'},
            ],
          },
          {
            'id': 'block10',
            'type': 'numberedListItem',
            'content': [
              {'type': 'text', 'text': 'Second numbered item'},
            ],
          },
          {
            'id': 'block11',
            'type': 'paragraph',
            'content': [
              {'type': 'text', 'text': 'Happy editing! 🎉'},
            ],
          },
        ],
      };

      final document = BlockNoteDocument.fromJson(jsonData);

      expect(document.blocks.length, equals(11));
      expect(document.blocks[0].type, equals(BlockNoteBlockType.heading));
      expect(document.blocks[0].props?['level'], equals(1));
      expect(document.blocks[1].type, equals(BlockNoteBlockType.paragraph));
      expect(document.blocks[3].type, equals(BlockNoteBlockType.bulletListItem));
      expect(document.blocks[7].content?.length, equals(7));
      expect(
        document.blocks[7].content?[1].styles?['bold'],
        isTrue,
      );
      expect(
        document.blocks[7].content?[3].styles?['italic'],
        isTrue,
      );
      expect(
        document.blocks[7].content?[5].styles?['underline'],
        isTrue,
      );
      expect(document.blocks[8].type, equals(BlockNoteBlockType.numberedListItem));
    });

    test('should parse inline content with missing styles', () {
      final jsonData = {
        'blocks': [
          {
            'id': 'block1',
            'type': 'paragraph',
            'content': [
              {'type': 'text', 'text': 'No styles'},
              {
                'type': 'text',
                'text': 'With styles',
                'styles': {'bold': true, 'italic': false},
              },
            ],
          },
        ],
      };

      final document = BlockNoteDocument.fromJson(jsonData);

      expect(document.blocks.first.content?.length, equals(2));
      expect(document.blocks.first.content?.first.styles, isNull);
      expect(
        document.blocks.first.content?[1].styles?['bold'],
        isTrue,
      );
      expect(
        document.blocks.first.content?[1].styles?['italic'],
        isFalse,
      );
    });

    test('should handle blocks without content', () {
      final jsonData = {
        'blocks': [
          {
            'id': 'block1',
            'type': 'paragraph',
          },
        ],
      };

      final document = BlockNoteDocument.fromJson(jsonData);

      expect(document.blocks.length, equals(1));
      expect(document.blocks.first.content, isNull);
    });

    test('should handle nested blocks with children', () {
      final jsonData = {
        'blocks': [
          {
            'id': 'parent',
            'type': 'bulletListItem',
            'content': [
              {'type': 'text', 'text': 'Parent item'},
            ],
            'children': [
              {
                'id': 'child1',
                'type': 'bulletListItem',
                'content': [
                  {'type': 'text', 'text': 'Child item 1'},
                ],
              },
              {
                'id': 'child2',
                'type': 'bulletListItem',
                'content': [
                  {'type': 'text', 'text': 'Child item 2'},
                ],
              },
            ],
          },
        ],
      };

      final document = BlockNoteDocument.fromJson(jsonData);

      expect(document.blocks.length, equals(1));
      expect(document.blocks.first.children?.length, equals(2));
      expect(document.blocks.first.children?[0].id, equals('child1'));
      expect(document.blocks.first.children?[1].id, equals('child2'));
    });

    test('should round-trip serialize and deserialize complex document', () {
      final originalJson = {
        'blocks': [
          {
            'id': 'block1',
            'type': 'heading',
            'content': [
              {'type': 'text', 'text': 'Title'},
            ],
            'props': {'level': 1},
          },
          {
            'id': 'block2',
            'type': 'paragraph',
            'content': [
              {
                'type': 'text',
                'text': 'Text with ',
                'styles': {},
              },
              {
                'type': 'text',
                'text': 'bold',
                'styles': {'bold': true},
              },
              {'type': 'text', 'text': ' text.'},
            ],
          },
        ],
      };

      final document = BlockNoteDocument.fromJson(originalJson);
      final serialized = document.toJson();
      final deserialized = BlockNoteDocument.fromJson(serialized);

      expect(deserialized.blocks.length, equals(2));
      expect(deserialized.blocks[0].type, equals(BlockNoteBlockType.heading));
      expect(deserialized.blocks[1].content?.length, equals(3));
      expect(
        deserialized.blocks[1].content?[1].styles?['bold'],
        isTrue,
      );
    });
  });
}
