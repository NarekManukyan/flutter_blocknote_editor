/// Toolbar popup handling utilities for BlockNote editor.
library;

import 'package:flutter/material.dart';
import '../bridge/js_bridge.dart';
import '../bridge/message_types.dart';
import '../model/blocknote_theme.dart';
import 'blocknote_editor.dart';
import 'toolbar_popup_bottom_sheet.dart';

/// Handles toolbar popup requests from JavaScript.
class ToolbarPopupHandler {
  /// Handles a toolbar popup request.
  ///
  /// If a custom handler is provided via [widget.onToolbarPopupRequest],
  /// it uses that. Otherwise, shows a default modal bottom sheet.
  static void handleToolbarPopupRequest({
    required ToolbarPopupRequestMessage message,
    required BlockNoteEditor widget,
    required BuildContext context,
    required JsBridge? bridge,
    required bool mounted,
    required bool debugLogging,
  }) {
    if (debugLogging) {
      debugPrint(
        '[BlockNoteEditor] Toolbar popup request: '
        'popupType=${message.popupType}, optionsCount=${message.options.length}, '
        'hasHandler=${widget.onToolbarPopupRequest != null}',
      );
    }

    // If custom handler provided, use it
    if (widget.onToolbarPopupRequest != null) {
      if (debugLogging) {
        debugPrint('[BlockNoteEditor] Calling custom onToolbarPopupRequest handler');
      }
      widget.onToolbarPopupRequest!(
        message.popupType,
        message.options,
      ).then((selectedValue) {
        if (debugLogging) {
          debugPrint(
            '[BlockNoteEditor] Handler returned: selectedValue=$selectedValue',
          );
        }
        if (mounted && bridge != null) {
          bridge.sendToolbarPopupResponse(
            requestId: message.requestId,
            popupType: message.popupType,
            selectedValue: selectedValue,
          );
          if (debugLogging) {
            debugPrint('[BlockNoteEditor] Response sent to JS');
          }
        }
      }).catchError((error) {
        if (debugLogging) {
          debugPrint(
            '[BlockNoteEditor] Error in toolbar popup handler: $error',
          );
        }
        // Send null response on error (cancelled)
        if (mounted && bridge != null) {
          bridge.sendToolbarPopupResponse(
            requestId: message.requestId,
            popupType: message.popupType,
            selectedValue: null,
          );
        }
      });
      return;
    }

    // No custom handler - show default modal with theme customization
    if (!mounted || !context.mounted) {
      bridge?.sendToolbarPopupResponse(
        requestId: message.requestId,
        popupType: message.popupType,
        selectedValue: null,
      );
      return;
    }

    if (debugLogging) {
      debugPrint('[BlockNoteEditor] Showing default toolbar popup modal');
    }

    // Get theme colors for modal styling
    final theme = widget.theme;
    // Use menu colors, fallback to editor colors, then default
    final menuColors = theme?.colors?.menu ??
        theme?.light?.menu ??
        theme?.dark?.menu ??
        theme?.colors?.editor ??
        theme?.light?.editor ??
        theme?.dark?.editor ??
        const BlockNoteColorPair(
          text: Color(0xFF000000),
          background: Color(0xFFFFFFFF),
        );
    final hoveredColors = theme?.colors?.hovered ??
        theme?.light?.hovered ??
        theme?.dark?.hovered;
    final selectedColors = theme?.colors?.selected ??
        theme?.light?.selected ??
        theme?.dark?.selected;
    final borderRadius = theme?.borderRadius ?? 8.0;

    // Show default modal bottom sheet
    showModalBottomSheet<dynamic>(
      context: context,
      backgroundColor: menuColors.background,
      isScrollControlled: true,
      useSafeArea: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
      ),
      builder: (BuildContext sheetContext) {
        // Get highlight colors from theme
        final highlights = theme?.colors?.highlights ??
            theme?.light?.highlights ??
            theme?.dark?.highlights;

        return ToolbarPopupBottomSheet(
          popupType: message.popupType,
          options: message.options,
          menuColors: menuColors,
          hoveredColors: hoveredColors,
          selectedColors: selectedColors,
          highlights: highlights,
          onSelected: (selectedValue) {
            Navigator.of(sheetContext).pop(selectedValue);
          },
          onCancelled: () {
            Navigator.of(sheetContext).pop(null);
          },
        );
      },
    ).then((selectedValue) {
      if (mounted && bridge != null) {
        bridge.sendToolbarPopupResponse(
          requestId: message.requestId,
          popupType: message.popupType,
          selectedValue: selectedValue,
        );
        if (debugLogging) {
          debugPrint(
            '[BlockNoteEditor] Default modal returned: selectedValue=$selectedValue',
          );
        }
      }
    }).catchError((error) {
      if (debugLogging) {
        debugPrint(
          '[BlockNoteEditor] Error showing default modal: $error',
        );
      }
      // Send null response on error (cancelled)
      if (mounted && bridge != null) {
        bridge.sendToolbarPopupResponse(
          requestId: message.requestId,
          popupType: message.popupType,
          selectedValue: null,
        );
      }
    });
  }
}
