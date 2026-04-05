import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './index.css';

import { disableZoomGestures } from './setup/zoomPrevention';
import { setupConsoleOverrides } from './setup/consoleOverride';
import {
  initBlockNoteChannel,
  initFlutterMessageHandler,
  initGlobalErrorHandlers,
} from './setup/flutterChannel';
import { sendToFlutter, sendErrorToFlutter } from './utils/flutterBridge';

// --- Initialization sequence ---

disableZoomGestures();
setupConsoleOverrides();
initBlockNoteChannel();
initGlobalErrorHandlers();
initFlutterMessageHandler();

// Verify bridge works with a test message
sendToFlutter('test', { data: { message: 'Main script executed successfully' } });

// --- Render React app ---

try {
  const rootElement = document.getElementById('root');
  if (!rootElement) {
    throw new Error('Root element not found');
  }

  const root = ReactDOM.createRoot(rootElement);
  const isDevelopment = window.BlockNoteDebugLogging === true;

  root.render(
    isDevelopment ? (
      <React.StrictMode>
        <App />
      </React.StrictMode>
    ) : (
      <App />
    ),
  );
} catch (error) {
  console.error('[BlockNote] Failed to render React app:', error);

  const rootElement = document.getElementById('root');
  if (rootElement) {
    rootElement.innerHTML = `
      <div style="padding: 20px; color: red;">
        <h2>Failed to Load Editor</h2>
        <p>Error: ${error.message || 'Unknown error'}</p>
        <pre>${error.stack || ''}</pre>
      </div>
    `;
  }

  sendErrorToFlutter(
    'Failed to render React app: ' + (error.message || 'Unknown error'),
  );
}
