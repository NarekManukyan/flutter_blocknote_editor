// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blocknote_theme.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BlockNoteColorPair {

/// Text color.
// ignore: invalid_annotation_target
@JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) Color get text;/// Background color.
// ignore: invalid_annotation_target
@JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) Color get background;
/// Create a copy of BlockNoteColorPair
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<BlockNoteColorPair> get copyWith => _$BlockNoteColorPairCopyWithImpl<BlockNoteColorPair>(this as BlockNoteColorPair, _$identity);

  /// Serializes this BlockNoteColorPair to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockNoteColorPair&&(identical(other.text, text) || other.text == text)&&(identical(other.background, background) || other.background == background));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,background);

@override
String toString() {
  return 'BlockNoteColorPair(text: $text, background: $background)';
}


}

/// @nodoc
abstract mixin class $BlockNoteColorPairCopyWith<$Res>  {
  factory $BlockNoteColorPairCopyWith(BlockNoteColorPair value, $Res Function(BlockNoteColorPair) _then) = _$BlockNoteColorPairCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) Color text,@JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) Color background
});




}
/// @nodoc
class _$BlockNoteColorPairCopyWithImpl<$Res>
    implements $BlockNoteColorPairCopyWith<$Res> {
  _$BlockNoteColorPairCopyWithImpl(this._self, this._then);

  final BlockNoteColorPair _self;
  final $Res Function(BlockNoteColorPair) _then;

/// Create a copy of BlockNoteColorPair
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? background = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as Color,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as Color,
  ));
}

}



/// @nodoc
@JsonSerializable()

class _BlockNoteColorPair implements BlockNoteColorPair {
  const _BlockNoteColorPair({@JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) required this.text, @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) required this.background});
  factory _BlockNoteColorPair.fromJson(Map<String, dynamic> json) => _$BlockNoteColorPairFromJson(json);

/// Text color.
// ignore: invalid_annotation_target
@override@JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) final  Color text;
/// Background color.
// ignore: invalid_annotation_target
@override@JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) final  Color background;

/// Create a copy of BlockNoteColorPair
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockNoteColorPairCopyWith<_BlockNoteColorPair> get copyWith => __$BlockNoteColorPairCopyWithImpl<_BlockNoteColorPair>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockNoteColorPairToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockNoteColorPair&&(identical(other.text, text) || other.text == text)&&(identical(other.background, background) || other.background == background));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,background);

@override
String toString() {
  return 'BlockNoteColorPair(text: $text, background: $background)';
}


}

/// @nodoc
abstract mixin class _$BlockNoteColorPairCopyWith<$Res> implements $BlockNoteColorPairCopyWith<$Res> {
  factory _$BlockNoteColorPairCopyWith(_BlockNoteColorPair value, $Res Function(_BlockNoteColorPair) _then) = __$BlockNoteColorPairCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) Color text,@JsonKey(fromJson: _colorFromJson, toJson: _colorToJson) Color background
});




}
/// @nodoc
class __$BlockNoteColorPairCopyWithImpl<$Res>
    implements _$BlockNoteColorPairCopyWith<$Res> {
  __$BlockNoteColorPairCopyWithImpl(this._self, this._then);

  final _BlockNoteColorPair _self;
  final $Res Function(_BlockNoteColorPair) _then;

/// Create a copy of BlockNoteColorPair
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? background = null,}) {
  return _then(_BlockNoteColorPair(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as Color,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as Color,
  ));
}


}


/// @nodoc
mixin _$BlockNoteHighlightColors {

/// Gray highlight color.
 BlockNoteColorPair? get gray;/// Brown highlight color.
 BlockNoteColorPair? get brown;/// Red highlight color.
 BlockNoteColorPair? get red;/// Orange highlight color.
 BlockNoteColorPair? get orange;/// Yellow highlight color.
 BlockNoteColorPair? get yellow;/// Green highlight color.
 BlockNoteColorPair? get green;/// Blue highlight color.
 BlockNoteColorPair? get blue;/// Purple highlight color.
 BlockNoteColorPair? get purple;/// Pink highlight color.
 BlockNoteColorPair? get pink;
/// Create a copy of BlockNoteHighlightColors
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockNoteHighlightColorsCopyWith<BlockNoteHighlightColors> get copyWith => _$BlockNoteHighlightColorsCopyWithImpl<BlockNoteHighlightColors>(this as BlockNoteHighlightColors, _$identity);

  /// Serializes this BlockNoteHighlightColors to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockNoteHighlightColors&&(identical(other.gray, gray) || other.gray == gray)&&(identical(other.brown, brown) || other.brown == brown)&&(identical(other.red, red) || other.red == red)&&(identical(other.orange, orange) || other.orange == orange)&&(identical(other.yellow, yellow) || other.yellow == yellow)&&(identical(other.green, green) || other.green == green)&&(identical(other.blue, blue) || other.blue == blue)&&(identical(other.purple, purple) || other.purple == purple)&&(identical(other.pink, pink) || other.pink == pink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gray,brown,red,orange,yellow,green,blue,purple,pink);

@override
String toString() {
  return 'BlockNoteHighlightColors(gray: $gray, brown: $brown, red: $red, orange: $orange, yellow: $yellow, green: $green, blue: $blue, purple: $purple, pink: $pink)';
}


}

