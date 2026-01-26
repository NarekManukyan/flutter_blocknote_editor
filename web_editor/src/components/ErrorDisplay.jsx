/**
 * Error display component.
 * Extracted from App.jsx to reduce complexity.
 */

import React from 'react';
import PropTypes from 'prop-types';

/**
 * Render a full-page error view showing a message and a reload control.
 *
 * The displayed message is the provided `error` string. Activating the "Reload"
 * button will reload the current page.
 *
 * @param {Object} props
 * @param {string} props.error - Error message to display.
 * @returns {JSX.Element} The rendered error view.
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
