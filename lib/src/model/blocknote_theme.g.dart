// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blocknote_theme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BlockNoteColorPair _$BlockNoteColorPairFromJson(Map json) =>
    _BlockNoteColorPair(
      text: _colorFromJson(json['text'] as String),
      background: _colorFromJson(json['background'] as String),
    );

Map<String, dynamic> _$BlockNoteColorPairToJson(_BlockNoteColorPair instance) =>
    <String, dynamic>{
      'text': _colorToJson(instance.text),
      'background': _colorToJson(instance.background),
    };

_BlockNoteHighlightColors _$BlockNoteHighlightColorsFromJson(Map json) =>
    _BlockNoteHighlightColors(
      gray: json['gray'] == null
          ? null
          : BlockNoteColorPair.fromJson(
              Map<String, dynamic>.from(json['gray'] as Map),
            ),
      brown: json['brown'] == null
          ? null
          : BlockNoteColorPair.fromJson(
              Map<String, dynamic>.from(json['brown'] as Map),
            ),
      red: json['red'] == null
          ? null
          : BlockNoteColorPair.fromJson(
              Map<String, dynamic>.from(json['red'] as Map),
            ),
      orange: json['orange'] == null
          ? null
          : BlockNoteColorPair.fromJson(
              Map<String, dynamic>.from(json['orange'] as Map),
            ),
      yellow: json['yellow'] == null
          ? null
          : BlockNoteColorPair.fromJson(
              Map<String, dynamic>.from(json['yellow'] as Map),
            ),
      green: json['green'] == null
          ? null
          : BlockNoteColorPair.fromJson(
              Map<String, dynamic>.from(json['green'] as Map),
            ),
      blue: json['blue'] == null
          ? null
          : BlockNoteColorPair.fromJson(
              Map<String, dynamic>.from(json['blue'] as Map),
            ),
      purple: json['purple'] == null
          ? null
          : BlockNoteColorPair.fromJson(
              Map<String, dynamic>.from(json['purple'] as Map),
            ),
      pink: json['pink'] == null
          ? null
          : BlockNoteColorPair.fromJson(
              Map<String, dynamic>.from(json['pink'] as Map),
            ),
    );

Map<String, dynamic> _$BlockNoteHighlightColorsToJson(
  _BlockNoteHighlightColors instance,
) => <String, dynamic>{
  'gray': ?instance.gray?.toJson(),
  'brown': ?instance.brown?.toJson(),
  'red': ?instance.red?.toJson(),
  'orange': ?instance.orange?.toJson(),
  'yellow': ?instance.yellow?.toJson(),
  'green': ?instance.green?.toJson(),
  'blue': ?instance.blue?.toJson(),
  'purple': ?instance.purple?.toJson(),
  'pink': ?instance.pink?.toJson(),
};

_BlockNoteColorScheme _$BlockNoteColorSchemeFromJson(Map json) =>
    _BlockNoteColorScheme(
      editor: json['editor'] == null
          ? null
          : BlockNoteColorPair.fromJson(
              Map<String, dynamic>.from(json['editor'] as Map),
            ),
      menu: json['menu'] == null
          ? null
          : BlockNoteColorPair.fromJson(
              Map<String, dynamic>.from(json['menu'] as Map),
            ),
      tooltip: json['tooltip'] == null
          ? null
          : BlockNoteColorPair.fromJson(
              Map<String, dynamic>.from(json['tooltip'] as Map),
            ),
      hovered: json['hovered'] == null
          ? null
          : BlockNoteColorPair.fromJson(
              Map<String, dynamic>.from(json['hovered'] as Map),
            ),
      selected: json['selected'] == null
          ? null
          : BlockNoteColorPair.fromJson(
              Map<String, dynamic>.from(json['selected'] as Map),
            ),
      disabled: json['disabled'] == null
          ? null
          : BlockNoteColorPair.fromJson(
              Map<String, dynamic>.from(json['disabled'] as Map),
            ),
      shadow: _colorFromJsonNullable(json['shadow'] as String?),
      border: _colorFromJsonNullable(json['border'] as String?),
      sideMenu: _colorFromJsonNullable(json['sideMenu'] as String?),
      highlights: json['highlights'] == null
          ? null
          : BlockNoteHighlightColors.fromJson(
              Map<String, dynamic>.from(json['highlights'] as Map),
            ),
    );