/// @nodoc
abstract mixin class $BlockNoteHighlightColorsCopyWith<$Res>  {
  factory $BlockNoteHighlightColorsCopyWith(BlockNoteHighlightColors value, $Res Function(BlockNoteHighlightColors) _then) = _$BlockNoteHighlightColorsCopyWithImpl;
@useResult
$Res call({
 BlockNoteColorPair? gray, BlockNoteColorPair? brown, BlockNoteColorPair? red, BlockNoteColorPair? orange, BlockNoteColorPair? yellow, BlockNoteColorPair? green, BlockNoteColorPair? blue, BlockNoteColorPair? purple, BlockNoteColorPair? pink
});


$BlockNoteColorPairCopyWith<$Res>? get gray;$BlockNoteColorPairCopyWith<$Res>? get brown;$BlockNoteColorPairCopyWith<$Res>? get red;$BlockNoteColorPairCopyWith<$Res>? get orange;$BlockNoteColorPairCopyWith<$Res>? get yellow;$BlockNoteColorPairCopyWith<$Res>? get green;$BlockNoteColorPairCopyWith<$Res>? get blue;$BlockNoteColorPairCopyWith<$Res>? get purple;$BlockNoteColorPairCopyWith<$Res>? get pink;

}
/// @nodoc
class _$BlockNoteHighlightColorsCopyWithImpl<$Res>
    implements $BlockNoteHighlightColorsCopyWith<$Res> {
  _$BlockNoteHighlightColorsCopyWithImpl(this._self, this._then);

  final BlockNoteHighlightColors _self;
  final $Res Function(BlockNoteHighlightColors) _then;

/// Create a copy of BlockNoteHighlightColors
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? gray = freezed,Object? brown = freezed,Object? red = freezed,Object? orange = freezed,Object? yellow = freezed,Object? green = freezed,Object? blue = freezed,Object? purple = freezed,Object? pink = freezed,}) {
  return _then(_self.copyWith(
gray: freezed == gray ? _self.gray : gray // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,brown: freezed == brown ? _self.brown : brown // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,red: freezed == red ? _self.red : red // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,orange: freezed == orange ? _self.orange : orange // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,yellow: freezed == yellow ? _self.yellow : yellow // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,green: freezed == green ? _self.green : green // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,blue: freezed == blue ? _self.blue : blue // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,purple: freezed == purple ? _self.purple : purple // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,pink: freezed == pink ? _self.pink : pink // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,
  ));
}
/// Create a copy of BlockNoteHighlightColors
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get gray {
    if (_self.gray == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.gray!, (value) {
    return _then(_self.copyWith(gray: value));
  });
}/// Create a copy of BlockNoteHighlightColors
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get brown {
    if (_self.brown == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.brown!, (value) {
    return _then(_self.copyWith(brown: value));
  });
}/// Create a copy of BlockNoteHighlightColors
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get red {
    if (_self.red == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.red!, (value) {
    return _then(_self.copyWith(red: value));
  });
}/// Create a copy of BlockNoteHighlightColors
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get orange {
    if (_self.orange == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.orange!, (value) {
    return _then(_self.copyWith(orange: value));
  });
}/// Create a copy of BlockNoteHighlightColors
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get yellow {
    if (_self.yellow == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.yellow!, (value) {
    return _then(_self.copyWith(yellow: value));
  });
}/// Create a copy of BlockNoteHighlightColors
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get green {
    if (_self.green == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.green!, (value) {
    return _then(_self.copyWith(green: value));
  });
}/// Create a copy of BlockNoteHighlightColors
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get blue {
    if (_self.blue == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.blue!, (value) {
    return _then(_self.copyWith(blue: value));
  });
}/// Create a copy of BlockNoteHighlightColors
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get purple {
    if (_self.purple == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.purple!, (value) {
    return _then(_self.copyWith(purple: value));
  });
}/// Create a copy of BlockNoteHighlightColors
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get pink {
    if (_self.pink == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.pink!, (value) {
    return _then(_self.copyWith(pink: value));
  });
}
}



/// @nodoc
@JsonSerializable()

class _BlockNoteHighlightColors implements BlockNoteHighlightColors {
  const _BlockNoteHighlightColors({this.gray, this.brown, this.red, this.orange, this.yellow, this.green, this.blue, this.purple, this.pink});
  factory _BlockNoteHighlightColors.fromJson(Map<String, dynamic> json) => _$BlockNoteHighlightColorsFromJson(json);

/// Gray highlight color.
@override final  BlockNoteColorPair? gray;
/// Brown highlight color.
@override final  BlockNoteColorPair? brown;
/// Red highlight color.
@override final  BlockNoteColorPair? red;
/// Orange highlight color.
@override final  BlockNoteColorPair? orange;
/// Yellow highlight color.
@override final  BlockNoteColorPair? yellow;
/// Green highlight color.
@override final  BlockNoteColorPair? green;
/// Blue highlight color.
@override final  BlockNoteColorPair? blue;
/// Purple highlight color.
@override final  BlockNoteColorPair? purple;
/// Pink highlight color.
@override final  BlockNoteColorPair? pink;

/// Create a copy of BlockNoteHighlightColors
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockNoteHighlightColorsCopyWith<_BlockNoteHighlightColors> get copyWith => __$BlockNoteHighlightColorsCopyWithImpl<_BlockNoteHighlightColors>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockNoteHighlightColorsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockNoteHighlightColors&&(identical(other.gray, gray) || other.gray == gray)&&(identical(other.brown, brown) || other.brown == brown)&&(identical(other.red, red) || other.red == red)&&(identical(other.orange, orange) || other.orange == orange)&&(identical(other.yellow, yellow) || other.yellow == yellow)&&(identical(other.green, green) || other.green == green)&&(identical(other.blue, blue) || other.blue == blue)&&(identical(other.purple, purple) || other.purple == purple)&&(identical(other.pink, pink) || other.pink == pink));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,gray,brown,red,orange,yellow,green,blue,purple,pink);

@override
String toString() {
  return 'BlockNoteHighlightColors(gray: $gray, brown: $brown, red: $red, orange: $orange, yellow: $yellow, green: $green, blue: $blue, purple: $purple, pink: $pink)';
}


}

