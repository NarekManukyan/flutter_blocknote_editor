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
          subtext: 'Icon: emoji string',
          icon: '📝',
        ),
        BlockNoteSlashCommandItem.paragraph(
          title: 'Insert Greeting',
          content: 'Hi there!',
          aliases: ['greeting', 'hi'],
          group: 'Custom',
          subtext: 'Icon: BlockNoteSlashCommandIconText',
          icon: const BlockNoteSlashCommandIconText('Hi'),
        ),
        BlockNoteSlashCommandItem.paragraph(
          title: 'Insert SVG block',
          content: 'SVG icon item',
          aliases: ['svg'],
          group: 'Custom',
          subtext: 'Icon: BlockNoteSlashCommandIconSvg (circle)',
          icon: const BlockNoteSlashCommandIconSvg(_kTestSvgCircle),
        ),
        BlockNoteSlashCommandItem.paragraph(
          title: 'Insert image-icon block',
          content: 'Image icon item',
          aliases: ['imgicon', 'imageicon'],
          group: 'Custom',
          subtext: 'Icon: BlockNoteSlashCommandIconImage (data URL)',
          icon: const BlockNoteSlashCommandIconImage(_kTestPngDataUrl),
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
      BlockNoteSlashCommandItem.paragraph(
        title: 'Insert fromAsset icon block',
        content: 'Loaded from app asset (PNG)',
        aliases: ['fromasset', 'asset'],
        group: 'Custom',
        subtext: 'Icon: BlockNoteSlashCommandIconImage.fromAsset()',
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
