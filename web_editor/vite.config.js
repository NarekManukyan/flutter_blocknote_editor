import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
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
    // Don't minify to help with debugging
    minify: false,
    // Inline small assets
    assetsInlineLimit: 4096,
    // Increase chunk size warning limit since we're creating one big bundle
    chunkSizeWarningLimit: 2000,
  },
  base: './',
});