/// @nodoc
abstract mixin class _$BlockNoteHighlightColorsCopyWith<$Res> implements $BlockNoteHighlightColorsCopyWith<$Res> {
  factory _$BlockNoteHighlightColorsCopyWith(_BlockNoteHighlightColors value, $Res Function(_BlockNoteHighlightColors) _then) = __$BlockNoteHighlightColorsCopyWithImpl;
@override @useResult
$Res call({
 BlockNoteColorPair? gray, BlockNoteColorPair? brown, BlockNoteColorPair? red, BlockNoteColorPair? orange, BlockNoteColorPair? yellow, BlockNoteColorPair? green, BlockNoteColorPair? blue, BlockNoteColorPair? purple, BlockNoteColorPair? pink
});


@override $BlockNoteColorPairCopyWith<$Res>? get gray;@override $BlockNoteColorPairCopyWith<$Res>? get brown;@override $BlockNoteColorPairCopyWith<$Res>? get red;@override $BlockNoteColorPairCopyWith<$Res>? get orange;@override $BlockNoteColorPairCopyWith<$Res>? get yellow;@override $BlockNoteColorPairCopyWith<$Res>? get green;@override $BlockNoteColorPairCopyWith<$Res>? get blue;@override $BlockNoteColorPairCopyWith<$Res>? get purple;@override $BlockNoteColorPairCopyWith<$Res>? get pink;

}
/// @nodoc
class __$BlockNoteHighlightColorsCopyWithImpl<$Res>
    implements _$BlockNoteHighlightColorsCopyWith<$Res> {
  __$BlockNoteHighlightColorsCopyWithImpl(this._self, this._then);

  final _BlockNoteHighlightColors _self;
  final $Res Function(_BlockNoteHighlightColors) _then;

/// Create a copy of BlockNoteHighlightColors
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? gray = freezed,Object? brown = freezed,Object? red = freezed,Object? orange = freezed,Object? yellow = freezed,Object? green = freezed,Object? blue = freezed,Object? purple = freezed,Object? pink = freezed,}) {
  return _then(_BlockNoteHighlightColors(
gray: freezed == gray ? _self.gray : gray // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,brown: freezed == brown ? _self.brown : brown // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,red: freezed == red ? _self.red : red // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,orange: freezed == orange ? _self.orange : orange // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,yellow: freezed == yellow ? _self.yellow : yellow // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,green: freezed == green ? _self.green : green // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,blue: freezed == blue ? _self.blue : blue // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,purple: freezed == purple ? _self.purple : purple // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,pink: freezed == pink ? _self.pink : pink // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,
  ));
}

/// Create a copy of BlockNoteHighlightColors
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get gray {
    if (_self.gray == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.gray!, (value) {
    return _then(_self.copyWith(gray: value));
  });
}/// Create a copy of BlockNoteHighlightColors
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get brown {
    if (_self.brown == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.brown!, (value) {
    return _then(_self.copyWith(brown: value));
  });
}/// Create a copy of BlockNoteHighlightColors
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get red {
    if (_self.red == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.red!, (value) {
    return _then(_self.copyWith(red: value));
  });
}/// Create a copy of BlockNoteHighlightColors
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get orange {
    if (_self.orange == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.orange!, (value) {
    return _then(_self.copyWith(orange: value));
  });
}/// Create a copy of BlockNoteHighlightColors
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get yellow {
    if (_self.yellow == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.yellow!, (value) {
    return _then(_self.copyWith(yellow: value));
  });
}/// Create a copy of BlockNoteHighlightColors
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get green {
    if (_self.green == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.green!, (value) {
    return _then(_self.copyWith(green: value));
  });
}/// Create a copy of BlockNoteHighlightColors
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get blue {
    if (_self.blue == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.blue!, (value) {
    return _then(_self.copyWith(blue: value));
  });
}/// Create a copy of BlockNoteHighlightColors
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get purple {
    if (_self.purple == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.purple!, (value) {
    return _then(_self.copyWith(purple: value));
  });
}/// Create a copy of BlockNoteHighlightColors
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get pink {
    if (_self.pink == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.pink!, (value) {
    return _then(_self.copyWith(pink: value));
  });
}
}


/// @nodoc
mixin _$BlockNoteColorScheme {

/// Editor text and background colors.
 BlockNoteColorPair? get editor;/// Menu text and background colors.
 BlockNoteColorPair? get menu;/// Tooltip text and background colors.
 BlockNoteColorPair? get tooltip;/// Hovered element text and background colors.
 BlockNoteColorPair? get hovered;/// Selected element text and background colors.
 BlockNoteColorPair? get selected;/// Disabled element text and background colors.
 BlockNoteColorPair? get disabled;/// Shadow color.
// ignore: invalid_annotation_target
@JsonKey(fromJson: _colorFromJsonNullable, toJson: _colorToJsonNullable) Color? get shadow;/// Border color.
// ignore: invalid_annotation_target
@JsonKey(fromJson: _colorFromJsonNullable, toJson: _colorToJsonNullable) Color? get border;/// Side menu color.
// ignore: invalid_annotation_target
@JsonKey(fromJson: _colorFromJsonNullable, toJson: _colorToJsonNullable) Color? get sideMenu;/// Highlight colors.
 BlockNoteHighlightColors? get highlights;
/// Create a copy of BlockNoteColorScheme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockNoteColorSchemeCopyWith<BlockNoteColorScheme> get copyWith => _$BlockNoteColorSchemeCopyWithImpl<BlockNoteColorScheme>(this as BlockNoteColorScheme, _$identity);

  /// Serializes this BlockNoteColorScheme to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockNoteColorScheme&&(identical(other.editor, editor) || other.editor == editor)&&(identical(other.menu, menu) || other.menu == menu)&&(identical(other.tooltip, tooltip) || other.tooltip == tooltip)&&(identical(other.hovered, hovered) || other.hovered == hovered)&&(identical(other.selected, selected) || other.selected == selected)&&(identical(other.disabled, disabled) || other.disabled == disabled)&&(identical(other.shadow, shadow) || other.shadow == shadow)&&(identical(other.border, border) || other.border == border)&&(identical(other.sideMenu, sideMenu) || other.sideMenu == sideMenu)&&(identical(other.highlights, highlights) || other.highlights == highlights));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,editor,menu,tooltip,hovered,selected,disabled,shadow,border,sideMenu,highlights);

@override
String toString() {
  return 'BlockNoteColorScheme(editor: $editor, menu: $menu, tooltip: $tooltip, hovered: $hovered, selected: $selected, disabled: $disabled, shadow: $shadow, border: $border, sideMenu: $sideMenu, highlights: $highlights)';
}


}

