# BlockNote Web Editor

React-based BlockNote editor for Flutter WebView integration.

## Setup

1. Install dependencies:
```bash
npm install
```

## Development

```bash
npm run dev
```

## Build

Build the editor for production (outputs to `../assets/web`):

```bash
npm run build
```

The build process will:
- Bundle React, BlockNote, and all dependencies
- Output to `assets/web/` directory
- Create a single `index.html` file that can be loaded in Flutter WebView

## Files

- `src/main.jsx` - Entry point, sets up Flutter communication
- `src/App.jsx` - Main React component with BlockNote editor
- `vite.config.js` - Vite configuration for building
