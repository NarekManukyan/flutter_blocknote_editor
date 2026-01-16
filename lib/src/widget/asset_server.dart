/// HTTP server for serving BlockNote web assets from Flutter.
///
/// This server runs inside the Flutter app and serves the built React app
/// from assets/web/ directory on localhost, allowing the WebView to load it.
library;

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

/// HTTP server that serves BlockNote web assets from Flutter package.
class AssetServer {
  /// Creates a new asset server.
  AssetServer({this.port = 0, this.debugLogging = false});

  /// Port to bind to (0 = auto-assign).
  final int port;

  /// Whether to enable debug logging.
  final bool debugLogging;

  HttpServer? _server;
  int? _actualPort;
  Directory? _tempDir;

  /// Starts the server and returns the URL.
  Future<String> start() async {
    if (_server != null) {
      return 'http://localhost:$_actualPort';
    }

    try {
      // Create a temporary directory and copy assets
      _tempDir = await _createTempAssetDirectory();

      // Create static file handler with proper MIME types
      // Use absolute path to ensure files are found
      final absolutePath = _tempDir!.absolute.path;
      
      if (debugLogging) {
        debugPrint('[AssetServer] Serving from: $absolutePath');
      }
      
      var handler = createStaticHandler(
        absolutePath,
        defaultDocument: 'index.html',
        serveFilesOutsidePath: false,
      );

      // Add request logging middleware
      if (debugLogging) {
        final originalHandler = handler;
        handler = (Request request) async {
          debugPrint('[AssetServer] Request: ${request.method} ${request.url}');
          final response = await originalHandler(request);
          debugPrint(
            '[AssetServer] Response: ${response.statusCode} for ${request.url}',
          );
          return response;
        };
      }

      // Start server on localhost
      _server = await shelf_io.serve(
        handler,
        InternetAddress.loopbackIPv4,
        port,
      );

      _actualPort = _server!.port;

      if (debugLogging) {
        debugPrint(
          '[AssetServer] Started on http://localhost:$_actualPort',
        );
      }

      return 'http://localhost:$_actualPort';
    } catch (e) {
      if (debugLogging) {
        debugPrint('[AssetServer] Error starting server: $e');
      }
      rethrow;
    }
  }

  /// Creates a temporary directory with assets copied from package.
  Future<Directory> _createTempAssetDirectory() async {
    final tempDir = await Directory.systemTemp.createTemp('blocknote_assets');

    try {
      // Core required assets
      final requiredAssets = ['index.html', 'editor.js', 'editor.css'];
      
      // Optional assets (fonts, chunks)
      final optionalAssets = [
        // Font files
        'inter-v12-latin-100.woff',
        'inter-v12-latin-100.woff2',
        'inter-v12-latin-200.woff',
        'inter-v12-latin-200.woff2',
        'inter-v12-latin-300.woff',
        'inter-v12-latin-300.woff2',
        'inter-v12-latin-500.woff',
        'inter-v12-latin-500.woff2',
        'inter-v12-latin-600.woff',
        'inter-v12-latin-600.woff2',
        'inter-v12-latin-700.woff',
        'inter-v12-latin-700.woff2',
        'inter-v12-latin-800.woff',
        'inter-v12-latin-800.woff2',
        'inter-v12-latin-900.woff',
        'inter-v12-latin-900.woff2',
        'inter-v12-latin-regular.woff',
        'inter-v12-latin-regular.woff2',
        // Chunk files (if any)
        'chunk-index.js',
        'chunk-list-item.js',
        'chunk-module.js',
        'chunk-native.js',
      ];

      // Try numbered chunk files
      for (int i = 2; i <= 25; i++) {
        optionalAssets.add('chunk-index$i.js');
      }

      int copiedCount = 0;
      final failedAssets = <String>[];

      // Copy required assets first
      for (final fileName in requiredAssets) {
        try {
          final assetPath =
              'packages/flutter_blocknote_editor/assets/web/$fileName';
          final data = await rootBundle.load(assetPath);
          final file = File('${tempDir.path}/$fileName');
          await file.writeAsBytes(data.buffer.asUint8List());
          copiedCount++;

          if (debugLogging) {
            debugPrint('[AssetServer] Copied: $fileName (${data.lengthInBytes} bytes)');
          }
        } catch (e) {
          failedAssets.add(fileName);
          if (debugLogging) {
            debugPrint('[AssetServer] ERROR: Could not load $fileName: $e');
          }
        }
      }

      // Copy optional assets
      for (final fileName in optionalAssets) {
        try {
          final assetPath =
              'packages/flutter_blocknote_editor/assets/web/$fileName';
          final data = await rootBundle.load(assetPath);
          final file = File('${tempDir.path}/$fileName');
          await file.writeAsBytes(data.buffer.asUint8List());
          copiedCount++;
        } catch (e) {
          // Optional assets can fail silently
        }
      }

      if (debugLogging) {
        debugPrint('[AssetServer] Copied $copiedCount assets total');
      }

      // Verify required files were copied
      final indexFile = File('${tempDir.path}/index.html');
      final jsFile = File('${tempDir.path}/editor.js');
      final cssFile = File('${tempDir.path}/editor.css');

      if (!await indexFile.exists()) {
        throw Exception(
          'Failed to copy index.html. Make sure web_editor is built: cd web_editor && npm run build',
        );
      }
      if (!await jsFile.exists()) {
        throw Exception(
          'Failed to copy editor.js. Make sure web_editor is built: cd web_editor && npm run build',
        );
      }
      if (!await cssFile.exists()) {
        if (debugLogging) {
          debugPrint('[AssetServer] Warning: editor.css not found (optional)');
        }
      }

      if (debugLogging) {
        debugPrint('[AssetServer] Temp directory: ${tempDir.path}');
        debugPrint('[AssetServer] Files in temp dir:');
        final files = await tempDir.list().toList();
        for (final file in files) {
          debugPrint('  - ${file.path.split('/').last}');
        }
      }

      return tempDir;
    } catch (e) {
      if (debugLogging) {
        debugPrint('[AssetServer] Error creating temp directory: $e');
      }
      rethrow;
    }
  }

  /// Stops the server and cleans up.
  Future<void> stop() async {
    if (_server != null) {
      await _server!.close(force: true);
      _server = null;
      _actualPort = null;
      if (debugLogging) {
        debugPrint('[AssetServer] Stopped');
      }
    }

    // Clean up temp directory
    if (_tempDir != null) {
      try {
        await _tempDir!.delete(recursive: true);
      } catch (e) {
        if (debugLogging) {
          debugPrint('[AssetServer] Error deleting temp dir: $e');
        }
      }
      _tempDir = null;
    }
  }

  /// Gets the current server URL.
  String? get url =>
      _actualPort != null ? 'http://localhost:$_actualPort' : null;
}
