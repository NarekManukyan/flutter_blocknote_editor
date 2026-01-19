import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// SVG icon paths for toolbar icons.
class ToolbarIcons {
  /// Map of icon IDs to their asset paths.
  /// IDs match the 'id' field from toolbarOptions.js.
  static const Map<String, String> _iconMap = {
    'paragraph': 'packages/flutter_blocknote_editor/assets/icons/paragraph.svg',
    'heading_1': 'packages/flutter_blocknote_editor/assets/icons/heading1.svg',
    'heading_2': 'packages/flutter_blocknote_editor/assets/icons/heading2.svg',
    'heading_3': 'packages/flutter_blocknote_editor/assets/icons/heading3.svg',
    'toggle_heading_1':
        'packages/flutter_blocknote_editor/assets/icons/heading1.svg',
    'toggle_heading_2':
        'packages/flutter_blocknote_editor/assets/icons/heading2.svg',
    'toggle_heading_3':
        'packages/flutter_blocknote_editor/assets/icons/heading3.svg',
    'quote': 'packages/flutter_blocknote_editor/assets/icons/quote.svg',
    'toggle_list':
        'packages/flutter_blocknote_editor/assets/icons/toggle_list.svg',
    'bullet_list':
        'packages/flutter_blocknote_editor/assets/icons/bullet_list.svg',
    'numbered_list':
        'packages/flutter_blocknote_editor/assets/icons/numbered_list.svg',
    'check_list':
        'packages/flutter_blocknote_editor/assets/icons/check_list.svg',
  };

  /// Gets the asset path for an icon ID.
  /// IDs must match the 'id' field from toolbarOptions.js.
  static String? getIconAsset(String iconId) {
    return _iconMap[iconId.toLowerCase()];
  }

  /// Creates an SVG icon widget from an icon ID.
  /// IDs must match the 'id' field from toolbarOptions.js.
  static Widget? getSvgIcon(String? iconId, {Color? color, double size = 20}) {
    if (iconId == null) return null;

    final assetPath = getIconAsset(iconId);
    if (assetPath == null) return null;

    return SvgPicture.asset(
      assetPath,
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
    );
  }
}