/// @nodoc
abstract mixin class $BlockNoteColorSchemeCopyWith<$Res>  {
  factory $BlockNoteColorSchemeCopyWith(BlockNoteColorScheme value, $Res Function(BlockNoteColorScheme) _then) = _$BlockNoteColorSchemeCopyWithImpl;
@useResult
$Res call({
 BlockNoteColorPair? editor, BlockNoteColorPair? menu, BlockNoteColorPair? tooltip, BlockNoteColorPair? hovered, BlockNoteColorPair? selected, BlockNoteColorPair? disabled,@JsonKey(fromJson: _colorFromJsonNullable, toJson: _colorToJsonNullable) Color? shadow,@JsonKey(fromJson: _colorFromJsonNullable, toJson: _colorToJsonNullable) Color? border,@JsonKey(fromJson: _colorFromJsonNullable, toJson: _colorToJsonNullable) Color? sideMenu, BlockNoteHighlightColors? highlights
});


$BlockNoteColorPairCopyWith<$Res>? get editor;$BlockNoteColorPairCopyWith<$Res>? get menu;$BlockNoteColorPairCopyWith<$Res>? get tooltip;$BlockNoteColorPairCopyWith<$Res>? get hovered;$BlockNoteColorPairCopyWith<$Res>? get selected;$BlockNoteColorPairCopyWith<$Res>? get disabled;$BlockNoteHighlightColorsCopyWith<$Res>? get highlights;

}
/// @nodoc
class _$BlockNoteColorSchemeCopyWithImpl<$Res>
    implements $BlockNoteColorSchemeCopyWith<$Res> {
  _$BlockNoteColorSchemeCopyWithImpl(this._self, this._then);

  final BlockNoteColorScheme _self;
  final $Res Function(BlockNoteColorScheme) _then;

/// Create a copy of BlockNoteColorScheme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? editor = freezed,Object? menu = freezed,Object? tooltip = freezed,Object? hovered = freezed,Object? selected = freezed,Object? disabled = freezed,Object? shadow = freezed,Object? border = freezed,Object? sideMenu = freezed,Object? highlights = freezed,}) {
  return _then(_self.copyWith(
editor: freezed == editor ? _self.editor : editor // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,menu: freezed == menu ? _self.menu : menu // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,tooltip: freezed == tooltip ? _self.tooltip : tooltip // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,hovered: freezed == hovered ? _self.hovered : hovered // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,shadow: freezed == shadow ? _self.shadow : shadow // ignore: cast_nullable_to_non_nullable
as Color?,border: freezed == border ? _self.border : border // ignore: cast_nullable_to_non_nullable
as Color?,sideMenu: freezed == sideMenu ? _self.sideMenu : sideMenu // ignore: cast_nullable_to_non_nullable
as Color?,highlights: freezed == highlights ? _self.highlights : highlights // ignore: cast_nullable_to_non_nullable
as BlockNoteHighlightColors?,
  ));
}
/// Create a copy of BlockNoteColorScheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get editor {
    if (_self.editor == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.editor!, (value) {
    return _then(_self.copyWith(editor: value));
  });
}/// Create a copy of BlockNoteColorScheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get menu {
    if (_self.menu == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.menu!, (value) {
    return _then(_self.copyWith(menu: value));
  });
}/// Create a copy of BlockNoteColorScheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get tooltip {
    if (_self.tooltip == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.tooltip!, (value) {
    return _then(_self.copyWith(tooltip: value));
  });
}/// Create a copy of BlockNoteColorScheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get hovered {
    if (_self.hovered == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.hovered!, (value) {
    return _then(_self.copyWith(hovered: value));
  });
}/// Create a copy of BlockNoteColorScheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get selected {
    if (_self.selected == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.selected!, (value) {
    return _then(_self.copyWith(selected: value));
  });
}/// Create a copy of BlockNoteColorScheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get disabled {
    if (_self.disabled == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.disabled!, (value) {
    return _then(_self.copyWith(disabled: value));
  });
}/// Create a copy of BlockNoteColorScheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteHighlightColorsCopyWith<$Res>? get highlights {
    if (_self.highlights == null) {
    return null;
  }

  return $BlockNoteHighlightColorsCopyWith<$Res>(_self.highlights!, (value) {
    return _then(_self.copyWith(highlights: value));
  });
}
}



/// @nodoc
@JsonSerializable()

class _BlockNoteColorScheme implements BlockNoteColorScheme {
  const _BlockNoteColorScheme({this.editor, this.menu, this.tooltip, this.hovered, this.selected, this.disabled, @JsonKey(fromJson: _colorFromJsonNullable, toJson: _colorToJsonNullable) this.shadow, @JsonKey(fromJson: _colorFromJsonNullable, toJson: _colorToJsonNullable) this.border, @JsonKey(fromJson: _colorFromJsonNullable, toJson: _colorToJsonNullable) this.sideMenu, this.highlights});
  factory _BlockNoteColorScheme.fromJson(Map<String, dynamic> json) => _$BlockNoteColorSchemeFromJson(json);

/// Editor text and background colors.
@override final  BlockNoteColorPair? editor;
/// Menu text and background colors.
@override final  BlockNoteColorPair? menu;
/// Tooltip text and background colors.
@override final  BlockNoteColorPair? tooltip;
/// Hovered element text and background colors.
@override final  BlockNoteColorPair? hovered;
/// Selected element text and background colors.
@override final  BlockNoteColorPair? selected;
/// Disabled element text and background colors.
@override final  BlockNoteColorPair? disabled;
/// Shadow color.
// ignore: invalid_annotation_target
@override@JsonKey(fromJson: _colorFromJsonNullable, toJson: _colorToJsonNullable) final  Color? shadow;
/// Border color.
// ignore: invalid_annotation_target
@override@JsonKey(fromJson: _colorFromJsonNullable, toJson: _colorToJsonNullable) final  Color? border;
/// Side menu color.
// ignore: invalid_annotation_target
@override@JsonKey(fromJson: _colorFromJsonNullable, toJson: _colorToJsonNullable) final  Color? sideMenu;
/// Highlight colors.
@override final  BlockNoteHighlightColors? highlights;

/// Create a copy of BlockNoteColorScheme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockNoteColorSchemeCopyWith<_BlockNoteColorScheme> get copyWith => __$BlockNoteColorSchemeCopyWithImpl<_BlockNoteColorScheme>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockNoteColorSchemeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockNoteColorScheme&&(identical(other.editor, editor) || other.editor == editor)&&(identical(other.menu, menu) || other.menu == menu)&&(identical(other.tooltip, tooltip) || other.tooltip == tooltip)&&(identical(other.hovered, hovered) || other.hovered == hovered)&&(identical(other.selected, selected) || other.selected == selected)&&(identical(other.disabled, disabled) || other.disabled == disabled)&&(identical(other.shadow, shadow) || other.shadow == shadow)&&(identical(other.border, border) || other.border == border)&&(identical(other.sideMenu, sideMenu) || other.sideMenu == sideMenu)&&(identical(other.highlights, highlights) || other.highlights == highlights));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,editor,menu,tooltip,hovered,selected,disabled,shadow,border,sideMenu,highlights);

@override
String toString() {
  return 'BlockNoteColorScheme(editor: $editor, menu: $menu, tooltip: $tooltip, hovered: $hovered, selected: $selected, disabled: $disabled, shadow: $shadow, border: $border, sideMenu: $sideMenu, highlights: $highlights)';
}


}

