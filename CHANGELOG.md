## 0.0.18

* Environment constraints:
  * SDK: `^3.10.7` → `^3.8.0` (support Dart 3.8.x and up)
  * Flutter: `>=1.17.0` → `>=3.32.0` (align with current Flutter stable)
* Slash command handler: removed deprecated `onItemClick` requirement:
  * `BlockNoteSlashCommandItem` accepts optional [onItemClick] (inline JS) and optional [onItemClickScriptPath] (asset path to a JS file); at least one must be provided (assert)
  * When both are set, file takes priority when resolving; if the file cannot be loaded, inline is used
  * `toJsonResolved()`: loads script path first, falls back to inline on load failure

## 0.0.17

* Slash command icons: flexible support for custom icons (like custom block types):
  * New sealed type `BlockNoteSlashCommandIcon` with variants: `BlockNoteSlashCommandIconText` (emoji/short text), `BlockNoteSlashCommandIconSvg` (raw SVG string), `BlockNoteSlashCommandIconImage` (URL or data URL)
  * `BlockNoteSlashCommandIconImage.fromAsset(String assetPath)` for loading PNG/JPEG from app assets (async)
  * `BlockNoteSlashCommandItem.icon` now accepts `String` (backward compatible) or `BlockNoteSlashCommandIcon`
  * Web: slash menu renders text, SVG (with wrapper + CSS), and image icons; SVG inherits text color for `currentColor`
* Slash command handlers from JS file (like custom block type scripts):
  * Added `onItemClickScriptPath` to `BlockNoteSlashCommandItem`: asset path to a JavaScript file whose content is used as the click handler (evaluated with `editor` in scope)
  * `BlockNoteSlashCommandConfig.toJsonResolved()`: async method that loads script paths and returns JSON with resolved `onItemClick` for the web view
  * DocumentLoader and BlockNoteEditor use `toJsonResolved()` when applying slash command config so the web only receives resolved handler code
* Deprecated inline `onItemClick` string on `BlockNoteSlashCommandItem` in favor of `onItemClickScriptPath` for handler code (parameter and field are `@Deprecated`)
* Example app: custom slash commands demo all icon variants (emoji, text, SVG, image data URL, image fromAsset) and "Insert current date" handler from `assets/slash_insert_date.js`
* Updated embedded web editor bundle (`assets/web/editor.js`, `assets/web/editor.css`)

## 0.0.16

* Block diff: emit only the blocks that actually changed (no redundant parent update):
  * Update detection now uses shallow-children comparison: a block is considered changed only if its own content/props or its child-id list changed; descendant content changes do not mark the parent as changed
  * Editing a nested block (e.g. toggle list item) now produces a single update operation for that child block, not an additional update for the parent with full children
  * New internal helper `blocksEqualShallowChildren`; `computeBlockDifferences` no longer takes a `blocksEqualFn` parameter
* Web editor: test added for "only one update for edited child block, not for parent" (shallow-children comparison)

## 0.0.15

* Transaction and block diff improvements:
  * Transaction operations now include an optional `index` (0-based) indicating operation order within the transaction; Dart `BlockNoteTransactionOp` has optional `index` field (fromJson/toJson/copyWith)
  * Block diff runs over the full block tree (all levels), not just top-level: nested blocks (e.g. toggle list children) get their own insert/update/delete operations with correct `beforeChildId`/`afterChildId`/`parentId` from the editor, so the transaction log shows the actual changed block and its siblings
  * Delete operations use tree-based context (`getBlockContextFromTree`) for blocks at any level and include `parentId`
  * New helpers: `getBlockContextFromTree`, `collectBlocksDepthFirst`; exported `getBlockContextFromEditor`, `getAdjacentBlockIdsFromTopLevel` for tests
* Web editor: Vitest test suite for block diff and transaction sender (getBlockContextFromEditor, getAdjacentBlockIdsFromTopLevel, computeBlockDifferences, createInitialOperations, filterRedundantOperations, payload index, structure test for ID_1/ID_2/ID_3 and nested ID_1_2)
* Web editor: JSDoc updates for sibling/tree semantics; Prettier/ESLint fixes

## 0.0.14

* Document and transaction model updates:
  * Added `generateBlockId()` in Dart (UUID v4) and used in `BlockNoteDocument.empty()`
  * Transaction operations now include `afterChildId`, `beforeChildId`, and `orderedChildIds` for block ordering and reorder support
* Web editor: block ID and transaction improvements:
  * New `idGenerator.js` for UUID v4 block IDs (crypto.randomUUID with RFC 4122 fallback)
  * Document loader and cleaner use centralized ID generation for blocks missing IDs
  * Block diff and transaction sender support sibling links and reorder operations; initial operations include `beforeChildId`/`afterChildId`/`parentId`
  * Editor initial content and transaction ops use generated block IDs consistently
