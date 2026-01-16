/// Toolbar popup bottom sheet widget for BlockNote editor.
library;

import 'package:flutter/material.dart';
import '../model/blocknote_theme.dart';
import 'toolbar_icons.dart';

/// Default toolbar popup bottom sheet widget.
///
/// Shows a customizable modal bottom sheet for toolbar popup selections.
/// Uses theme colors for styling.
class ToolbarPopupBottomSheet extends StatelessWidget {
  /// Creates a new toolbar popup bottom sheet.
  const ToolbarPopupBottomSheet({
    required this.popupType,
    required this.options,
    required this.menuColors,
    this.hoveredColors,
    this.selectedColors,
    this.highlights,
    required this.onSelected,
    required this.onCancelled,
    super.key,
  });

  /// The type of popup (e.g., 'colorStyle', 'blockTypeSelect').
  final String popupType;

  /// Available options for the popup.
  final List<Map<String, dynamic>> options;

  /// Menu colors from theme.
  final BlockNoteColorPair menuColors;

  /// Hovered colors from theme (optional).
  final BlockNoteColorPair? hoveredColors;

  /// Selected colors from theme (optional).
  final BlockNoteColorPair? selectedColors;

  /// Highlight colors from theme (optional).
  /// Used for color style text colors.
  final BlockNoteHighlightColors? highlights;

  /// Callback when an option is selected.
  final ValueChanged<dynamic> onSelected;

  /// Callback when cancelled.
  final VoidCallback onCancelled;

  /// Creates a color style icon widget (square with "A" inside).
  Widget _buildColorStyleIcon(Color color) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          'A',
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// Gets the color for a color style value.
  /// Uses theme highlight colors if available, otherwise falls back to BlockNote defaults.
  Color _getColorFromValue(dynamic value) {
    if (value is! String) return menuColors.text;

    // Try to get color from theme highlights first
    final highlightColor = _getColorFromHighlights(value);
    if (highlightColor != null) {
      return highlightColor;
    }

    // Fall back to BlockNote's default text color values
    switch (value.toLowerCase()) {
      case 'default':
        return menuColors.text;
      case 'gray':
        return const Color(0xFF9B9A97);
      case 'brown':
        return const Color(0xFF64473A);
      case 'red':
        return const Color(0xFFE03E3E);
      case 'orange':
        return const Color(0xFFD9730D);
      case 'yellow':
        return const Color(0xFFDFAB01);
      case 'green':
        return const Color(0xFF4D6461);
      case 'blue':
        return const Color(0xFF0B6E99);
      case 'purple':
        return const Color(0xFF6940A5);
      case 'pink':
        return const Color(0xFFAD1A72);
      default:
        return menuColors.text;
    }
  }

  /// Gets color from theme highlights if available.
  Color? _getColorFromHighlights(String value) {
    if (highlights == null) return null;

    switch (value.toLowerCase()) {
      case 'gray':
        return highlights!.gray?.text;
      case 'brown':
        return highlights!.brown?.text;
      case 'red':
        return highlights!.red?.text;
      case 'orange':
        return highlights!.orange?.text;
      case 'yellow':
        return highlights!.yellow?.text;
      case 'green':
        return highlights!.green?.text;
      case 'blue':
        return highlights!.blue?.text;
      case 'purple':
        return highlights!.purple?.text;
      case 'pink':
        return highlights!.pink?.text;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle bar
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: menuColors.text.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        // Options list
        ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: options.length,
          itemBuilder: (context, index) {
              final option = options[index];
              final label = option['label'] as String? ?? '';
              final value = option['value'];
              final iconId = option['id'] as String?;

              Widget? leadingIcon;

              // For color styles, always show the colored square icon
              if (popupType == 'colorStyle') {
                final color = _getColorFromValue(value);
                leadingIcon = _buildColorStyleIcon(color);
              } else if (iconId != null) {
                // For block types, try to get SVG icon by ID
                final svgIcon = ToolbarIcons.getSvgIcon(
                  iconId,
                  color: menuColors.text,
                  size: 20,
                );
                if (svgIcon != null) {
                  leadingIcon = svgIcon;
                }
              }

              return ListTile(
                leading: leadingIcon,
                title: Text(label, style: TextStyle(color: menuColors.text)),
                onTap: () => onSelected(value),
                hoverColor: hoveredColors?.background,
                selectedTileColor: selectedColors?.background,
              );
            },
          ),
      ],
    );
  }
}
