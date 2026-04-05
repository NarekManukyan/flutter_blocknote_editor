import 'package:flutter/material.dart';
import 'package:flutter_blocknote_editor/flutter_blocknote_editor.dart';
import 'pages/editor_example_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Pre-warm the editor WebView so modals and subsequent editor instances
  // display instantly without loading delay.
  BlockNoteEditorPool.instance.warmup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlockNote Editor Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EditorExamplePage(),
    );
  }
}
