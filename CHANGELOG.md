## 0.0.5-beta

**Major Refactoring and Improvements**

* **BREAKING**: Migrated all model classes from `JsonSerializable` to `Freezed`
  * All models now use `@freezed` annotation for better immutability and code generation
  * Removed all custom `fromJson`/`toJson` converters - freezed handles serialization automatically
  * Models now have built-in `copyWith` methods and better type safety
* **BREAKING**: Fixed `styles` type from `Map<String, bool>` to `Map<String, dynamic>`
  * Now correctly supports both boolean values (bold, italic, underline, strike) and string values (textColor, backgroundColor)
  * Matches BlockNoteJS official schema
* Added comprehensive test suite for document JSON parsing
* Updated example app to load document from JSON file instead of empty document
* Improved code quality and maintainability

## 0.0.4-beta

**Documentation Improvements**

* Added BlockNoteJS banner image and links to BlockNote resources
* Enhanced README with BlockNote feature descriptions
* Added credits section acknowledging BlockNote, Prosemirror, and Tiptap
* Improved README structure and visual presentation

## 0.0.3-beta

**Code Quality Improvements**

* Fixed deprecated API usage: replaced `color.value` with `color.toARGB32()`
* Added ignore comments for deprecated `fontFamily` field usage (kept for backwards compatibility)
* Improved pub.dev static analysis score

## 0.0.2-beta

**Documentation and Metadata Updates**

* Added pub.dev URL and repository links to README
* Added issue tracker link to pubspec.yaml
* Added topics/tags for better discoverability on pub.dev
* Updated README with improved links and metadata

## 0.0.1-beta

**Beta Release** - This is the initial beta release of Flutter BlockNote Editor.

### Features

* WebView integration with BlockNoteJS
* Bidirectional communication between Flutter and JavaScript
* Transaction batching system for efficient updates
* Undo/redo safety implementation
* Support for standard BlockNote blocks (paragraph, heading, list, etc.)
* Custom theme support
* Custom toolbar configuration
* Custom slash commands
* Read-only mode support
* Debug logging support

### Known Issues

* This is a beta version with potential bugs
* BlockNoteJS has known bugs (see [GitHub Issues](https://github.com/TypeCellOS/BlockNote/issues))
* Critical iOS Safari bug: overlapping menus on text selection (BlockNoteJS issue #2122)