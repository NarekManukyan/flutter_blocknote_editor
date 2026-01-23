import 'package:flutter/material.dart';
import 'package:flutter_blocknote_editor/flutter_blocknote_editor.dart';

/// Transaction log page showing all editor transactions.
class TransactionLogPage extends StatelessWidget {
  /// Creates a new transaction log page.
  const TransactionLogPage({
    required this.transactions,
    required this.onClear,
    this.controller,
    super.key,
  });

  /// List of transactions to display.
  final List<BlockNoteTransaction> transactions;

  /// Callback when clear button is pressed.
  final VoidCallback onClear;

  /// Optional controller to retrieve full document for block lookup.
  final BlockNoteController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Log'),
        actions: [
          if (transactions.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Clear Transactions'),
                    content: const Text(
                      'Are you sure you want to clear all transactions?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          onClear();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Clear'),
                      ),
                    ],
                  ),
                );
              },
              tooltip: 'Clear all transactions',
            ),
        ],
      ),
      body: transactions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.list_alt, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions yet',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start editing to see transactions',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Total: ${transactions.length} transaction(s)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return _TransactionCard(
                        transaction: transaction,
                        index: index,
                        controller: controller,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

/// Expandable card widget for displaying transaction details.
class _TransactionCard extends StatefulWidget {
  /// Creates a new transaction card.
  const _TransactionCard({
    required this.transaction,
    required this.index,
    this.controller,
  });

  /// The transaction to display.
  final BlockNoteTransaction transaction;

  /// The index of this transaction.
  final int index;

  /// Optional controller to retrieve full document for block lookup.
  final BlockNoteController? controller;

  @override
  State<_TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<_TransactionCard> {
  bool _isExpanded = false;
  BlockNoteDocument? _document;
  bool _isLoadingDocument = false;

  /// Extracts text content from a block.
  String _extractBlockText(BlockNoteBlock? block) {
    if (block == null) return 'null';

    final content = block.content;
    if (content is BlockNoteInlineContentList && content.content.isNotEmpty) {
      return content.content
          .map(_extractInlineText)
          .where((text) => text.isNotEmpty)
          .join(' ');
    }

    return '(no text)';
  }

  String _extractInlineText(BlockNoteInlineContent content) {
    if (content is BlockNoteTextContent) {
      return content.text;
    }
    if (content is BlockNoteLinkContent) {
      return content.content.map((item) => item.text).join(' ');
    }
    if (content is BlockNoteCustomInlineContent) {
      return content.content?.map((item) => item.text).join(' ') ?? '';
    }
    return '';
  }

  int? _inlineContentCount(BlockNoteBlock block) {
    final content = block.content;
    if (content is BlockNoteInlineContentList) {
      return content.content.length;
    }
    return null;
  }

  int? _tableRowCount(BlockNoteBlock block) {
    final content = block.content;
    if (content is BlockNoteTableBlockContent) {
      return content.content.rows.length;
    }
    return null;
  }

  /// Formats block type for display.
  String _formatBlockType(BlockNoteBlockType type) {
    return type.name;
  }

  /// Finds a block by ID from the transaction operations or the full document.
  BlockNoteBlock? _findBlockById(String blockId) {
    // First, try to find in transaction operations
    for (final op in widget.transaction.operations) {
      if (op.blockId == blockId && op.block != null) {
        return op.block;
      }
    }

    // If not found in transaction, search in the full document
    if (_document != null) {
      return _findBlockInDocument(_document!.blocks, blockId);
    }

    return null;
  }

  /// Recursively searches for a block by ID in a list of blocks.
  BlockNoteBlock? _findBlockInDocument(
    List<BlockNoteBlock> blocks,
    String blockId,
  ) {
    for (final block in blocks) {
      if (block.id == blockId) {
        return block;
      }
      // Search in children recursively
      if (block.children != null && block.children!.isNotEmpty) {
        final found = _findBlockInDocument(block.children!, blockId);
        if (found != null) {
          return found;
        }
      }
    }
    return null;
  }

  /// Fetches the full document from the controller if available.
  Future<void> _fetchDocument() async {
    if (widget.controller == null ||
        !widget.controller!.isReady ||
        _isLoadingDocument ||
        _document != null) {
      return;
    }

    setState(() {
      _isLoadingDocument = true;
    });

    try {
      final document = await widget.controller!.getDocument();
      if (mounted) {
        setState(() {
          _document = document;
          _isLoadingDocument = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingDocument = false;
        });
      }
    }
  }

  /// Builds a widget showing the content of a block by ID.
  Widget _buildBlockContentWidget(String blockId) {
    final block = _findBlockById(blockId);
    if (block != null) {
      final text = _extractBlockText(block);
      return Text(
        'Content: ${text.isEmpty ? "(empty)" : text}',
        style: const TextStyle(fontSize: 10, color: Colors.grey),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }

    // Show appropriate message based on document loading state
    if (_isLoadingDocument) {
      return Text(
        'Content: (loading document...)',
        style: TextStyle(
          fontSize: 10,
          color: Colors.grey[500],
          fontStyle: FontStyle.italic,
        ),
      );
    }

    if (widget.controller != null && _document == null) {
      return Text(
        'Content: (not found in transaction, document not loaded)',
        style: TextStyle(
          fontSize: 10,
          color: Colors.grey[500],
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Text(
      'Content: (not found)',
      style: TextStyle(
        fontSize: 10,
        color: Colors.grey[500],
        fontStyle: FontStyle.italic,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                '${widget.index + 1}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              'Transaction ${widget.index + 1}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  'Base version: ${widget.transaction.baseVersion}',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'Operations: ${widget.transaction.operations.length}',
                  style: const TextStyle(fontSize: 12),
                ),
                if (widget.transaction.timestamp != null)
                  Text(
                    'Time: ${DateTime.fromMillisecondsSinceEpoch(widget.transaction.timestamp!).toString().substring(0, 19)}',
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
            trailing: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
              // Fetch document when expanded if controller is available
              if (_isExpanded && widget.controller != null) {
                _fetchDocument();
              }
            },
            isThreeLine: true,
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    'Operations:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...widget.transaction.operations.map((op) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Chip(
                                  label: Text(
                                    op.operation.name.toUpperCase(),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Block ID: ${op.blockId}',
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            if (op.block != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Type: ${_formatBlockType(op.block!.type)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Text: ${_extractBlockText(op.block)}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              if (_inlineContentCount(op.block!) != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Content items: ${_inlineContentCount(op.block!)}',
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                              if (_tableRowCount(op.block!) != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Table rows: ${_tableRowCount(op.block!)}',
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                              if (op.block!.props != null &&
                                  op.block!.props!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Props: ${op.block!.props}',
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                              if (op.block!.children != null &&
                                  op.block!.children!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Children: ${op.block!.children!.length}',
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            ] else ...[
                              const SizedBox(height: 4),
                              Text(
                                'Block: null',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                            if (op.index != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Index: ${op.index}',
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                            if (op.parentId != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Parent ID: ${op.parentId}',
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                            if (op.beforeChildId != null) ...[
                              const SizedBox(height: 4),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_upward,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Before Block:',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ID: ${op.beforeChildId}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey[600],
                                            fontFamily: 'monospace',
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        _buildBlockContentWidget(
                                          op.beforeChildId!,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (op.afterChildId != null) ...[
                              const SizedBox(height: 4),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.arrow_downward,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'After Block:',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ID: ${op.afterChildId}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey[600],
                                            fontFamily: 'monospace',
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        _buildBlockContentWidget(
                                          op.afterChildId!,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
