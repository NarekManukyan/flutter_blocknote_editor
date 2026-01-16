/// Document loading utilities for BlockNote editor.
library;

import 'package:flutter/material.dart';
import '../bridge/js_bridge.dart';
import 'blocknote_editor.dart';
import 'css_utils.dart';

/// Loads the initial document and configuration into the editor.
class DocumentLoader {
  /// Loads the initial document and applies all configurations.
  ///
  /// This is called once after the editor sends the "ready" message.
  /// It loads the document, sets read-only state, theme, toolbar config,
  /// slash command config, and injects custom CSS.
  static Future<void> loadInitialDocument({
    required BlockNoteEditor widget,
    required JsBridge bridge,
    required BuildContext context,
    required bool debugLogging,
  }) async {
    try {
      final documentJson = widget.initialDocument.toJson();
      await bridge.loadDocument(documentJson);

      // Set read-only state
      if (widget.readOnly) {
        await bridge.setReadonly(true);
      }

      // Set theme if provided
      if (widget.theme != null) {
        await bridge.setTheme(widget.theme!.toJson());
      }

      // Set toolbar config if provided
      if (widget.toolbarConfig != null) {
        await bridge.setToolbarConfig(widget.toolbarConfig!.toJson());
      }

      // Set slash command config if provided
      if (widget.slashCommandConfig != null) {
        await bridge.setSlashCommandConfig(
          widget.slashCommandConfig!.toJson(),
        );
      }

      // Inject custom CSS if provided (from customCss parameter or theme font config)
      final cssToInject = CssUtils.getEffectiveCss(widget);
      if (cssToInject != null && cssToInject.isNotEmpty) {
        await bridge.injectCustomCss(cssToInject);
      }

      // WebView height will be updated by the height manager
      // after the document loads
    } catch (e) {
      if (debugLogging) {
        debugPrint('[BlockNoteEditor] Error loading document: $e');
      }
      throw Exception('Failed to load document: $e');
    }
  }
}