* Updated embedded web editor bundle (`assets/web/editor.js`)

## 0.0.13

* Improved custom slash menu support:
  * Added `buildSlashMenuItems` utility for building custom slash menus from Flutter configuration
  * Enhanced slash menu integration with memoization to prevent unnecessary rebuilds
  * Better support for filtering default slash menu items via `availableSlashCommands` whitelist
  * Improved custom slash command execution with error handling
* Enhanced touch gesture handling:
  * Disabled pinch zoom and double-tap zoom gestures to prevent accidental zooming
  * Improved touch event handling for toolbar buttons and interactive elements
  * Better viewport meta tag management for consistent mobile behavior
* Updated embedded web editor bundle (`assets/web/editor.js`)

## 0.0.12

* Added link tap handling:
  * New `onLinkTapped` callback in `BlockNoteEditor` to handle link clicks
  * Link clicks are intercepted in the editor and sent to Flutter via message channel
  * Prevents default navigation, allowing custom handling (e.g., using `url_launcher`)
  * Added `useLinkTapHandler` hook in web editor for link click interception
  * Added `LinkTapMessage` message type for link tap communication
* Updated embedded web editor bundle (`assets/web/editor.js`)

## 0.0.11

* Improved WebView height management and scrolling behavior:
  * Enhanced selection visibility detection for better keyboard interaction
  * Improved scroll-to-selection handling with debouncing for content size changes
  * Better handling of keyboard open/close states with visual viewport detection
  * Refactored scroll helpers and selection visibility utilities for better code organization
* Enhanced content size change handling:
  * Added debouncing for scroll-to-selection to avoid excessive scrolling
  * Improved detection of significant content size changes (>20px threshold)
  * Better handling of minor content adjustments without resetting debounce timers
* Updated embedded web editor bundle (`assets/web/editor.js`)

## 0.0.10

* Added `BlockNoteController` for programmatic editor operations:
  * `getDocument()` - Retrieve full document on-demand without large data transfers on every change
  * `loadDocument()` - Load documents programmatically
  * `flush()` - Flush pending transactions immediately
  * Methods to set editor configuration (read-only, toolbar, slash commands, schema, etc.)
  * Accessible via `onReady` callback in `BlockNoteEditor` (controller is passed as parameter)
* Added `transactionDebounceDuration` parameter to `BlockNoteEditor` for customizable transaction batching window (default: 400ms)
* Improved theme handling with unified color scheme and better support for light and dark modes
* Refactored web editor components for improved error and loading displays
* Enhanced transaction log page in example app with full document retrieval support
* Updated embedded web editor bundle (`assets/web/editor.js`)

## 0.0.9

* Added custom schema support with schema config, custom JavaScript/CSS injection, and asset-based scripts/styles for custom blocks, inline content, and styles.
* Added schema config messaging and JavaScript evaluation support in the WebView bridge.
* Refactored Dart models to remove Freezed codegen, add manual JSON serialization, and introduce `BlockNoteBlockContent` for inline/table content with custom block types.
* Updated document loading to preload schema config and custom assets when required.
* Updated embedded web editor bundle and example assets for custom schema demos.

## 0.0.8

* Added new block types to Dart models: quote, toggle list, check list, and audio.
* Added typed slash command helpers with safe content escaping.
* Updated example slash command usage to the new helpers.
* Added eager gesture handling for the embedded WebView.
* Updated toolbar popup handling to fully hide intercepted popups.
* Prevented popup portal styling from touching Flutter-hidden popups.
* Marked toggle heading options as toggleable in the web toolbar.
* Updated embedded web editor bundle (`assets/web/editor.js`).
* Disabled `unnecessary_ignore` to avoid generated-file lint noise.

## 0.0.7

* Improved WebView sizing by using layout constraints for available height.
* Added a modal bottom sheet editor demo in the example app.
* Added a React error boundary and `editable` handling for the embedded editor.
* Refined selection auto-scroll to avoid unnecessary scrolls when the keyboard is not visible.
* Improved toolbar popup block type fallback handling for non-JSON values.
* Switched custom slash command execution to a `Function` handler.
* Added analyzer excludes for generated Dart files.
* Added ESLint/Prettier tooling and scripts for the web editor.
* Rebuilt embedded web editor assets (`assets/web`).

## 0.0.6

**Breaking Changes and Code Quality Improvements**

* **BREAKING**: Removed deprecated `fontFamily` field from `BlockNoteTheme`
  * Use `font` field with `BlockNoteFontConfig` instead
  * Removed redundant `effectiveFontFamily` getter (use `theme.font?.family` directly)
* Migrated model classes to use `sealed class` instead of `class` for better type safety
  * `BlockNoteInlineContent` and `BlockNoteBlock` now use sealed classes
  * Provides better exhaustiveness checking and type safety
* Fixed linting warnings for `JsonKey` annotations on Freezed constructor parameters

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
