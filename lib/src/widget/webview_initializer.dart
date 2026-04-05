/// WebView initialization utilities for BlockNote editor.
library;

import 'package:flutter/foundation.dart';
import 'asset_loader.dart';

/// WebView initialization result.
class WebViewInitializationResult {
  /// Creates a new initialization result.
  const WebViewInitializationResult({
    required this.url,
    this.assetLoader,
  });

  /// The URL to load in the WebView.
  ///
  /// This is either a file:// URL pointing to the local assets directory,
  /// or an external HTTP URL when [localhostUrl] is provided.
  final String url;

  /// The asset loader instance (null if using external localhost).
  ///
  /// Must be disposed when the editor is disposed.
  final BlockNoteAssetLoader? assetLoader;
}

/// Initializes the WebView and determines the URL to load.
class WebViewInitializer {
  /// Initializes the WebView and returns the URL to load.
  ///
  /// If [localhostUrl] is provided, uses that URL directly (for development).
  /// Otherwise, copies bundled assets to a temp directory and returns a
  /// file:// URL for direct WebView loading — no HTTP server needed.
  static Future<WebViewInitializationResult> initialize({
    required String? localhostUrl,
    required bool debugLogging,
  }) async {
    String url;
    BlockNoteAssetLoader? assetLoader;

    if (localhostUrl != null) {
      // External localhost URL (for development/preview)
      if (debugLogging) {
        debugPrint(
          '[BlockNoteEditor] Loading from external localhost: $localhostUrl',
        );
      }
      url = localhostUrl;
    } else {
      // Copy assets to temp directory and load directly via file://
      if (debugLogging) {
        debugPrint('[BlockNoteEditor] Loading assets directly via file://...');
      }
      assetLoader = BlockNoteAssetLoader(debugLogging: debugLogging);
      final indexPath = await assetLoader.load();
      url = Uri.file(indexPath).toString();
      if (debugLogging) {
        debugPrint('[BlockNoteEditor] Assets ready: $url');
      }
    }

    return WebViewInitializationResult(url: url, assetLoader: assetLoader);
  }
}
