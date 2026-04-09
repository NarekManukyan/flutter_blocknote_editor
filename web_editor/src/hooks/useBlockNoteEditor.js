/**
 * Custom hook for BlockNote editor initialization and lifecycle.
 */

import { useCreateBlockNote } from '@blocknote/react';
import { useEffect, useMemo } from 'react';
import { buildSchemaFromConfig } from '../utils/schemaRegistry';
import { generateBlockId } from '../utils/idGenerator.js';

/**
 * Custom hook to initialize BlockNote editor and set up lifecycle.
 * @returns {Object} Editor instance
 */
export function useBlockNoteEditor(schemaConfig) {
  const schema = useMemo(
    () => buildSchemaFromConfig(schemaConfig),
    [schemaConfig],
  );

  // Stable initial content — UUID generated once, not on every render.
  const initialContent = useMemo(
    () => [
      {
        id: generateBlockId(),
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
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [],
  );

  const editor = useCreateBlockNote({
    schema,
    initialContent,
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