/// @nodoc
abstract mixin class _$BlockNoteColorSchemeCopyWith<$Res> implements $BlockNoteColorSchemeCopyWith<$Res> {
  factory _$BlockNoteColorSchemeCopyWith(_BlockNoteColorScheme value, $Res Function(_BlockNoteColorScheme) _then) = __$BlockNoteColorSchemeCopyWithImpl;
@override @useResult
$Res call({
 BlockNoteColorPair? editor, BlockNoteColorPair? menu, BlockNoteColorPair? tooltip, BlockNoteColorPair? hovered, BlockNoteColorPair? selected, BlockNoteColorPair? disabled,@JsonKey(fromJson: _colorFromJsonNullable, toJson: _colorToJsonNullable) Color? shadow,@JsonKey(fromJson: _colorFromJsonNullable, toJson: _colorToJsonNullable) Color? border,@JsonKey(fromJson: _colorFromJsonNullable, toJson: _colorToJsonNullable) Color? sideMenu, BlockNoteHighlightColors? highlights
});


@override $BlockNoteColorPairCopyWith<$Res>? get editor;@override $BlockNoteColorPairCopyWith<$Res>? get menu;@override $BlockNoteColorPairCopyWith<$Res>? get tooltip;@override $BlockNoteColorPairCopyWith<$Res>? get hovered;@override $BlockNoteColorPairCopyWith<$Res>? get selected;@override $BlockNoteColorPairCopyWith<$Res>? get disabled;@override $BlockNoteHighlightColorsCopyWith<$Res>? get highlights;

}
/// @nodoc
class __$BlockNoteColorSchemeCopyWithImpl<$Res>
    implements _$BlockNoteColorSchemeCopyWith<$Res> {
  __$BlockNoteColorSchemeCopyWithImpl(this._self, this._then);

  final _BlockNoteColorScheme _self;
  final $Res Function(_BlockNoteColorScheme) _then;

/// Create a copy of BlockNoteColorScheme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? editor = freezed,Object? menu = freezed,Object? tooltip = freezed,Object? hovered = freezed,Object? selected = freezed,Object? disabled = freezed,Object? shadow = freezed,Object? border = freezed,Object? sideMenu = freezed,Object? highlights = freezed,}) {
  return _then(_BlockNoteColorScheme(
editor: freezed == editor ? _self.editor : editor // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,menu: freezed == menu ? _self.menu : menu // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,tooltip: freezed == tooltip ? _self.tooltip : tooltip // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,hovered: freezed == hovered ? _self.hovered : hovered // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,disabled: freezed == disabled ? _self.disabled : disabled // ignore: cast_nullable_to_non_nullable
as BlockNoteColorPair?,shadow: freezed == shadow ? _self.shadow : shadow // ignore: cast_nullable_to_non_nullable
as Color?,border: freezed == border ? _self.border : border // ignore: cast_nullable_to_non_nullable
as Color?,sideMenu: freezed == sideMenu ? _self.sideMenu : sideMenu // ignore: cast_nullable_to_non_nullable
as Color?,highlights: freezed == highlights ? _self.highlights : highlights // ignore: cast_nullable_to_non_nullable
as BlockNoteHighlightColors?,
  ));
}

/// Create a copy of BlockNoteColorScheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get editor {
    if (_self.editor == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.editor!, (value) {
    return _then(_self.copyWith(editor: value));
  });
}/// Create a copy of BlockNoteColorScheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get menu {
    if (_self.menu == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.menu!, (value) {
    return _then(_self.copyWith(menu: value));
  });
}/// Create a copy of BlockNoteColorScheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get tooltip {
    if (_self.tooltip == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.tooltip!, (value) {
    return _then(_self.copyWith(tooltip: value));
  });
}/// Create a copy of BlockNoteColorScheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get hovered {
    if (_self.hovered == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.hovered!, (value) {
    return _then(_self.copyWith(hovered: value));
  });
}/// Create a copy of BlockNoteColorScheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get selected {
    if (_self.selected == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.selected!, (value) {
    return _then(_self.copyWith(selected: value));
  });
}/// Create a copy of BlockNoteColorScheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorPairCopyWith<$Res>? get disabled {
    if (_self.disabled == null) {
    return null;
  }

  return $BlockNoteColorPairCopyWith<$Res>(_self.disabled!, (value) {
    return _then(_self.copyWith(disabled: value));
  });
}/// Create a copy of BlockNoteColorScheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteHighlightColorsCopyWith<$Res>? get highlights {
    if (_self.highlights == null) {
    return null;
  }

  return $BlockNoteHighlightColorsCopyWith<$Res>(_self.highlights!, (value) {
    return _then(_self.copyWith(highlights: value));
  });
}
}


