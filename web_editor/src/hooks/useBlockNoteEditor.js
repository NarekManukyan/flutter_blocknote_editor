/**
 * Custom hook for BlockNote editor initialization and lifecycle.
 */

import { useCreateBlockNote } from '@blocknote/react';
import { useEffect, useMemo } from 'react';
import { buildSchemaFromConfig } from '../utils/schemaRegistry';

/**
 * Custom hook to initialize BlockNote editor and set up lifecycle.
 * @returns {Object} Editor instance
 */
export function useBlockNoteEditor(schemaConfig) {
  const schema = useMemo(
    () => buildSchemaFromConfig(schemaConfig),
    [schemaConfig],
  );

  const editor = useCreateBlockNote({
    schema,
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
