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