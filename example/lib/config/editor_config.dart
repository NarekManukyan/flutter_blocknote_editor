import 'package:flutter/material.dart';
import 'package:flutter_blocknote_editor/flutter_blocknote_editor.dart';

/// Editor configuration utilities for example app.
class EditorConfig {
  /// Creates a custom theme with red color scheme.
  static BlockNoteTheme createCustomTheme({required bool useCustomFont}) {
    return BlockNoteTheme(
      light: BlockNoteColorScheme(
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

  /// Creates a custom slash command configuration.
  static BlockNoteSlashCommandConfig createCustomSlashCommands() {
    return BlockNoteSlashCommandConfig(
      items: [
        BlockNoteSlashCommandItem.paragraph(
          title: 'Insert Hello World',
          content: 'Hello World',
          aliases: ['helloworld', 'hw'],
          group: 'Custom',
          subtext: 'Inserts a "Hello World" paragraph',
        ),
      ],
    );
  }
}
