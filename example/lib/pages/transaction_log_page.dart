import 'package:flutter/material.dart';
import 'package:flutter_blocknote_editor/flutter_blocknote_editor.dart';

/// Transaction log page showing all editor transactions.
class TransactionLogPage extends StatelessWidget {
  /// Creates a new transaction log page.
  const TransactionLogPage({
    required this.transactions,
    required this.onClear,
    super.key,
  });

  /// List of transactions to display.
  final List<BlockNoteTransaction> transactions;

  /// Callback when clear button is pressed.
  final VoidCallback onClear;

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
                  Icon(
                    Icons.list_alt,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions yet',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start editing to see transactions',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Theme.of(context).colorScheme.surfaceVariant,
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
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
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
  });

  /// The transaction to display.
  final BlockNoteTransaction transaction;

  /// The index of this transaction.
  final int index;

  @override
  State<_TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<_TransactionCard> {
  bool _isExpanded = false;

  /// Extracts text content from a block.
  String _extractBlockText(BlockNoteBlock? block) {
    if (block == null) return 'null';
    
    if (block.content != null && block.content!.isNotEmpty) {
      return block.content!
          .map((item) => item.text)
          .where((text) => text.isNotEmpty)
          .join(' ');
    }
    
    return '(no text)';
  }

  /// Formats block type for display.
  String _formatBlockType(BlockNoteBlockType type) {
    return type.name;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                '${widget.index + 1}',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onPrimaryContainer,
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
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
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
                  ...widget.transaction.operations.map(
                    (op) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceVariant
                            .withOpacity(0.3),
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
                                    backgroundColor:
                                        Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
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
                                if (op.block!.content != null &&
                                    op.block!.content!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    'Content items: ${op.block!.content!.length}',
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
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
