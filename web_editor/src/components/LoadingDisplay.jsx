/**
 * Loading display component.
 * Extracted from App.jsx to reduce complexity.
 */

import React from 'react';

/**
 * Displays loading message.
 */
export function LoadingDisplay() {
  return (
    <div
      style={{
        width: '100%',
        height: '100%',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: '#fff',
        color: '#333',
      }}
    >
      <div>Loading BlockNote editor...</div>
    </div>
  );
}
