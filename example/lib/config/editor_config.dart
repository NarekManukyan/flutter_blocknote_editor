import 'package:flutter/material.dart';
import 'package:flutter_blocknote_editor/flutter_blocknote_editor.dart';

/// Editor configuration utilities for example app.
class EditorConfig {
  /// Creates a custom theme with red color scheme.
  static BlockNoteTheme createCustomTheme({required bool useCustomFont}) {
    return BlockNoteTheme(
      colors: BlockNoteColorScheme(
        editor: const BlockNoteColorPair(
          text: Color(0xFF222222),
          background: Color(0xFFFEEEEE),
        ),
        menu: const BlockNoteColorPair(
          text: Color(0xFFFFFFFF),
          background: Color(0xFF9B0000),
        ),
        tooltip: const BlockNoteColorPair(
          text: Color(0xFFFFFFFF),
          background: Color(0xFFB00000),
        ),
        hovered: const BlockNoteColorPair(
          text: Color(0xFFFFFFFF),
          background: Color(0xFFB00000),
        ),
        selected: const BlockNoteColorPair(
          text: Color(0xFFFFFFFF),
          background: Color(0xFFC50000),
        ),
        shadow: const Color(0xFF640000),
        border: const Color(0xFF870000),
      ),
      borderRadius: 4,
      font: useCustomFont
          ? const BlockNoteFontConfig(
              family: "'Georgia', 'Times New Roman', serif",
            )
          : null,
    );
  }

  /// Creates a dark theme.
  static BlockNoteTheme createDarkTheme({bool useCustomFont = false}) {
    return BlockNoteTheme(
      colors: BlockNoteColorScheme(
        editor: const BlockNoteColorPair(
          text: Color(0xFFE0E0E0),
          background: Color(0xFF1A1A1A),
        ),
        menu: const BlockNoteColorPair(
          text: Color(0xFFE0E0E0),
          background: Color(0xFF2D2D2D),
        ),
        tooltip: const BlockNoteColorPair(
          text: Color(0xFFE0E0E0),
          background: Color(0xFF383838),
        ),
        hovered: const BlockNoteColorPair(
          text: Color(0xFFFFFFFF),
          background: Color(0xFF3D3D3D),
        ),
        selected: const BlockNoteColorPair(
          text: Color(0xFFFFFFFF),
          background: Color(0xFF4A4A4A),
        ),
        shadow: const Color(0xFF000000),
        border: const Color(0xFF444444),
      ),
      borderRadius: 4,
      font: useCustomFont
          ? const BlockNoteFontConfig(
              family: "'Georgia', 'Times New Roman', serif",
            )
          : null,
    );
  }

  /// Creates a dark variant of the custom red theme.
  static BlockNoteTheme createDarkCustomTheme({bool useCustomFont = false}) {
    return BlockNoteTheme(
      colors: BlockNoteColorScheme(
        editor: const BlockNoteColorPair(
          text: Color(0xFFE0E0E0),
          background: Color(0xFF1A0000),
        ),
        menu: const BlockNoteColorPair(
          text: Color(0xFFFFFFFF),
          background: Color(0xFF7B0000),
        ),
        tooltip: const BlockNoteColorPair(
          text: Color(0xFFFFFFFF),
          background: Color(0xFF900000),
        ),
        hovered: const BlockNoteColorPair(
          text: Color(0xFFFFFFFF),
          background: Color(0xFF900000),
        ),
        selected: const BlockNoteColorPair(
          text: Color(0xFFFFFFFF),
          background: Color(0xFFA50000),
        ),
        shadow: const Color(0xFF400000),
        border: const Color(0xFF600000),
      ),
      borderRadius: 4,
      font: useCustomFont
          ? const BlockNoteFontConfig(
              family: "'Georgia', 'Times New Roman', serif",
            )
          : null,
    );
  }

  /// Creates a simple font-only theme.
  static BlockNoteTheme createFontTheme() {
    return BlockNoteTheme(
      font: const BlockNoteFontConfig(
        family: "'Georgia', 'Times New Roman', serif",
      ),
    );
  }

  /// Creates a custom toolbar configuration.
  static BlockNoteToolbarConfig createCustomToolbar() {
    return BlockNoteToolbarConfig(
      buttons: [
        const BlockNoteToolbarButton(
          type: BlockNoteToolbarButtonType.blockTypeSelect,
        ),
        const BlockNoteToolbarButton(
          type: BlockNoteToolbarButtonType.basicTextStyleButton,
          basicTextStyle: BlockNoteBasicTextStyle.bold,
        ),
        const BlockNoteToolbarButton(
          type: BlockNoteToolbarButtonType.basicTextStyleButton,
          basicTextStyle: BlockNoteBasicTextStyle.italic,
        ),
        const BlockNoteToolbarButton(
          type: BlockNoteToolbarButtonType.basicTextStyleButton,
          basicTextStyle: BlockNoteBasicTextStyle.underline,
        ),
        const BlockNoteToolbarButton(
          type: BlockNoteToolbarButtonType.colorStyleButton,
        ),
        const BlockNoteToolbarButton(
          type: BlockNoteToolbarButtonType.createLinkButton,
        ),
      ],
    );
  }

