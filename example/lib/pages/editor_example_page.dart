import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
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
  bool _useDarkMode = false;
  bool _useCustomTheme = false;
  bool _useCustomToolbar = false;
  bool _useCustomSlashCommands = false;
  bool _useAvailableSlashCommands = false;
  bool _useCustomFont = false;
  bool _isDocumentLoaded = false;
  BlockNoteSlashCommandConfig? _customSlashConfig;
  final List<BlockNoteTransaction> _transactions = [];
  BlockNoteDocument _document = BlockNoteDocument.empty();
  BlockNoteController? _controller;
  final List<String> _customSchemaScriptAssets = const [
    'assets/custom_schema.js',
  ];
  final List<String> _customSchemaCssAssets = const [
    'assets/custom_schema.css',
  ];

  @override
  void initState() {
    super.initState();
    _loadDocumentFromJson();
  }

  Future<void> _loadDocumentFromJson() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/sample_document.json',
      );
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      setState(() {
        _document = BlockNoteDocument.fromJson(jsonData);
        _isDocumentLoaded = true;
      });
    } catch (e) {
      // If loading fails, create a document with a link example
      setState(() {
        _document = _createDocumentWithLink();
        _isDocumentLoaded = true;
      });
    }
  }

  BlockNoteDocument _createDocumentWithLink() {
    // Create a document with a link example
    return BlockNoteDocument.fromJson({
      'blocks': [
        {
          'id': generateBlockId(),
          'type': 'paragraph',
          'content': [
            {
              'type': 'text',
              'text': 'Welcome to BlockNote Editor! Tap this ',
              'styles': {},
            },
            {
              'type': 'link',
              'href': 'https://www.blocknotejs.org',
              'content': [
                {
                  'type': 'text',
                  'text': 'link',
                  'styles': {},
                },
              ],
            },
            {
              'type': 'text',
              'text': ' to see link handling in action.',
              'styles': {},
            },
          ],
          'props': {},
        },
      ],
    });
  }

  Future<void> _loadCustomSlashConfigWithAsset() async {
    if (!_useCustomSlashCommands || !mounted) return;
    try {
      final config = await EditorConfig.createCustomSlashCommandsWithAssetIcon();
      if (mounted && _useCustomSlashCommands) {
        setState(() => _customSlashConfig = config);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load slash config with asset icon: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _handleLinkTap(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid URL: $url'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cannot launch URL: $url'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error launching URL: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('BlockNote Editor Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_full),
            onPressed: () {
              _showEditorInModalBottomSheet(context);
            },
            tooltip: 'Open editor in modal bottom sheet',
          ),
          IconButton(
            icon: Icon(_useDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              setState(() {
                _useDarkMode = !_useDarkMode;
              });
            },
            tooltip: _useDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
          ),
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
              _loadDocumentFromJson();
              setState(() {
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
                    controller: _controller,
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
                    if (!_useCustomSlashCommands) {
                      _customSlashConfig = null;
                    } else {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _loadCustomSlashConfigWithAsset();
                      });
                    }
                    break;
                  case 'availableSlash':
                    _useAvailableSlashCommands = !_useAvailableSlashCommands;
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
                value: 'availableSlash',
                child: Row(
                  children: [
                    Icon(
                      _useAvailableSlashCommands
                          ? Icons.check
                          : Icons.circle_outlined,
                    ),
                    const SizedBox(width: 8),
                    const Text('Available Slash Commands'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'font',
                child: Row(
                  children: [
                    Icon(_useCustomFont ? Icons.check : Icons.circle_outlined),
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
            child: _isDocumentLoaded
                ? BlockNoteEditor(
                    initialDocument: _document,
                    onReady: (controller) {
                      if (!mounted) return;
                      setState(() {
                        _isReady = true;
                        _controller = controller;
                      });
                      if (!mounted) return;
                      final messenger = ScaffoldMessenger.of(context);
                      messenger.showSnackBar(
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
                    customJavaScriptAssetPaths: _customSchemaScriptAssets,
                    customCssAssetPaths: _customSchemaCssAssets,
                    schemaConfigs: const {
                      'agenda': {
                        'blockSpecs': ['agenda_item'],
                      },
                    },
                    activeSchemaId: 'agenda',
                    toolbarConfig: _useCustomToolbar
                        ? EditorConfig.createCustomToolbar()
                        : null,
                    slashCommandConfig: _useAvailableSlashCommands
                        ? EditorConfig.createAvailableSlashCommands()
                        : _useCustomSlashCommands
                            ? (_customSlashConfig ??
                                EditorConfig.createCustomSlashCommands())
                            : null,
                    onLinkTapped: _handleLinkTap,
                    // extraBottomPadding: 500,
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: _useDarkMode ? Colors.grey[850] : Colors.grey[200],
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
                    controller: _controller,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          if (_useDarkMode ||
              _useCustomTheme ||
              _useCustomToolbar ||
              _useCustomSlashCommands ||
              _useAvailableSlashCommands ||
              _useCustomFont)
            const SizedBox(width: 8),
          if (_useDarkMode ||
              _useCustomTheme ||
              _useCustomToolbar ||
              _useCustomSlashCommands ||
              _useAvailableSlashCommands ||
              _useCustomFont)
            Flexible(
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: [
                  if (_useDarkMode)
                    const Chip(
                      label: Text('Dark'),
                      labelStyle: TextStyle(fontSize: 10),
                      padding: EdgeInsets.symmetric(horizontal: 4),
                    ),
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
                  if (_useAvailableSlashCommands)
                    const Chip(
                      label: Text('Available Slash'),
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
    if (_useCustomTheme && _useDarkMode) {
      return EditorConfig.createDarkCustomTheme(useCustomFont: _useCustomFont);
    } else if (_useCustomTheme) {
      return EditorConfig.createCustomTheme(useCustomFont: _useCustomFont);
    } else if (_useDarkMode) {
      return EditorConfig.createDarkTheme(useCustomFont: _useCustomFont);
    } else if (_useCustomFont) {
      return EditorConfig.createFontTheme();
    }
    return null;
  }

  /// Sample documents for the document picker.
  static final List<_SampleDocument> _sampleDocuments = [
    _SampleDocument(
      title: 'Meeting Notes',
      subtitle: 'Team standup notes with action items',
      icon: Icons.groups,
      document: BlockNoteDocument.fromJson({
        'blocks': [
          {
            'id': 'meeting-h1',
            'type': 'heading',
            'content': [
              {'type': 'text', 'text': 'Team Standup - April 5', 'styles': {}},
            ],
            'props': {'level': 1},
          },
          {
            'id': 'meeting-p1',
            'type': 'paragraph',
            'content': [
              {
                'type': 'text',
                'text':
                    'Attendees: Alice, Bob, Charlie, Diana',
                'styles': {},
              },
            ],
          },
          {
            'id': 'meeting-h2',
            'type': 'heading',
            'content': [
              {'type': 'text', 'text': 'Updates', 'styles': {}},
            ],
            'props': {'level': 2},
          },
          {
            'id': 'meeting-bl1',
            'type': 'bulletListItem',
            'content': [
              {
                'type': 'text',
                'text': 'Alice: Completed API integration for user profiles',
                'styles': {},
              },
            ],
          },
          {
            'id': 'meeting-bl2',
            'type': 'bulletListItem',
            'content': [
              {
                'type': 'text',
                'text': 'Bob: Working on database migration scripts',
                'styles': {},
              },
            ],
          },
          {
            'id': 'meeting-bl3',
            'type': 'bulletListItem',
            'content': [
              {
                'type': 'text',
                'text': 'Charlie: Fixed 3 critical bugs in auth flow',
                'styles': {},
              },
            ],
          },
          {
            'id': 'meeting-h3',
            'type': 'heading',
            'content': [
              {'type': 'text', 'text': 'Action Items', 'styles': {}},
            ],
            'props': {'level': 2},
          },
          {
            'id': 'meeting-cl1',
            'type': 'checkListItem',
            'content': [
              {
                'type': 'text',
                'text': 'Review PR #42 by end of day',
                'styles': {},
              },
            ],
            'props': {'checked': false},
          },
          {
            'id': 'meeting-cl2',
            'type': 'checkListItem',
            'content': [
              {
                'type': 'text',
                'text': 'Schedule design review for next week',
                'styles': {},
              },
            ],
            'props': {'checked': true},
          },
        ],
      }),
    ),
    _SampleDocument(
      title: 'Project README',
      subtitle: 'Documentation with code examples',
      icon: Icons.description,
      document: BlockNoteDocument.fromJson({
        'blocks': [
          {
            'id': 'readme-h1',
            'type': 'heading',
            'content': [
              {'type': 'text', 'text': 'My Awesome Project', 'styles': {}},
            ],
            'props': {'level': 1},
          },
          {
            'id': 'readme-p1',
            'type': 'paragraph',
            'content': [
              {
                'type': 'text',
                'text':
                    'A lightweight and fast library for building modern applications. '
                    'It provides a clean API with zero dependencies.',
                'styles': {},
              },
            ],
          },
          {
            'id': 'readme-h2',
            'type': 'heading',
            'content': [
              {'type': 'text', 'text': 'Installation', 'styles': {}},
            ],
            'props': {'level': 2},
          },
          {
            'id': 'readme-p2',
            'type': 'paragraph',
            'content': [
              {
                'type': 'text',
                'text': 'Add the dependency to your ',
                'styles': {},
              },
              {
                'type': 'text',
                'text': 'pubspec.yaml',
                'styles': {'code': true},
              },
              {
                'type': 'text',
                'text': ' file:',
                'styles': {},
              },
            ],
          },
          {
            'id': 'readme-h3',
            'type': 'heading',
            'content': [
              {'type': 'text', 'text': 'Features', 'styles': {}},
            ],
            'props': {'level': 2},
          },
          {
            'id': 'readme-nl1',
            'type': 'numberedListItem',
            'content': [
              {
                'type': 'text',
                'text': 'Hot reload support',
                'styles': {'bold': true},
              },
              {
                'type': 'text',
                'text': ' - instant feedback during development',
                'styles': {},
              },
            ],
          },
          {
            'id': 'readme-nl2',
            'type': 'numberedListItem',
            'content': [
              {
                'type': 'text',
                'text': 'Type safety',
                'styles': {'bold': true},
              },
              {
                'type': 'text',
                'text': ' - catch errors at compile time',
                'styles': {},
              },
            ],
          },
          {
            'id': 'readme-nl3',
            'type': 'numberedListItem',
            'content': [
              {
                'type': 'text',
                'text': 'Cross-platform',
                'styles': {'bold': true},
              },
              {
                'type': 'text',
                'text': ' - iOS, Android, web, and desktop',
                'styles': {},
              },
            ],
          },
        ],
      }),
    ),
    _SampleDocument(
      title: 'Shopping List',
      subtitle: 'Weekly grocery checklist',
      icon: Icons.shopping_cart,
      document: BlockNoteDocument.fromJson({
        'blocks': [
          {
            'id': 'shop-h1',
            'type': 'heading',
            'content': [
              {'type': 'text', 'text': 'Weekly Groceries', 'styles': {}},
            ],
            'props': {'level': 1},
          },
          {
            'id': 'shop-h2a',
            'type': 'heading',
            'content': [
              {'type': 'text', 'text': 'Fruits & Vegetables', 'styles': {}},
            ],
            'props': {'level': 2},
          },
          {
            'id': 'shop-cl1',
            'type': 'checkListItem',
            'content': [
              {'type': 'text', 'text': 'Bananas (1 bunch)', 'styles': {}},
            ],
            'props': {'checked': true},
          },
          {
            'id': 'shop-cl2',
            'type': 'checkListItem',
            'content': [
              {'type': 'text', 'text': 'Avocados x3', 'styles': {}},
            ],
            'props': {'checked': false},
          },
          {
            'id': 'shop-cl3',
            'type': 'checkListItem',
            'content': [
              {'type': 'text', 'text': 'Spinach (fresh)', 'styles': {}},
            ],
            'props': {'checked': false},
          },
          {
            'id': 'shop-cl4',
            'type': 'checkListItem',
            'content': [
              {'type': 'text', 'text': 'Bell peppers (red & yellow)', 'styles': {}},
            ],
            'props': {'checked': true},
          },
          {
            'id': 'shop-h2b',
            'type': 'heading',
            'content': [
              {'type': 'text', 'text': 'Dairy & Protein', 'styles': {}},
            ],
            'props': {'level': 2},
          },
          {
            'id': 'shop-cl5',
            'type': 'checkListItem',
            'content': [
              {'type': 'text', 'text': 'Greek yogurt', 'styles': {}},
            ],
            'props': {'checked': false},
          },
          {
            'id': 'shop-cl6',
            'type': 'checkListItem',
            'content': [
              {'type': 'text', 'text': 'Eggs (dozen)', 'styles': {}},
            ],
            'props': {'checked': false},
          },
          {
            'id': 'shop-cl7',
            'type': 'checkListItem',
            'content': [
              {'type': 'text', 'text': 'Chicken breast (1 lb)', 'styles': {}},
            ],
            'props': {'checked': false},
          },
          {
            'id': 'shop-p1',
            'type': 'paragraph',
            'content': [
              {
                'type': 'text',
                'text': 'Budget: ~\$50',
                'styles': {'italic': true},
              },
            ],
          },
        ],
      }),
    ),
    _SampleDocument(
      title: 'Empty Document',
      subtitle: 'Start from scratch',
      icon: Icons.add_circle_outline,
      document: BlockNoteDocument.empty(),
    ),
  ];

  void _showEditorInModalBottomSheet(BuildContext context) {
    _showDocumentPickerModal(context);
  }

  void _showDocumentPickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select a Document',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(),
            ..._sampleDocuments.map(
              (doc) => ListTile(
                leading: Icon(doc.icon, size: 32),
                title: Text(doc.title),
                subtitle: Text(doc.subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).pop();
                  _openEditorModal(context, doc.title, doc.document);
                },
              ),
            ),
            // Also offer the main loaded document if available
            if (_isDocumentLoaded)
              ListTile(
                leading: const Icon(Icons.file_present, size: 32),
                title: const Text('Sample Document (from JSON)'),
                subtitle: const Text('The main page document'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).pop();
                  _openEditorModal(context, 'Sample Document', _document);
                },
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _openEditorModal(
    BuildContext context,
    String title,
    BlockNoteDocument document,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: BlockNoteEditor(
                initialDocument: document,
                onReady: (controller) {
                  if (!mounted) return;
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('$title ready!'),
                      duration: const Duration(seconds: 2),
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
                customJavaScriptAssetPaths: _customSchemaScriptAssets,
                customCssAssetPaths: _customSchemaCssAssets,
                schemaConfigs: const {
                  'agenda': {
                    'blockSpecs': ['agenda_item'],
                  },
                },
                activeSchemaId: 'agenda',
                toolbarConfig: _useCustomToolbar
                    ? EditorConfig.createCustomToolbar()
                    : null,
                slashCommandConfig: _useCustomSlashCommands
                    ? (_customSlashConfig ??
                        EditorConfig.createCustomSlashCommands())
                    : null,
                onLinkTapped: _handleLinkTap,
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class _SampleDocument {
  const _SampleDocument({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.document,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final BlockNoteDocument document;
}
