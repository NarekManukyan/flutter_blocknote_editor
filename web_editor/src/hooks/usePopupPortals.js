/**
 * Custom hook for ensuring popup portals render correctly.
 */

import { useEffect } from 'react';

/**
 * Custom hook to ensure popup portals can render correctly.
 * This ensures body allows popups to render and handles visibility.
 */
export function usePopupPortals() {
  useEffect(() => {
    // Ensure body allows popups to render
    if (document.body) {
      const bodyStyle = window.getComputedStyle(document.body);
      if (bodyStyle.overflow === 'hidden') {
        document.body.style.overflow = 'visible';
      }

      const htmlStyle = window.getComputedStyle(document.documentElement);
      if (htmlStyle.overflow === 'hidden') {
        document.documentElement.style.overflow = 'visible';
      }
    }

    // Simple MutationObserver to just ensure popups are visible when created
    const observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        mutation.addedNodes.forEach((node) => {
          if (node.nodeType === 1) {
            const element = node;
            const isPopup =
              element.classList?.contains('mantine-Menu-dropdown') ||
              element.classList?.contains('mantine-Popover-dropdown') ||
              element.classList?.contains('bn-select');

            const isFlutterHidden =
              element.getAttribute('data-bn-flutter-hidden') === 'true';
            if (isPopup && !isFlutterHidden) {
              // Just ensure basic visibility - let Mantine handle the rest
              requestAnimationFrame(() => {
                if (document.body.contains(element)) {
                  element.style.zIndex = '10002';
                  element.style.isolation = 'isolate';
                  element.removeAttribute('hidden');
                }
              });
            }

            // Check children too
            if (element.querySelectorAll) {
              element
                .querySelectorAll(
                  '.mantine-Menu-dropdown, .mantine-Popover-dropdown',
                )
                .forEach((child) => {
                  const isChildFlutterHidden =
                    child.getAttribute('data-bn-flutter-hidden') === 'true';
                  if (isChildFlutterHidden) {
                    return;
                  }
                  requestAnimationFrame(() => {
                    if (document.body.contains(child)) {
                      child.style.zIndex = '10002';
                      child.style.isolation = 'isolate';
                      child.removeAttribute('hidden');
                    }
                  });
                });
            }
          }
        });
      });
    });

    observer.observe(document.body, { childList: true, subtree: true });

    return () => {
      observer.disconnect();
    };
  }, []);
}
