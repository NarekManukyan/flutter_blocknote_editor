import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import { visualizer } from 'rollup-plugin-visualizer';

export default defineConfig({
  plugins: [
    react({
      jsxRuntime: 'automatic',
    }),
    visualizer({
      filename: 'stats.html',
      gzipSize: true,
      brotliSize: true,
      template: 'treemap',
    }),
  ],
  build: {
    outDir: '../assets/web',
    emptyOutDir: true,
    rollupOptions: {
      output: {
        format: 'es',
        entryFileNames: 'editor.js',
        chunkFileNames: 'editor.js',
        assetFileNames: (assetInfo) => {
          if (assetInfo.name === 'index.css') {
            return 'editor.css';
          }
          return '[name][extname]';
        },
        inlineDynamicImports: true,
        manualChunks: undefined,
      },
      external: [],
    },
    minify: 'terser',
    terserOptions: {
      compress: {
        passes: 2,
        drop_console: true,
        drop_debugger: true,
        pure_funcs: ['console.log', 'console.debug', 'console.info'],
      },
      mangle: { toplevel: true },
      format: { comments: false },
    },
    assetsInlineLimit: 4096,
    chunkSizeWarningLimit: 5000,
  },
  base: './',
  test: {
    environment: 'jsdom',
    include: ['src/**/*.test.js'],
    globals: false,
  },
});
