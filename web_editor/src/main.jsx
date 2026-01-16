import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';
import './index.css';

// Disable zoom gestures (pinch zoom, double-tap zoom)
(function() {
  // Disable pinch zoom
  document.addEventListener('touchstart', function(event) {
    if (event.touches.length > 1) {
      event.preventDefault();
    }
  }, { passive: false });
  
  // Disable double-tap zoom
  let lastTouchEnd = 0;
  document.addEventListener('touchend', function(event) {
    // Don't prevent default on toolbar buttons or interactive elements
    const target = event.target;
    if (target && (
      target.closest('.bn-toolbar') ||
      target.closest('[role="button"]') ||
      target.closest('button') ||
      target.closest('[data-ariakit-popover-disclosure]') ||
      target.closest('[data-radix-popover-trigger]')
    )) {
      // Allow toolbar button clicks to work normally
      return;
    }
    
    const now = Date.now();
    if (now - lastTouchEnd <= 300) {
      event.preventDefault();
    }
    lastTouchEnd = now;
  }, { passive: false });
  
  // Ensure viewport meta tag is set correctly
  let viewport = document.querySelector('meta[name="viewport"]');
  if (viewport) {
    viewport.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no');
  }
  
  console.log('[BlockNote] Zoom disabled');
})();

// Set up console channel to forward console messages to Flutter
(function() {
  // Override console.log, console.error, console.warn to send through the channel
  const originalLog = console.log;
  const originalError = console.error;
  const originalWarn = console.warn;
  
  console.log = function() {
    originalLog.apply(console, arguments);
    const args = Array.prototype.slice.call(arguments);
    const message = args.map(function(arg) {
      return typeof arg === 'object' ? JSON.stringify(arg) : String(arg);
    }).join(' ');
    if (window.flutterConsole && window.flutterConsole.postMessage) {
      window.flutterConsole.postMessage(message);
    }
  };
  
  console.error = function() {
    originalError.apply(console, arguments);
    const args = Array.prototype.slice.call(arguments);
    const message = args.map(function(arg) {
      return typeof arg === 'object' ? JSON.stringify(arg) : String(arg);
    }).join(' ');
    if (window.flutterConsole && window.flutterConsole.postMessage) {
      window.flutterConsole.postMessage('[ERROR] ' + message);
    }
  };
  
  console.warn = function() {
    originalWarn.apply(console, arguments);
    const args = Array.prototype.slice.call(arguments);
    const message = args.map(function(arg) {
      return typeof arg === 'object' ? JSON.stringify(arg) : String(arg);
    }).join(' ');
    if (window.flutterConsole && window.flutterConsole.postMessage) {
      window.flutterConsole.postMessage('[WARN] ' + message);
    }
  };
  
  console.log('[BlockNote] Console channel override installed');
})();

// Initialize message channel for Flutter communication
window.BlockNoteChannel = {
  postMessage: function(message) {
    try {
      if (window.onMessage) {
        window.onMessage.postMessage(message);
      } else {
        console.log('[BlockNote] Message (no channel):', message);
      }
    } catch (err) {
      console.error('[BlockNote] Error posting message:', err);
    }
  }
};

// Immediate logging to verify script execution
console.log('[BlockNote] Main script loaded');
console.log('[BlockNote] React available:', typeof React !== 'undefined');
console.log('[BlockNote] ReactDOM available:', typeof ReactDOM !== 'undefined');

// Send immediate test message to verify bridge works
if (window.BlockNoteChannel) {
  try {
    window.BlockNoteChannel.postMessage(JSON.stringify({
      type: 'test',
      data: { message: 'Main script executed successfully' }
    }));
    console.log('[BlockNote] Test message sent');
  } catch (e) {
    console.error('[BlockNote] Error sending test message:', e);
  }
} else {
  console.error('[BlockNote] BlockNoteChannel not available!');
}

// Set up global error handlers that use the bridge
// This ensures all errors go through BlockNoteChannel.postMessage()
window.addEventListener('error', function(event) {
  const errorMsg = event.error ? event.error.toString() : event.message;
  const errorObj = {
    type: 'error',
    data: {
      message: errorMsg
    }
  };
  if (window.BlockNoteChannel) {
    window.BlockNoteChannel.postMessage(JSON.stringify(errorObj));
  }
  console.error('[BlockNote] Error:', errorMsg);
});

window.addEventListener('unhandledrejection', function(event) {
  const reason = event.reason ? event.reason.toString() : 'Unknown';
  const errorObj = {
    type: 'error',
    data: {
      message: 'Unhandled Promise Rejection: ' + reason
    }
  };
  if (window.BlockNoteChannel) {
    window.BlockNoteChannel.postMessage(JSON.stringify(errorObj));
  }
  console.error('[BlockNote] Promise Rejection:', reason);
});

// Message handler from Flutter
window.handleFlutterMessage = function(messageData) {
  try {
    let message;
    // If it's already an object (from JSON.parse in Flutter), use it directly
    if (typeof messageData === 'object' && messageData !== null) {
      message = messageData;
    } else if (typeof messageData === 'string') {
      // If it's a string, parse it
      try {
        message = JSON.parse(messageData);
      } catch (parseError) {
        // If JSON.parse fails, try to handle escaped JSON strings
        // This can happen when Flutter sends a JSON string that contains another JSON string
        try {
          // Try parsing again after unescaping
          const unescaped = messageData.replace(/\\"/g, '"').replace(/\\'/g, "'");
          message = JSON.parse(unescaped);
        } catch (e2) {
          throw parseError; // Throw original error
        }
      }
    } else {
      message = messageData;
    }
    
    // Dispatch custom event for React components to listen to
    window.dispatchEvent(new CustomEvent('flutterMessage', { detail: message }));
  } catch (error) {
    console.error('[BlockNote] Failed to handle message:', error);
    window.BlockNoteChannel.postMessage(JSON.stringify({
      type: 'error',
      data: { message: 'Failed to handle message: ' + error.message }
    }));
  }
};

// Initialize React app with error handling
try {
  const rootElement = document.getElementById('root');
  if (!rootElement) {
    throw new Error('Root element not found');
  }
  
  const root = ReactDOM.createRoot(rootElement);
  root.render(
    <React.StrictMode>
      <App />
    </React.StrictMode>
  );
  
  console.log('[BlockNote] React app rendered successfully');
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
  
  if (window.BlockNoteChannel) {
    window.BlockNoteChannel.postMessage(JSON.stringify({
      type: 'error',
      data: { message: 'Failed to render React app: ' + (error.message || 'Unknown error') }
    }));
  }
}
