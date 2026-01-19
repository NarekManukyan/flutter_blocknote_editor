/// WebView initialization utilities for BlockNote editor.
library;

import 'package:flutter/foundation.dart';
import 'asset_server.dart';

/// WebView initialization result.
class WebViewInitializationResult {
  /// Creates a new initialization result.
  const WebViewInitializationResult({
    required this.url,
    required this.assetServer,
  });

  /// The URL to load in the WebView.
  final String url;

  /// The asset server instance (null if using external localhost).
  final AssetServer? assetServer;
}

/// Initializes the WebView and determines the URL to load.
class WebViewInitializer {
  /// Initializes the WebView and returns the URL to load.
  ///
  /// If [localhostUrl] is provided, uses that URL directly.
  /// Otherwise, starts a Flutter asset server to serve bundled assets.
  static Future<WebViewInitializationResult> initialize({
    required String? localhostUrl,
    required bool debugLogging,
  }) async {
    String url;
    AssetServer? assetServer;

    if (localhostUrl != null) {
      // External localhost URL (for development/preview)
      if (debugLogging) {
        debugPrint(
          '[BlockNoteEditor] Loading from external localhost: $localhostUrl',
        );
      }
      url = localhostUrl;
    } else {
      // Start Flutter asset server to serve built files
      if (debugLogging) {
        debugPrint('[BlockNoteEditor] Starting Flutter asset server...');
      }
      assetServer = AssetServer(debugLogging: debugLogging);
      url = await assetServer.start();
      if (debugLogging) {
        debugPrint('[BlockNoteEditor] Asset server started: $url');
      }
    }

    return WebViewInitializationResult(url: url, assetServer: assetServer);
  }
}
