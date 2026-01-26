import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [
    react({
      // Optimize React for production
      jsxRuntime: 'automatic',
    }),
  ],
  build: {
    outDir: '../assets/web',
    emptyOutDir: true,
    rollupOptions: {
      output: {
        // Use ES module format (WebView supports it)
        format: 'es',
        entryFileNames: 'editor.js',
        chunkFileNames: 'editor.js',
        assetFileNames: (assetInfo) => {
          if (assetInfo.name === 'index.css') {
            return 'editor.css';
          }
          return '[name][extname]';
        },
        // Force all code into a single bundle
        inlineDynamicImports: true,
        manualChunks: undefined,
      },
      // Ensure all dependencies are bundled
      external: [],
    },
    // Enable minification for production builds (better performance)
    // Use esbuild (default, faster than terser) with console removal
    minify: 'esbuild',
    // Note: esbuild doesn't support drop_console directly, but we handle it via
    // conditional logging in the code (window.BlockNoteDebugLogging checks)
    // Inline small assets
    assetsInlineLimit: 4096,
    // Increase chunk size warning limit since we're creating one big bundle
    chunkSizeWarningLimit: 5000,
  },
  base: './',
});
