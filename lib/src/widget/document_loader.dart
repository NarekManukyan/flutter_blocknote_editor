/// Document loading utilities for BlockNote editor.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../bridge/js_bridge.dart';
import 'blocknote_editor.dart';
import 'css_utils.dart';

/// Options for loading initial document configuration.
class DocumentLoadOptions {
  /// Creates a new document load options instance.
  const DocumentLoadOptions({
    this.applySchemaConfig = true,
    this.applyCustomJavaScript = true,
    this.applyCustomJavaScriptAssets = true,
    this.applyCustomCss = true,
    this.applyCustomCssAssets = true,
  });

  /// Whether to apply schema config before loading the document.
  final bool applySchemaConfig;

  /// Whether to apply custom JavaScript before loading the document.
  final bool applyCustomJavaScript;

  /// Whether to apply custom JavaScript assets before loading the document.
  final bool applyCustomJavaScriptAssets;

  /// Whether to apply custom CSS after loading the document.
  final bool applyCustomCss;

  /// Whether to apply custom CSS assets after loading the document.
  final bool applyCustomCssAssets;
}

/// Request data for loading initial document configuration.
class DocumentLoadRequest {
  /// Creates a new document load request.
  const DocumentLoadRequest({
    required this.widget,
    required this.bridge,
    required this.context,
    required this.debugLogging,
    this.options = const DocumentLoadOptions(),
  });

  /// Editor widget configuration.
  final BlockNoteEditor widget;

  /// JavaScript bridge for message passing.
  final JsBridge bridge;

  /// Build context for the editor.
  final BuildContext context;

  /// Whether debug logging is enabled.
  final bool debugLogging;

  /// Optional load options for configuration.
  final DocumentLoadOptions options;
}

/// Loads the initial document and configuration into the editor.
class DocumentLoader {
  /// Loads the initial document and applies all configurations.
  ///
  /// This is called once after the editor sends the "ready" message.
  /// It loads the document, sets read-only state, theme, toolbar config,
  /// slash command config, and injects custom CSS.
  static Future<void> loadInitialDocument(DocumentLoadRequest request) async {
    final debugLogging = request.debugLogging;
    try {
      await _applyPreDocumentConfig(request);
      final documentJson = request.widget.initialDocument.toJson();
      await request.bridge.loadDocument(documentJson);
      await _applyPostDocumentConfig(request);

      // WebView height will be updated by the height manager
      // after the document loads
    } catch (e) {
      if (debugLogging) {
        debugPrint('[BlockNoteEditor] Error loading document: $e');
      }
      throw Exception('Failed to load document: $e');
    }
  }

  static Future<void> _applyPreDocumentConfig(
    DocumentLoadRequest request,
  ) async {
    final widget = request.widget;
    final bridge = request.bridge;
    final options = request.options;

    if (options.applyCustomJavaScript) {
      await _applyCustomJavaScript(widget: widget, bridge: bridge);
    }
    if (options.applyCustomJavaScriptAssets) {
      await _applyAssetsSequential(
        assetPaths: widget.customJavaScriptAssetPaths,
        apply: bridge.evaluateJavaScript,
      );
    }
    if (options.applySchemaConfig) {
      await _applySchemaConfig(widget: widget, bridge: bridge);
    }
  }

  static Future<void> _applyPostDocumentConfig(
    DocumentLoadRequest request,
  ) async {
    final widget = request.widget;
    final bridge = request.bridge;
    final options = request.options;

    await _applyReadonly(widget: widget, bridge: bridge);
    await _applyIfPresent(
      value: widget.theme,
      apply: (theme) => bridge.setTheme(theme.toJson()),
    );
    await _applyIfPresent(
      value: widget.toolbarConfig,
      apply: (config) => bridge.setToolbarConfig(config.toJson()),
    );
    await _applyIfPresent(
      value: widget.slashCommandConfig,
      apply: (config) => bridge.setSlashCommandConfig(config.toJson()),
    );
    if (options.applyCustomCss) {
      await _applyCustomCss(widget: widget, bridge: bridge);
    }
    if (options.applyCustomCssAssets) {
      await _applyAssetsCombined(
        assetPaths: widget.customCssAssetPaths,
        apply: bridge.injectCustomCss,
      );
    }
  }

  static Future<void> _applyCustomJavaScript({
    required BlockNoteEditor widget,
    required JsBridge bridge,
  }) async {
    final script = widget.customJavaScript;
    if (script == null || script.isEmpty) {
      return;
    }
    await bridge.evaluateJavaScript(script);
  }

  static Future<void> _applySchemaConfig({
    required BlockNoteEditor widget,
    required JsBridge bridge,
  }) async {
    final schemaConfig = _resolveSchemaConfig(widget);
    if (schemaConfig == null) {
      return;
    }
    await bridge.setSchemaConfig(schemaConfig);
  }

  static Future<void> _applyReadonly({
    required BlockNoteEditor widget,
    required JsBridge bridge,
  }) async {
    if (!widget.readOnly) {
      return;
    }
    await bridge.setReadonly(true);
  }

  static Future<void> _applyCustomCss({
    required BlockNoteEditor widget,
    required JsBridge bridge,
  }) async {
    final cssToInject = CssUtils.getEffectiveCss(widget);
    if (cssToInject == null || cssToInject.isEmpty) {
      return;
    }
    await bridge.injectCustomCss(cssToInject);
  }

  static Future<void> _applyIfPresent<T>({
    required T? value,
    required Future<void> Function(T value) apply,
  }) async {
    if (value == null) {
      return;
    }
    await apply(value);
  }

  static Map<String, dynamic>? _resolveSchemaConfig(BlockNoteEditor widget) {
    final configs = widget.schemaConfigs;
    if (configs != null && configs.isNotEmpty) {
      final activeId = widget.activeSchemaId;
      if (activeId != null && configs.containsKey(activeId)) {
        return configs[activeId];
      }
      return configs.values.first;
    }
    return widget.schemaConfig;
  }

  static Future<void> _applyAssetsSequential({
    required List<String>? assetPaths,
    required Future<void> Function(String content) apply,
  }) async {
    final assets = await loadAssets(assetPaths);
    for (final content in assets) {
      if (content.isEmpty) {
        continue;
      }
      await apply(content);
    }
  }

  static Future<void> _applyAssetsCombined({
    required List<String>? assetPaths,
    required Future<void> Function(String content) apply,
  }) async {
    final assets = await loadAssets(assetPaths);
    if (assets.isEmpty) {
      return;
    }
    final combined = assets.where((content) => content.isNotEmpty).join('\n');
    if (combined.isEmpty) {
      return;
    }
    await apply(combined);
  }

  static Future<List<String>> loadAssets(List<String>? assetPaths) async {
    if (assetPaths == null || assetPaths.isEmpty) {
      return <String>[];
    }
    final results = <String>[];
    for (final assetPath in assetPaths) {
      final content = await rootBundle.loadString(assetPath);
      results.add(content);
    }
    return results;
  }
}
