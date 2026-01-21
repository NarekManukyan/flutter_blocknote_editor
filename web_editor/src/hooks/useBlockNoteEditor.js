/**
 * Custom hook for BlockNote editor initialization and lifecycle.
 */

import { useCreateBlockNote } from '@blocknote/react';
import { useEffect, useMemo } from 'react';
import { buildSchemaFromConfig } from '../utils/schemaRegistry';

/**
 * Initialize a BlockNote editor instance using the provided schema configuration and expose it on window.editor while mounted.
 *
 * Exposes the created editor on `window.editor` for external (e.g., Flutter) access and removes that reference on cleanup.
 * @param {Object} schemaConfig - Configuration used to build the editor schema.
 * @returns {Object|undefined} The BlockNote editor instance, or `undefined` if the editor has not been created yet.
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