  /// Minimal 1x1 transparent PNG as data URL (for testing image icon).
  static const String _kTestPngDataUrl =
      'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk+M9QDwADhgGAWjR9awAAAABJRU5ErkJggg==';

  /// Sample image URL for demonstrating image block insertion.
  static const String _kSampleImageUrl =
      'https://upload.wikimedia.org/wikipedia/commons/7/70/Example.png';
   
  /// Small circle SVG string (for testing SVG icon).
  static const String _kTestSvgCircle =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/></svg>';

  /// Creates a custom slash command configuration with all icon variants.
  ///
  /// Items demonstrate: emoji (string), text icon, SVG icon, and image (data URL).
  static BlockNoteSlashCommandConfig createCustomSlashCommands() {
    return BlockNoteSlashCommandConfig(
      items: [
        BlockNoteSlashCommandItem.paragraph(
          title: 'Insert Hello World',
          content: 'Hello World',
          aliases: ['helloworld', 'hw'],
          group: 'Custom',
          subtext: 'Inserts paragraph with emoji icon',
          icon: '📝',
        ),
        BlockNoteSlashCommandItem.paragraph(
          title: 'Insert Greeting',
          content: 'Hi there!',
          aliases: ['greeting', 'hi'],
          group: 'Custom',
          subtext: 'Inserts paragraph with text icon',
          icon: const BlockNoteSlashCommandIconText('Hi'),
        ),
        BlockNoteSlashCommandItem(
          title: 'Insert Image',
          onItemClick:
              "editor.insertBlocks([{type: 'image', props: {url: '$_kSampleImageUrl'}}], editor.getTextCursorPosition().block, 'after');",
          aliases: ['image', 'img', 'photo'],
          group: 'Custom',
          subtext: 'Inserts an image block',
          icon: const BlockNoteSlashCommandIconImage(_kTestPngDataUrl),
        ),
        BlockNoteSlashCommandItem.paragraph(
          title: 'Insert Note',
          content: 'This is a note block.',
          aliases: ['note', 'memo'],
          group: 'Custom',
          subtext: 'Inserts paragraph with SVG icon',
          icon: const BlockNoteSlashCommandIconSvg(_kTestSvgCircle),
        ),
        BlockNoteSlashCommandItem(
          title: 'Insert current date',
          onItemClickScriptPath: 'assets/slash_insert_date.js',
          aliases: ['date', 'today'],
          group: 'Click handlers',
          subtext: 'Handler from JS file (onItemClickScriptPath)',
          icon: '📅',
        ),
        BlockNoteSlashCommandItem(
          title: 'Insert clicked',
          onItemClick:
              "editor.insertBlocks([{type: 'paragraph', content: [{type: 'text', text: 'Clicked!'}]}], editor.getTextCursorPosition().block, 'after');",
          aliases: ['clicked', 'click'],
          group: 'Click handlers',
          subtext: 'Handler from inline JS (onItemClick)',
          icon: '⚡',
        ),
      ],
    );
  }

  /// Creates a custom slash command config that includes an item with icon
  /// loaded via [BlockNoteSlashCommandIconImage.fromAsset] (async).
  ///
  /// Uses [createCustomSlashCommands] items plus one item with icon from
  /// assets/slash_icon_test.png.
  static Future<BlockNoteSlashCommandConfig> createCustomSlashCommandsWithAssetIcon() async {
    final imageIcon = await BlockNoteSlashCommandIconImage.fromAsset(
      'assets/slash_icon_test.png',
    );
    final base = createCustomSlashCommands();
    final items = List<BlockNoteSlashCommandItem>.from(base.items!);
    items.add(
      BlockNoteSlashCommandItem(
        title: 'Insert Asset Image',
        onItemClick:
            "editor.insertBlocks([{type: 'image', props: {url: '$_kSampleImageUrl'}}], editor.getTextCursorPosition().block, 'after');",
        aliases: ['fromasset', 'asset'],
        group: 'Custom',
        subtext: 'Image icon loaded from app asset (PNG)',
        icon: imageIcon,
      ),
    );
    return BlockNoteSlashCommandConfig(
      items: items,
      enabled: base.enabled,
      triggerCharacter: base.triggerCharacter,
    );
  }

  /// Creates a slash command configuration with only specific available commands.
  ///
  /// This demonstrates the availableSlashCommands feature by showing only
  /// a subset of the default commands.
  static BlockNoteSlashCommandConfig createAvailableSlashCommands() {
    return BlockNoteSlashCommandConfig(
      availableSlashCommands: [
        BlockNoteDefaultSlashCommand.paragraph,
        BlockNoteDefaultSlashCommand.heading1,
        BlockNoteDefaultSlashCommand.heading2,
        BlockNoteDefaultSlashCommand.heading3,
        BlockNoteDefaultSlashCommand.bulletList,
        BlockNoteDefaultSlashCommand.numberedList,
      ],
    );
  }
}