/// @nodoc
mixin _$BlockNoteFontFile {

/// Path to the font file (relative to the asset server root).
///
/// Example: './fonts/custom-font.woff2' or 'fonts/custom-font.woff2'
 String get path;/// Font file format.
 BlockNoteFontFormat get format;/// Font weight using Flutter's FontWeight enum.
///
/// Common values: FontWeight.normal (400), FontWeight.bold (700)
// ignore: invalid_annotation_target
@JsonKey(fromJson: _fontWeightFromJson, toJson: _fontWeightToJson) FontWeight? get weight;/// Font style using Flutter's FontStyle enum.
///
/// Common values: FontStyle.normal, FontStyle.italic
// ignore: invalid_annotation_target
@JsonKey(fromJson: _fontStyleFromJson, toJson: _fontStyleToJson) FontStyle? get style;
/// Create a copy of BlockNoteFontFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockNoteFontFileCopyWith<BlockNoteFontFile> get copyWith => _$BlockNoteFontFileCopyWithImpl<BlockNoteFontFile>(this as BlockNoteFontFile, _$identity);

  /// Serializes this BlockNoteFontFile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockNoteFontFile&&(identical(other.path, path) || other.path == path)&&(identical(other.format, format) || other.format == format)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.style, style) || other.style == style));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,format,weight,style);

@override
String toString() {
  return 'BlockNoteFontFile(path: $path, format: $format, weight: $weight, style: $style)';
}


}

/// @nodoc
abstract mixin class $BlockNoteFontFileCopyWith<$Res>  {
  factory $BlockNoteFontFileCopyWith(BlockNoteFontFile value, $Res Function(BlockNoteFontFile) _then) = _$BlockNoteFontFileCopyWithImpl;
@useResult
$Res call({
 String path, BlockNoteFontFormat format,@JsonKey(fromJson: _fontWeightFromJson, toJson: _fontWeightToJson) FontWeight? weight,@JsonKey(fromJson: _fontStyleFromJson, toJson: _fontStyleToJson) FontStyle? style
});




}
/// @nodoc
class _$BlockNoteFontFileCopyWithImpl<$Res>
    implements $BlockNoteFontFileCopyWith<$Res> {
  _$BlockNoteFontFileCopyWithImpl(this._self, this._then);

  final BlockNoteFontFile _self;
  final $Res Function(BlockNoteFontFile) _then;

/// Create a copy of BlockNoteFontFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? format = null,Object? weight = freezed,Object? style = freezed,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as BlockNoteFontFormat,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as FontWeight?,style: freezed == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as FontStyle?,
  ));
}

}



/// @nodoc
@JsonSerializable()

class _BlockNoteFontFile implements BlockNoteFontFile {
  const _BlockNoteFontFile({required this.path, required this.format, @JsonKey(fromJson: _fontWeightFromJson, toJson: _fontWeightToJson) this.weight, @JsonKey(fromJson: _fontStyleFromJson, toJson: _fontStyleToJson) this.style});
  factory _BlockNoteFontFile.fromJson(Map<String, dynamic> json) => _$BlockNoteFontFileFromJson(json);

/// Path to the font file (relative to the asset server root).
///
/// Example: './fonts/custom-font.woff2' or 'fonts/custom-font.woff2'
@override final  String path;
/// Font file format.
@override final  BlockNoteFontFormat format;
/// Font weight using Flutter's FontWeight enum.
///
/// Common values: FontWeight.normal (400), FontWeight.bold (700)
// ignore: invalid_annotation_target
@override@JsonKey(fromJson: _fontWeightFromJson, toJson: _fontWeightToJson) final  FontWeight? weight;
/// Font style using Flutter's FontStyle enum.
///
/// Common values: FontStyle.normal, FontStyle.italic
// ignore: invalid_annotation_target
@override@JsonKey(fromJson: _fontStyleFromJson, toJson: _fontStyleToJson) final  FontStyle? style;

/// Create a copy of BlockNoteFontFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockNoteFontFileCopyWith<_BlockNoteFontFile> get copyWith => __$BlockNoteFontFileCopyWithImpl<_BlockNoteFontFile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockNoteFontFileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockNoteFontFile&&(identical(other.path, path) || other.path == path)&&(identical(other.format, format) || other.format == format)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.style, style) || other.style == style));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,format,weight,style);

@override
String toString() {
  return 'BlockNoteFontFile(path: $path, format: $format, weight: $weight, style: $style)';
}


}

/// @nodoc
abstract mixin class _$BlockNoteFontFileCopyWith<$Res> implements $BlockNoteFontFileCopyWith<$Res> {
  factory _$BlockNoteFontFileCopyWith(_BlockNoteFontFile value, $Res Function(_BlockNoteFontFile) _then) = __$BlockNoteFontFileCopyWithImpl;
@override @useResult
$Res call({
 String path, BlockNoteFontFormat format,@JsonKey(fromJson: _fontWeightFromJson, toJson: _fontWeightToJson) FontWeight? weight,@JsonKey(fromJson: _fontStyleFromJson, toJson: _fontStyleToJson) FontStyle? style
});




}
/// @nodoc
class __$BlockNoteFontFileCopyWithImpl<$Res>
    implements _$BlockNoteFontFileCopyWith<$Res> {
  __$BlockNoteFontFileCopyWithImpl(this._self, this._then);

  final _BlockNoteFontFile _self;
  final $Res Function(_BlockNoteFontFile) _then;

/// Create a copy of BlockNoteFontFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? format = null,Object? weight = freezed,Object? style = freezed,}) {
  return _then(_BlockNoteFontFile(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as BlockNoteFontFormat,weight: freezed == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as FontWeight?,style: freezed == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as FontStyle?,
  ));
}


}


/// @nodoc
mixin _$BlockNoteFontConfig {

/// Font family name (CSS font-family string).
 String get family;/// Font files for @font-face declarations.
///
/// If empty, the font is assumed to be a system font.
 List<BlockNoteFontFile> get files;
/// Create a copy of BlockNoteFontConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockNoteFontConfigCopyWith<BlockNoteFontConfig> get copyWith => _$BlockNoteFontConfigCopyWithImpl<BlockNoteFontConfig>(this as BlockNoteFontConfig, _$identity);

  /// Serializes this BlockNoteFontConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockNoteFontConfig&&(identical(other.family, family) || other.family == family)&&const DeepCollectionEquality().equals(other.files, files));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,family,const DeepCollectionEquality().hash(files));

@override
String toString() {
  return 'BlockNoteFontConfig(family: $family, files: $files)';
}


}

