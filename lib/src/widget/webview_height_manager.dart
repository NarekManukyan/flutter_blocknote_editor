/// WebView height management utilities for BlockNote editor.
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../bridge/js_bridge.dart';

/// Manages WebView height updates and content size changes.
class WebViewHeightManager {
  /// Updates the WebView height in JavaScript to ensure proper scrolling.
  static void updateWebViewHeight({
    required JsBridge bridge,
    required InAppWebViewController controller,
    required double keyboardHeight,
    required double availableHeight,
    required bool debugLogging,
  }) {
    if (debugLogging) {
      debugPrint(
        '[BlockNoteEditor] _updateWebViewHeight called: '
        'keyboardHeight=$keyboardHeight, availableHeight=$availableHeight',
      );
    }

    // Convert to pixels (Flutter uses logical pixels, but we need physical pixels)
    final pixelRatio =
        WidgetsBinding.instance.platformDispatcher.views.first.devicePixelRatio;
    final heightInPixels = (availableHeight * pixelRatio).round();
    final keyboardHeightInPixels = (keyboardHeight * pixelRatio).round();

    if (debugLogging) {
      debugPrint(
        '[BlockNoteEditor] Updating WebView height: '
        'heightInPixels=$heightInPixels, keyboardHeightInPixels=$keyboardHeightInPixels, '
        'pixelRatio=$pixelRatio',
      );
    }

    // Update via bridge
    bridge.updateWebViewHeight(heightInPixels, keyboardHeightInPixels);
    
    // Also ensure WebView itself has proper size constraints
    // This helps with scrolling when there are many blocks
    Future.microtask(() async {
      try {
        await controller.evaluateJavascript(source: '''
          (function() {
            // Ensure document and body have proper height for scrolling
            const html = document.documentElement;
            const body = document.body;
            const root = document.getElementById('root');
            
            if (html && body && root) {
              // Force recalculation of layout
              html.style.height = '100%';
              body.style.height = '100%';
              
              // Ensure root can scroll
              if (root.style.overflow !== 'auto' && root.style.overflow !== 'scroll') {
                root.style.overflow = 'auto';
              }
              
              // Trigger a reflow to ensure scrolling works
              void root.offsetHeight;
            }
          })();
        ''');
      } catch (e) {
        if (debugLogging) {
          debugPrint('[BlockNoteEditor] Error ensuring scroll setup: $e');
        }
      }
    });
  }

  /// Handles content size changes with debouncing for scroll-to-selection.
  static void handleContentSizeChange({
    required InAppWebViewController controller,
    required Size oldContentSize,
    required Size newContentSize,
    required bool isReady,
    required bool debugLogging,
    required Function() onScrollToSelection,
    required Function(DateTime) updateLastSignificantChangeTime,
    required Function(Timer?) updateDebounceTimer,
    required DateTime? lastSignificantChangeTime,
    required Timer? contentSizeChangeDebounceTimer,
  }) {
    if (debugLogging) {
      debugPrint(
        '[BlockNoteEditor] Content size changed: '
        'old=${oldContentSize.width}x${oldContentSize.height}, '
        'new=${newContentSize.width}x${newContentSize.height}',
      );
    }
    
    // Debounce scroll-to-selection to avoid multiple rapid calls
    // Only trigger when content size has stabilized after a significant change
    if (!isReady) return;

    final heightDiff = (newContentSize.height - oldContentSize.height).abs();
    
    // Track significant changes (>20px) but don't reset timer on every small change
    if (heightDiff > 20) {
      updateLastSignificantChangeTime(DateTime.now());
      
      if (debugLogging) {
        debugPrint(
          '[BlockNoteEditor] Significant content size change detected '
          '(heightDiff=$heightDiff, newHeight=$currentHeight)',
        );
      }
      
      // Cancel previous timer and start new one
      contentSizeChangeDebounceTimer?.cancel();
      
      // Wait for content to stabilize (no significant changes for 300ms)
      final newTimer = Timer(const Duration(milliseconds: 300), () {
        // Check if there was a significant change and it's been stable
        final lastTime = lastSignificantChangeTime;
        if (lastTime != null &&
            DateTime.now().difference(lastTime).inMilliseconds >= 200) {
          onScrollToSelection();
        }
      });
      
      updateDebounceTimer(newTimer);
    } else if (heightDiff <= 2 && lastSignificantChangeTime != null) {
      // Small changes (<2px) after a significant change - don't reset timer
      // This allows the debounce to complete even with minor adjustments
      if (debugLogging) {
        debugPrint(
          '[BlockNoteEditor] Minor content size adjustment (${heightDiff}px), '
          'not resetting debounce timer',
        );
      }
    }
  }

  /// Triggers scroll-to-selection in the editor.
  static void triggerScrollToSelection({
    required InAppWebViewController controller,
    required bool debugLogging,
  }) {
    if (debugLogging) {
      debugPrint(
        '[BlockNoteEditor] Content size stabilized after significant change, '
        'triggering scroll-to-selection',
      );
    }
    
    controller.evaluateJavascript(source: '''
      (function() {
        try {
          if (window.editor && window.editor._tiptapEditor) {
            const proseMirrorView = window.editor._tiptapEditor.view;
            if (proseMirrorView) {
              // Trigger scroll
              proseMirrorView.dispatch(
                proseMirrorView.state.tr.scrollIntoView()
              );
            }
          }
        } catch (err) {
          // Silently fail
        }
      })();
    ''');
  }
}
