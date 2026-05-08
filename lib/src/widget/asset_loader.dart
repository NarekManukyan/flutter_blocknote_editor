/// Asset loader for BlockNote web assets.
///
/// Copies BlockNote web assets from the Flutter package bundle into a
/// temporary directory so the WebView can load them directly via file:// URL,
/// eliminating the need for a local HTTP server.
library;

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Loads BlockNote web assets from the Flutter package bundle into a temporary
/// directory for direct file:// access by the WebView.
class BlockNoteAssetLoader {
  /// Creates a new asset loader.
  BlockNoteAssetLoader({this.debugLogging = false});

  /// Whether to enable debug logging.
  final bool debugLogging;

  Directory? _tempDir;

  /// Copies assets to a temporary directory and returns the file path to
  /// index.html.
  ///
  /// The returned path can be used directly as a file:// URL in the WebView.
  Future<String> load() async {
    if (_tempDir != null) {
      return '${_tempDir!.path}/index.html';
    }

    try {
      _tempDir = await _copyAssetsToTempDirectory();

      final indexPath = '${_tempDir!.path}/index.html';

      if (debugLogging) {
        debugPrint('[BlockNoteAssetLoader] Assets ready at: $indexPath');
      }

      return indexPath;
    } catch (e) {
      if (debugLogging) {
        debugPrint('[BlockNoteAssetLoader] Error loading assets: $e');
      }
      rethrow;
    }
  }

  /// Copies assets from the Flutter package bundle into a temporary directory.
  Future<Directory> _copyAssetsToTempDirectory() async {
    final tempDir = await Directory.systemTemp.createTemp('blocknote_assets');

    try {
      // Core required assets
      final requiredAssets = ['index.html', 'editor.js', 'editor.css'];

      // Font files are bundled with a `.bin` suffix in the package to avoid
      // Apple's ITMS-90853 validator rejecting `.woff`/`.woff2` files in the
      // iOS app bundle (CoreText only accepts .ttf/.otf, but the validator
      // scans every file regardless of usage). At runtime we load the `.bin`
      // asset and write it under the original `.woff`/`.woff2` name so the
      // CSS @font-face URLs in editor.css continue to resolve unchanged.
      final fontFiles = [
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
      ];

      // Optional non-font assets (chunks)
      final optionalAssets = [
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
            debugPrint(
              '[BlockNoteAssetLoader] Copied: $fileName (${data.lengthInBytes} bytes)',
            );
          }
        } catch (e) {
          if (debugLogging) {
            debugPrint('[BlockNoteAssetLoader] ERROR: Could not load $fileName: $e');
          }
          rethrow;
        }
      }

      // Copy optional assets in parallel; individual failures are silent so
      // one missing font/chunk does not abort the entire batch.
      final optionalResults = await Future.wait(
        optionalAssets.map((fileName) async {
          try {
            final assetPath =
                'packages/flutter_blocknote_editor/assets/web/$fileName';
            final data = await rootBundle.load(assetPath);
            final file = File('${tempDir.path}/$fileName');
            await file.writeAsBytes(data.buffer.asUint8List());
            return true;
          } catch (_) {
            // Optional — ignore missing assets
            return false;
          }
        }),
      );
      copiedCount += optionalResults.where((ok) => ok).length;

      // Load fonts from `.bin` bundle entries, write under original name.
      final fontResults = await Future.wait(
        fontFiles.map((fileName) async {
          try {
            final assetPath =
                'packages/flutter_blocknote_editor/assets/web/$fileName.bin';
            final data = await rootBundle.load(assetPath);
            final file = File('${tempDir.path}/$fileName');
            await file.writeAsBytes(data.buffer.asUint8List());
            return true;
          } catch (_) {
            return false;
          }
        }),
      );
      copiedCount += fontResults.where((ok) => ok).length;

      if (debugLogging) {
        debugPrint('[BlockNoteAssetLoader] Copied $copiedCount assets total');
      }

      // Verify required files were copied
      final indexFile = File('${tempDir.path}/index.html');
      final jsFile = File('${tempDir.path}/editor.js');

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

      if (debugLogging) {
        debugPrint('[BlockNoteAssetLoader] Temp directory: ${tempDir.path}');
        final files = await tempDir.list().toList();
        for (final file in files) {
          debugPrint('  - ${file.path.split('/').last}');
        }
      }

      return tempDir;
    } catch (e) {
      if (debugLogging) {
        debugPrint('[BlockNoteAssetLoader] Error creating temp directory: $e');
      }
      rethrow;
    }
  }

  /// Cleans up the temporary directory.
  Future<void> dispose() async {
    if (_tempDir != null) {
      try {
        await _tempDir!.delete(recursive: true);
      } catch (e) {
        if (debugLogging) {
          debugPrint('[BlockNoteAssetLoader] Error deleting temp dir: $e');
        }
      }
      _tempDir = null;
    }
  }

  /// Gets the path to the temporary assets directory, if loaded.
  String? get tempDirPath => _tempDir?.path;
}
