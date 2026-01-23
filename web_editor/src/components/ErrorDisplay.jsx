/**
 * Error display component.
 * Extracted from App.jsx to reduce complexity.
 */

import React from 'react';
import PropTypes from 'prop-types';

/**
 * Displays error message with reload button.
 */
export function ErrorDisplay({ error }) {
  return (
    <div
      style={{
        width: '100%',
        height: '100%',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        flexDirection: 'column',
        padding: '20px',
        color: 'red',
        backgroundColor: '#fff',
      }}
    >
      <h2>Error Loading Editor</h2>
      <p style={{ margin: '10px 0', wordBreak: 'break-word' }}>{error}</p>
      <button
        onClick={() => window.location.reload()}
        style={{ padding: '10px 20px', marginTop: '10px' }}
      >
        Reload
      </button>
    </div>
  );
}

ErrorDisplay.propTypes = {
  error: PropTypes.string.isRequired,
};
