import 'package:flutter/material.dart';
import 'package:flutter_blocknote_editor/flutter_blocknote_editor.dart';
import '../config/editor_config.dart';
import 'transaction_log_page.dart';

/// Editor example page demonstrating BlockNote editor usage.
class EditorExamplePage extends StatefulWidget {
  /// Creates a new editor example page.
  const EditorExamplePage({super.key});

  @override
  State<EditorExamplePage> createState() => _EditorExamplePageState();
}

class _EditorExamplePageState extends State<EditorExamplePage> {
  bool _isReady = false;
  bool _readOnly = false;
  bool _useCustomTheme = false;
  bool _useCustomToolbar = false;
  bool _useCustomSlashCommands = false;
  bool _useCustomFont = false;
  final List<BlockNoteTransaction> _transactions = [];
  BlockNoteDocument _document = BlockNoteDocument.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('BlockNote Editor Example'),
        actions: [
          IconButton(
            icon: Icon(_readOnly ? Icons.lock : Icons.lock_open),
            onPressed: () {
              setState(() {
                _readOnly = !_readOnly;
              });
            },
            tooltip: _readOnly ? 'Enable editing' : 'Disable editing',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _document = BlockNoteDocument.empty();
                _transactions.clear();
                _isReady = false;
              });
            },
            tooltip: 'Reset editor',
          ),
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.list_alt),
                if (_transactions.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '${_transactions.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TransactionLogPage(
                    transactions: _transactions,
                    onClear: () {
                      setState(() {
                        _transactions.clear();
                      });
                    },
                  ),
                ),
              );
            },
            tooltip: 'View transaction log',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                switch (value) {
                  case 'theme':
                    _useCustomTheme = !_useCustomTheme;
                    break;
                  case 'toolbar':
                    _useCustomToolbar = !_useCustomToolbar;
                    break;
                  case 'slash':
                    _useCustomSlashCommands = !_useCustomSlashCommands;
                    break;
                  case 'font':
                    _useCustomFont = !_useCustomFont;
                    break;
                }
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'theme',
                child: Row(
                  children: [
                    Icon(_useCustomTheme ? Icons.check : Icons.circle_outlined),
                    const SizedBox(width: 8),
                    const Text('Custom Theme'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'toolbar',
                child: Row(
                  children: [
                    Icon(
                      _useCustomToolbar ? Icons.check : Icons.circle_outlined,
                    ),
                    const SizedBox(width: 8),
                    const Text('Custom Toolbar'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'slash',
                child: Row(
                  children: [
                    Icon(
                      _useCustomSlashCommands
                          ? Icons.check
                          : Icons.circle_outlined,
                    ),
                    const SizedBox(width: 8),
                    const Text('Custom Slash Commands'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'font',
                child: Row(
                  children: [
                    Icon(
                      _useCustomFont ? Icons.check : Icons.circle_outlined,
                    ),
                    const SizedBox(width: 8),
                    const Text('Custom Font'),
                  ],
                ),
              ),
            ],
            icon: const Icon(Icons.settings),
            tooltip: 'Customization options',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildStatusBar(),
          Expanded(
            child: BlockNoteEditor(
              initialDocument: _document,
              onReady: () {
                setState(() {
                  _isReady = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Editor is ready!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              onTransactions: (transactions) {
                setState(() {
                  _transactions.addAll(transactions);
                });
              },
              readOnly: _readOnly,
              debugLogging: true,
              theme: _buildTheme(),
              toolbarConfig: _useCustomToolbar
                  ? EditorConfig.createCustomToolbar()
                  : null,
              slashCommandConfig: _useCustomSlashCommands
                  ? EditorConfig.createCustomSlashCommands()
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.grey[200],
      child: Row(
        children: [
          Icon(
            _isReady ? Icons.check_circle : Icons.hourglass_empty,
            color: _isReady ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 8),
          Text(
            _isReady ? 'Editor Ready' : 'Initializing...',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TransactionLogPage(
                    transactions: _transactions,
                    onClear: () {
                      setState(() {
                        _transactions.clear();
                      });
                    },
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              child: Text(
                'Transactions: ${_transactions.length}',
                style: TextStyle(
                  fontSize: 12,
                  color: _transactions.isNotEmpty
                      ? Theme.of(context).colorScheme.primary
                      : null,
                  fontWeight: _transactions.isNotEmpty
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Read-only: ${_readOnly ? "Yes" : "No"}',
            style: const TextStyle(fontSize: 12),
          ),
          if (_useCustomTheme ||
              _useCustomToolbar ||
              _useCustomSlashCommands ||
              _useCustomFont)
            const SizedBox(width: 8),
          if (_useCustomTheme ||
              _useCustomToolbar ||
              _useCustomSlashCommands ||
              _useCustomFont)
            Flexible(
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  if (_useCustomTheme)
                    const Chip(
                      label: Text('Theme'),
                      labelStyle: TextStyle(fontSize: 10),
                      padding: EdgeInsets.symmetric(horizontal: 4),
                    ),
                  if (_useCustomToolbar)
                    const Chip(
                      label: Text('Toolbar'),
                      labelStyle: TextStyle(fontSize: 10),
                      padding: EdgeInsets.symmetric(horizontal: 4),
                    ),
                  if (_useCustomSlashCommands)
                    const Chip(
                      label: Text('Slash'),
                      labelStyle: TextStyle(fontSize: 10),
                      padding: EdgeInsets.symmetric(horizontal: 4),
                    ),
                  if (_useCustomFont)
                    const Chip(
                      label: Text('Font'),
                      labelStyle: TextStyle(fontSize: 10),
                      padding: EdgeInsets.symmetric(horizontal: 4),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  BlockNoteTheme? _buildTheme() {
    if (_useCustomTheme) {
      return EditorConfig.createCustomTheme(useCustomFont: _useCustomFont);
    } else if (_useCustomFont) {
      return EditorConfig.createFontTheme();
    }
    return null;
  }
}