/// @nodoc
abstract mixin class $BlockNoteFontConfigCopyWith<$Res>  {
  factory $BlockNoteFontConfigCopyWith(BlockNoteFontConfig value, $Res Function(BlockNoteFontConfig) _then) = _$BlockNoteFontConfigCopyWithImpl;
@useResult
$Res call({
 String family, List<BlockNoteFontFile> files
});




}
/// @nodoc
class _$BlockNoteFontConfigCopyWithImpl<$Res>
    implements $BlockNoteFontConfigCopyWith<$Res> {
  _$BlockNoteFontConfigCopyWithImpl(this._self, this._then);

  final BlockNoteFontConfig _self;
  final $Res Function(BlockNoteFontConfig) _then;

/// Create a copy of BlockNoteFontConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? family = null,Object? files = null,}) {
  return _then(_self.copyWith(
family: null == family ? _self.family : family // ignore: cast_nullable_to_non_nullable
as String,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<BlockNoteFontFile>,
  ));
}

}



/// @nodoc
@JsonSerializable()

class _BlockNoteFontConfig implements BlockNoteFontConfig {
  const _BlockNoteFontConfig({required this.family, final  List<BlockNoteFontFile> files = const []}): _files = files;
  factory _BlockNoteFontConfig.fromJson(Map<String, dynamic> json) => _$BlockNoteFontConfigFromJson(json);

/// Font family name (CSS font-family string).
@override final  String family;
/// Font files for @font-face declarations.
///
/// If empty, the font is assumed to be a system font.
 final  List<BlockNoteFontFile> _files;
/// Font files for @font-face declarations.
///
/// If empty, the font is assumed to be a system font.
@override@JsonKey() List<BlockNoteFontFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}


/// Create a copy of BlockNoteFontConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockNoteFontConfigCopyWith<_BlockNoteFontConfig> get copyWith => __$BlockNoteFontConfigCopyWithImpl<_BlockNoteFontConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockNoteFontConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockNoteFontConfig&&(identical(other.family, family) || other.family == family)&&const DeepCollectionEquality().equals(other._files, _files));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,family,const DeepCollectionEquality().hash(_files));

@override
String toString() {
  return 'BlockNoteFontConfig(family: $family, files: $files)';
}


}

/// @nodoc
abstract mixin class _$BlockNoteFontConfigCopyWith<$Res> implements $BlockNoteFontConfigCopyWith<$Res> {
  factory _$BlockNoteFontConfigCopyWith(_BlockNoteFontConfig value, $Res Function(_BlockNoteFontConfig) _then) = __$BlockNoteFontConfigCopyWithImpl;
@override @useResult
$Res call({
 String family, List<BlockNoteFontFile> files
});




}
/// @nodoc
class __$BlockNoteFontConfigCopyWithImpl<$Res>
    implements _$BlockNoteFontConfigCopyWith<$Res> {
  __$BlockNoteFontConfigCopyWithImpl(this._self, this._then);

  final _BlockNoteFontConfig _self;
  final $Res Function(_BlockNoteFontConfig) _then;

/// Create a copy of BlockNoteFontConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? family = null,Object? files = null,}) {
  return _then(_BlockNoteFontConfig(
family: null == family ? _self.family : family // ignore: cast_nullable_to_non_nullable
as String,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<BlockNoteFontFile>,
  ));
}


}


/// @nodoc
mixin _$BlockNoteTheme {

/// Colors for both light and dark themes (if light/dark not specified).
 BlockNoteColorScheme? get colors;/// Border radius in pixels.
 double? get borderRadius;/// Font configuration using Flutter-friendly API.
///
/// Supports both system fonts and custom font files with automatic CSS generation.
 BlockNoteFontConfig? get font;/// Light theme colors (overrides colors).
 BlockNoteColorScheme? get light;/// Dark theme colors (overrides colors).
 BlockNoteColorScheme? get dark;
/// Create a copy of BlockNoteTheme
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockNoteThemeCopyWith<BlockNoteTheme> get copyWith => _$BlockNoteThemeCopyWithImpl<BlockNoteTheme>(this as BlockNoteTheme, _$identity);

  /// Serializes this BlockNoteTheme to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockNoteTheme&&(identical(other.colors, colors) || other.colors == colors)&&(identical(other.borderRadius, borderRadius) || other.borderRadius == borderRadius)&&(identical(other.font, font) || other.font == font)&&(identical(other.light, light) || other.light == light)&&(identical(other.dark, dark) || other.dark == dark));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,colors,borderRadius,font,light,dark);

@override
String toString() {
  return 'BlockNoteTheme(colors: $colors, borderRadius: $borderRadius, font: $font, light: $light, dark: $dark)';
}


}

/// @nodoc
abstract mixin class $BlockNoteThemeCopyWith<$Res>  {
  factory $BlockNoteThemeCopyWith(BlockNoteTheme value, $Res Function(BlockNoteTheme) _then) = _$BlockNoteThemeCopyWithImpl;
@useResult
$Res call({
 BlockNoteColorScheme? colors, double? borderRadius, BlockNoteFontConfig? font, BlockNoteColorScheme? light, BlockNoteColorScheme? dark
});


$BlockNoteColorSchemeCopyWith<$Res>? get colors;$BlockNoteFontConfigCopyWith<$Res>? get font;$BlockNoteColorSchemeCopyWith<$Res>? get light;$BlockNoteColorSchemeCopyWith<$Res>? get dark;

}
/// @nodoc
class _$BlockNoteThemeCopyWithImpl<$Res>
    implements $BlockNoteThemeCopyWith<$Res> {
  _$BlockNoteThemeCopyWithImpl(this._self, this._then);

  final BlockNoteTheme _self;
  final $Res Function(BlockNoteTheme) _then;

/// Create a copy of BlockNoteTheme
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? colors = freezed,Object? borderRadius = freezed,Object? font = freezed,Object? light = freezed,Object? dark = freezed,}) {
  return _then(_self.copyWith(
colors: freezed == colors ? _self.colors : colors // ignore: cast_nullable_to_non_nullable
as BlockNoteColorScheme?,borderRadius: freezed == borderRadius ? _self.borderRadius : borderRadius // ignore: cast_nullable_to_non_nullable
as double?,font: freezed == font ? _self.font : font // ignore: cast_nullable_to_non_nullable
as BlockNoteFontConfig?,light: freezed == light ? _self.light : light // ignore: cast_nullable_to_non_nullable
as BlockNoteColorScheme?,dark: freezed == dark ? _self.dark : dark // ignore: cast_nullable_to_non_nullable
as BlockNoteColorScheme?,
  ));
}
/// Create a copy of BlockNoteTheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorSchemeCopyWith<$Res>? get colors {
    if (_self.colors == null) {
    return null;
  }

  return $BlockNoteColorSchemeCopyWith<$Res>(_self.colors!, (value) {
    return _then(_self.copyWith(colors: value));
  });
}/// Create a copy of BlockNoteTheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteFontConfigCopyWith<$Res>? get font {
    if (_self.font == null) {
    return null;
  }

  return $BlockNoteFontConfigCopyWith<$Res>(_self.font!, (value) {
    return _then(_self.copyWith(font: value));
  });
}/// Create a copy of BlockNoteTheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorSchemeCopyWith<$Res>? get light {
    if (_self.light == null) {
    return null;
  }

  return $BlockNoteColorSchemeCopyWith<$Res>(_self.light!, (value) {
    return _then(_self.copyWith(light: value));
  });
}/// Create a copy of BlockNoteTheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorSchemeCopyWith<$Res>? get dark {
    if (_self.dark == null) {
    return null;
  }

  return $BlockNoteColorSchemeCopyWith<$Res>(_self.dark!, (value) {
    return _then(_self.copyWith(dark: value));
  });
}
}



