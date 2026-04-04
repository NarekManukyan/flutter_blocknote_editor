/**
 * Document loading utility for BlockNote editor.
 * Handles loading and cleaning document data from Flutter.
 */

import {
  cleanStyledText,
  cleanInlineContent,
  cleanTableContent,
  cleanBlock,
} from './documentCleaner';
import { generateBlockId } from './idGenerator.js';
import { sendErrorToFlutter, debugLog } from './flutterBridge';

const cleanInlineContentFn = (item) => cleanInlineContent(item, cleanStyledText);
const cleanTableContentFn = (content) => cleanTableContent(content, cleanInlineContentFn);

/**
 * Loads a document into the BlockNote editor.
 * @param {Object} editor - The BlockNote editor instance
 * @param {Object|string} documentData - Document data (object or JSON string)
 * @param {Object} refs - Shared mutable refs with documentVersion, hasLoadedDocument
 */
export function loadDocument(editor, documentData, refs) {
  try {
    if (!editor) {
      sendErrorToFlutter('Editor not initialized');
      return;
    }

    debugLog('loadDocument called with:', documentData);

    const doc =
      typeof documentData === 'string'
        ? JSON.parse(documentData)
        : documentData;

    if (!doc) {
      throw new Error('Document data is null or undefined');
    }

    if (!doc.blocks || !Array.isArray(doc.blocks)) {
      throw new Error('Invalid document format: blocks must be an array');
    }

    // Ensure blocks array is not empty
    if (doc.blocks.length === 0) {
      console.warn('[BlockNote] Empty blocks array, using default block');
      doc.blocks = [
        {
          id: generateBlockId(),
          type: 'paragraph',
          content: [{ type: 'text', text: '', styles: {} }],
          props: {},
        },
      ];
    }

    const cleanedBlocks = doc.blocks.map((block) =>
      cleanBlock(block, cleanInlineContentFn, cleanTableContentFn),
    );

    debugLog('Cleaning blocks, count:', cleanedBlocks.length);

    // Replace blocks in the editor
    if (editor.replaceBlocks) {
      const currentBlocks = editor.topLevelBlocks || [];
      editor.replaceBlocks(currentBlocks, cleanedBlocks);
    } else {
      console.warn('[BlockNote] replaceBlocks not available, trying alternative');
      if (editor.blocks) {
        editor.blocks = cleanedBlocks;
      }
    }

    // Handle version safely
    if (doc.version) {
      if (typeof doc.version === 'object' && doc.version.major !== undefined) {
        refs.documentVersion = doc.version.major;
      } else if (typeof doc.version === 'number') {
        refs.documentVersion = doc.version;
      }
    }

    refs.hasLoadedDocument = true;

    // Reset diff baseline after document load
    if (typeof window.resetPreviousBlocks === 'function') {
      setTimeout(() => window.resetPreviousBlocks(), 100);
    }

    debugLog('Document loaded successfully');
  } catch (error) {
    console.error('[BlockNote] Error in loadDocument:', error);
    sendErrorToFlutter('Failed to load document: ' + error.message);
  }
}