Map<String, dynamic> _$BlockNoteColorSchemeToJson(
  _BlockNoteColorScheme instance,
) => <String, dynamic>{
  'editor': ?instance.editor?.toJson(),
  'menu': ?instance.menu?.toJson(),
  'tooltip': ?instance.tooltip?.toJson(),
  'hovered': ?instance.hovered?.toJson(),
  'selected': ?instance.selected?.toJson(),
  'disabled': ?instance.disabled?.toJson(),
  'shadow': ?_colorToJsonNullable(instance.shadow),
  'border': ?_colorToJsonNullable(instance.border),
  'sideMenu': ?_colorToJsonNullable(instance.sideMenu),
  'highlights': ?instance.highlights?.toJson(),
};

_BlockNoteFontFile _$BlockNoteFontFileFromJson(Map json) => _BlockNoteFontFile(
  path: json['path'] as String,
  format: $enumDecode(_$BlockNoteFontFormatEnumMap, json['format']),
  weight: _fontWeightFromJson((json['weight'] as num).toInt()),
  style: _fontStyleFromJson(json['style'] as String),
);

Map<String, dynamic> _$BlockNoteFontFileToJson(_BlockNoteFontFile instance) =>
    <String, dynamic>{
      'path': instance.path,
      'format': _$BlockNoteFontFormatEnumMap[instance.format]!,
      'weight': ?_fontWeightToJson(instance.weight),
      'style': _fontStyleToJson(instance.style),
    };

const _$BlockNoteFontFormatEnumMap = {
  BlockNoteFontFormat.woff2: 'woff2',
  BlockNoteFontFormat.woff: 'woff',
  BlockNoteFontFormat.ttf: 'ttf',
  BlockNoteFontFormat.otf: 'otf',
};

_BlockNoteFontConfig _$BlockNoteFontConfigFromJson(Map json) =>
    _BlockNoteFontConfig(
      family: json['family'] as String,
      files:
          (json['files'] as List<dynamic>?)
              ?.map(
                (e) => BlockNoteFontFile.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BlockNoteFontConfigToJson(
  _BlockNoteFontConfig instance,
) => <String, dynamic>{
  'family': instance.family,
  'files': instance.files.map((e) => e.toJson()).toList(),
};

_BlockNoteTheme _$BlockNoteThemeFromJson(Map json) => _BlockNoteTheme(
  colors: json['colors'] == null
      ? null
      : BlockNoteColorScheme.fromJson(
          Map<String, dynamic>.from(json['colors'] as Map),
        ),
  borderRadius: (json['borderRadius'] as num?)?.toDouble(),
  font: json['font'] == null
      ? null
      : BlockNoteFontConfig.fromJson(
          Map<String, dynamic>.from(json['font'] as Map),
        ),
  light: json['light'] == null
      ? null
      : BlockNoteColorScheme.fromJson(
          Map<String, dynamic>.from(json['light'] as Map),
        ),
  dark: json['dark'] == null
      ? null
      : BlockNoteColorScheme.fromJson(
          Map<String, dynamic>.from(json['dark'] as Map),
        ),
);

Map<String, dynamic> _$BlockNoteThemeToJson(_BlockNoteTheme instance) =>
    <String, dynamic>{
      'colors': ?instance.colors?.toJson(),
      'borderRadius': ?instance.borderRadius,
      'font': ?instance.font?.toJson(),
      'light': ?instance.light?.toJson(),
      'dark': ?instance.dark?.toJson(),
    };
