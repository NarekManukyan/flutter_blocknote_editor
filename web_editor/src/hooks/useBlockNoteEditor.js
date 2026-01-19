/**
 * Custom hook for BlockNote editor initialization and lifecycle.
 */

import { useCreateBlockNote } from '@blocknote/react';
import { useEffect } from 'react';

/**
 * Custom hook to initialize BlockNote editor and set up lifecycle.
 * @returns {Object} Editor instance
 */
export function useBlockNoteEditor() {
  // BlockNote requires at least one block, so we provide a default paragraph
  const editor = useCreateBlockNote({
    initialContent: [
      {
        id: 'root',
        type: 'paragraph',
        content: [
          {
            type: 'text',
            text: '',
            styles: {},
          },
        ],
        props: {},
      },
    ],
  });

  // Expose editor globally for Flutter access
  useEffect(() => {
    if (editor) {
      window.editor = editor;
    }
    return () => {
      if (window.editor === editor) {
        delete window.editor;
      }
    };
  }, [editor]);

  return editor;
}
