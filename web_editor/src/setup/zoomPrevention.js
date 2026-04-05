/**
 * Disable zoom gestures (pinch zoom, double-tap zoom) for WebView.
 * Called once during app initialization.
 */

const INTERACTIVE_SELECTORS = [
  '.bn-toolbar',
  '[role="button"]',
  'button',
  '[data-ariakit-popover-disclosure]',
  '[data-radix-popover-trigger]',
];

/**
 * Returns true if the target element is inside an interactive toolbar area.
 * @param {EventTarget} target
 * @returns {boolean}
 */
function isToolbarInteraction(target) {
  return (
    target &&
    INTERACTIVE_SELECTORS.some((selector) => target.closest?.(selector))
  );
}

export function disableZoomGestures() {
  // Disable pinch zoom
  document.addEventListener(
    'touchstart',
    (event) => {
      if (event.touches.length > 1) {
        event.preventDefault();
      }
    },
    { passive: false },
  );

  // Disable double-tap zoom
  let lastTouchEnd = 0;
  document.addEventListener(
    'touchend',
    (event) => {
      if (isToolbarInteraction(event.target)) return;

      const now = Date.now();
      if (now - lastTouchEnd <= 300) {
        event.preventDefault();
      }
      lastTouchEnd = now;
    },
    { passive: false },
  );

  // Ensure viewport meta tag is set correctly
  const viewport = document.querySelector('meta[name="viewport"]');
  if (viewport) {
    viewport.setAttribute(
      'content',
      'width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no',
    );
  }
}