/// @nodoc
@JsonSerializable()

class _BlockNoteTheme implements BlockNoteTheme {
  const _BlockNoteTheme({this.colors, this.borderRadius, this.font, this.light, this.dark});
  factory _BlockNoteTheme.fromJson(Map<String, dynamic> json) => _$BlockNoteThemeFromJson(json);

/// Colors for both light and dark themes (if light/dark not specified).
@override final  BlockNoteColorScheme? colors;
/// Border radius in pixels.
@override final  double? borderRadius;
/// Font configuration using Flutter-friendly API.
///
/// Supports both system fonts and custom font files with automatic CSS generation.
@override final  BlockNoteFontConfig? font;
/// Light theme colors (overrides colors).
@override final  BlockNoteColorScheme? light;
/// Dark theme colors (overrides colors).
@override final  BlockNoteColorScheme? dark;

/// Create a copy of BlockNoteTheme
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockNoteThemeCopyWith<_BlockNoteTheme> get copyWith => __$BlockNoteThemeCopyWithImpl<_BlockNoteTheme>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BlockNoteThemeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BlockNoteTheme&&(identical(other.colors, colors) || other.colors == colors)&&(identical(other.borderRadius, borderRadius) || other.borderRadius == borderRadius)&&(identical(other.font, font) || other.font == font)&&(identical(other.light, light) || other.light == light)&&(identical(other.dark, dark) || other.dark == dark));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,colors,borderRadius,font,light,dark);

@override
String toString() {
  return 'BlockNoteTheme(colors: $colors, borderRadius: $borderRadius, font: $font, light: $light, dark: $dark)';
}


}

/// @nodoc
abstract mixin class _$BlockNoteThemeCopyWith<$Res> implements $BlockNoteThemeCopyWith<$Res> {
  factory _$BlockNoteThemeCopyWith(_BlockNoteTheme value, $Res Function(_BlockNoteTheme) _then) = __$BlockNoteThemeCopyWithImpl;
@override @useResult
$Res call({
 BlockNoteColorScheme? colors, double? borderRadius, BlockNoteFontConfig? font, BlockNoteColorScheme? light, BlockNoteColorScheme? dark
});


@override $BlockNoteColorSchemeCopyWith<$Res>? get colors;@override $BlockNoteFontConfigCopyWith<$Res>? get font;@override $BlockNoteColorSchemeCopyWith<$Res>? get light;@override $BlockNoteColorSchemeCopyWith<$Res>? get dark;

}
/// @nodoc
class __$BlockNoteThemeCopyWithImpl<$Res>
    implements _$BlockNoteThemeCopyWith<$Res> {
  __$BlockNoteThemeCopyWithImpl(this._self, this._then);

  final _BlockNoteTheme _self;
  final $Res Function(_BlockNoteTheme) _then;

/// Create a copy of BlockNoteTheme
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? colors = freezed,Object? borderRadius = freezed,Object? font = freezed,Object? light = freezed,Object? dark = freezed,}) {
  return _then(_BlockNoteTheme(
colors: freezed == colors ? _self.colors : colors // ignore: cast_nullable_to_non_nullable
as BlockNoteColorScheme?,borderRadius: freezed == borderRadius ? _self.borderRadius : borderRadius // ignore: cast_nullable_to_non_nullable
as double?,font: freezed == font ? _self.font : font // ignore: cast_nullable_to_non_nullable
as BlockNoteFontConfig?,light: freezed == light ? _self.light : light // ignore: cast_nullable_to_non_nullable
as BlockNoteColorScheme?,dark: freezed == dark ? _self.dark : dark // ignore: cast_nullable_to_non_nullable
as BlockNoteColorScheme?,
  ));
}

/// Create a copy of BlockNoteTheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorSchemeCopyWith<$Res>? get colors {
    if (_self.colors == null) {
    return null;
  }

  return $BlockNoteColorSchemeCopyWith<$Res>(_self.colors!, (value) {
    return _then(_self.copyWith(colors: value));
  });
}/// Create a copy of BlockNoteTheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteFontConfigCopyWith<$Res>? get font {
    if (_self.font == null) {
    return null;
  }

  return $BlockNoteFontConfigCopyWith<$Res>(_self.font!, (value) {
    return _then(_self.copyWith(font: value));
  });
}/// Create a copy of BlockNoteTheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorSchemeCopyWith<$Res>? get light {
    if (_self.light == null) {
    return null;
  }

  return $BlockNoteColorSchemeCopyWith<$Res>(_self.light!, (value) {
    return _then(_self.copyWith(light: value));
  });
}/// Create a copy of BlockNoteTheme
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BlockNoteColorSchemeCopyWith<$Res>? get dark {
    if (_self.dark == null) {
    return null;
  }

  return $BlockNoteColorSchemeCopyWith<$Res>(_self.dark!, (value) {
    return _then(_self.copyWith(dark: value));
  });
}
}

// dart format on
