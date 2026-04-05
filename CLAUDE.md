# CLAUDE.md — flutter_blocknote_editor

## Project Overview

A Flutter package (beta, v0.0.19) that embeds [BlockNoteJS](https://www.blocknotejs.org) inside a WebView with bidirectional Flutter↔JS communication, transaction batching, and undo/redo safety. Supports iOS and Android only (no web).

## Quick Reference

```bash
# Install dependencies
flutter pub get

# Run analyzer
dart analyze

# Apply fixes
dart fix --apply

# Run tests
flutter test

# Run example app
cd example && flutter run
```

## Repository Structure

```
lib/
├── flutter_blocknote_editor.dart   # Public API barrel file (all exports)
├── blocknotejs.dart                # Secondary entry point
└── src/
    ├── batching/
    │   └── transaction_batcher.dart    # Debounced transaction batching (default 400ms)
    ├── bridge/
    │   ├── js_bridge.dart              # Flutter↔JS message bridge
    │   └── message_types.dart          # Message type constants
    ├── model/
    │   ├── blocknote_block.dart        # Block, inline content, block types
    │   ├── blocknote_document.dart     # Document model with version
    │   ├── blocknote_slash_command.dart # Slash command config & items
    │   ├── blocknote_theme.dart        # Theme, colors, fonts
    │   ├── blocknote_toolbar_config.dart # Toolbar button configuration
    │   └── blocknote_transaction.dart  # Transaction & operation models
    ├── utils/
    │   └── json_serializer.dart        # JSON serialization helpers
    └── widget/
        ├── blocknote_editor.dart       # Main StatefulWidget (entry point)
        ├── blocknote_controller.dart   # Programmatic editor control
        ├── asset_server.dart           # Local HTTP server for web assets
        ├── css_utils.dart              # CSS generation utilities
        ├── document_loader.dart        # Document loading logic
        ├── message_handlers.dart       # Incoming JS message handlers
        ├── toolbar_icons.dart          # SVG toolbar icon data
        ├── toolbar_popup_bottom_sheet.dart # Native bottom sheet for toolbar popups
        ├── toolbar_popup_handler.dart  # Toolbar popup routing
        ├── webview_config.dart         # WebView settings & JS injection
        ├── webview_height_manager.dart # Dynamic WebView height + keyboard handling
        └── webview_initializer.dart    # WebView initialization sequence

assets/
├── web/          # Bundled BlockNoteJS editor (editor.js, editor.css, index.html, Inter fonts)
└── icons/        # SVG icons for slash menu items

example/          # Example Flutter app demonstrating all features
├── lib/
│   ├── main.dart
│   ├── config/editor_config.dart
│   └── pages/
│       ├── editor_example_page.dart
│       └── transaction_log_page.dart
└── assets/       # Example custom schema JS/CSS, sample document JSON

test/
└── blocknotejs_test.dart   # Unit tests for document/transaction serialization

web_editor/              # React/Vite source for the bundled JS editor
├── src/
│   ├── main.jsx                    # Entry point
│   ├── App.jsx                     # Root React component
│   ├── hooks/                      # React hooks (useBlockNoteEditor, useFlutterMessages, etc.)
│   ├── handlers/messageHandlers.js # JS→Flutter message routing
│   ├── utils/                      # blockDiff, transactionSender, documentLoader, etc.
│   └── *.test.js                   # Vitest unit tests
├── vite.config.js                  # Vite build config
└── package.json                    # Node deps (@blocknote/*, React 19, Vite, Vitest)
```

## Architecture

### Core Pattern: WebView Bridge

The package uses `flutter_inappwebview` to embed a BlockNoteJS editor. Communication flows through a JavaScript bridge:

1. **Flutter → JS**: `JsBridge` sends typed messages (load document, set config, get document)
2. **JS → Flutter**: `MessageHandlers` processes incoming messages (transactions, document responses, ready signal)
3. **Transaction Batcher**: Debounces JS transactions (400ms default) before delivering to Flutter callbacks

### Key Design Rules

- **Undo/redo stays in JS** — Flutter never triggers undo/redo or re-applies transactions
- **On-demand document retrieval** — Full document fetched via `BlockNoteController.getDocument()`, not on every change
- **Transaction batching** — Changes are batched to prevent excessive Flutter rebuilds; paste and delete flush immediately
- **Asset server** — A local `shelf` HTTP server serves the bundled BlockNoteJS assets to the WebView

### Key Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_inappwebview` | WebView hosting |
| `uuid` | Unique ID generation |
| `flutter_svg` | SVG icon rendering |
| `shelf` / `shelf_static` | Local HTTP asset server |

## Code Conventions

- **Dart SDK**: `^3.8.0`, Flutter `>=3.32.0`
- **Linting**: `flutter_lints` package; config in `analysis_options.yaml`
- **No code generation**: No freezed, json_serializable, or build_runner — manual `fromJson`/`toJson`
- **Sealed classes**: Used for type-safe unions (e.g., `BlockNoteBlockContent`, `BlockNoteInlineContent`, `BlockNoteSlashCommandIcon`)
- **Library declarations**: Files use `library;` directive at top
- **Naming**: Standard Dart conventions — `camelCase` for variables/methods, `PascalCase` for classes, `snake_case` for files
- **Prefix**: All public types prefixed with `BlockNote` (e.g., `BlockNoteEditor`, `BlockNoteDocument`, `BlockNoteTheme`)
- **No BLoC/Provider**: Direct StatefulWidget state management; controller pattern for programmatic access

## Testing

Tests are in `test/blocknotejs_test.dart` and focus on model serialization round-trips:
- Document create/serialize/deserialize
- Transaction serialize/deserialize
- Block types, inline content, nested blocks, styles
- Edge cases (empty styles, missing content, complex documents)

Run with: `flutter test`

## Making Changes

### Adding a new block type
1. Add the type to `BlockNoteBlockType` enum in `lib/src/model/blocknote_block.dart`
2. Handle serialization in `fromJson`/`toJson`
3. The JS side handles rendering via the bundled BlockNoteJS editor

### Adding a new editor parameter
1. Add the parameter to `BlockNoteEditor` constructor in `lib/src/widget/blocknote_editor.dart`
2. Wire it through `webview_config.dart` or `document_loader.dart` as needed
3. Add corresponding JS bridge message if the parameter needs to reach the editor
4. Update `BlockNoteController` if it needs programmatic access

### Updating the web editor bundle
The files in `assets/web/` (editor.js, editor.css) are pre-built from the React app in `web_editor/`:
```bash
cd web_editor && npm install && npm run build:minified
```
The build output is copied to `assets/web/` and committed. The web editor has its own Vitest tests: `cd web_editor && npm test`.

### Versioning
- Version in `pubspec.yaml`
- Changelog in `CHANGELOG.md` (newest version at top)
- Each release bumps version and documents changes

## Common Pitfalls

- **Keyboard handling**: The `Scaffold` wrapping the editor should use `resizeToAvoidBottomInset: false` — the WebView manages its own keyboard padding
- **Platform security**: Android needs `network_security_config.xml` for localhost HTTP; iOS needs `NSAllowsLocalNetworking` in Info.plist
- **Asset server**: The editor loads via a local HTTP server (`shelf`), not `file://` URLs
- **Transaction ordering**: Operations include an optional `index` field for ordering within a transaction
- **Block diff**: Uses shallow-children comparison — only blocks with actual content/prop changes emit updates, not their parents

## Pre-commit Checklist

1. `dart fix --apply`
2. `dart analyze` — must pass with no issues
3. `flutter test` — all tests must pass
4. Update `CHANGELOG.md` if adding features or fixing bugs
