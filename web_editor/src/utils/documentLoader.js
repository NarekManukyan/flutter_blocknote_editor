/**
 * Document loading utility for BlockNote editor.
 * Handles loading and cleaning document data from Flutter.
 */

/**
 * Loads a document into the BlockNote editor.
 * @param {Object} editor - The BlockNote editor instance
 * @param {Object|string} documentData - Document data (object or JSON string)
 * @param {Object} documentVersionRef - Ref object to track document version
 * @param {Object} hasLoadedDocumentRef - Ref object to track if document was loaded
 */
export function loadDocument(
  editor,
  documentData,
  documentVersionRef,
  hasLoadedDocumentRef,
) {
  try {
    if (!editor) {
      window.BlockNoteChannel.postMessage(
        JSON.stringify({
          type: 'error',
          data: { message: 'Editor not initialized' },
        }),
      );
      return;
    }

    console.log('[BlockNote] loadDocument called with:', documentData);

    const doc =
      typeof documentData === 'string'
        ? JSON.parse(documentData)
        : documentData;

    console.log('[BlockNote] Parsed document:', doc);
    console.log('[BlockNote] Document blocks:', doc.blocks);
    console.log('[BlockNote] Document version:', doc.version);

    if (!doc) {
      throw new Error('Document data is null or undefined');
    }

    if (doc.blocks && Array.isArray(doc.blocks)) {
      const cleanStyledText = (item) => {
        const cleaned = {
          type: 'text',
          text: item?.text || '',
        };
        if (item?.styles && typeof item.styles === 'object') {
          cleaned.styles = item.styles;
        }
        return cleaned;
      };

      const cleanInlineContent = (item) => {
        const itemType = item?.type || 'text';

        if (itemType === 'text') {
          return cleanStyledText(item);
        }

        if (itemType === 'link') {
          const linkContent = Array.isArray(item?.content)
            ? item.content.map((entry) => cleanStyledText(entry))
            : [];
          return {
            type: 'link',
            content: linkContent,
            href: item?.href || '',
          };
        }

        const customContent = Array.isArray(item?.content)
          ? item.content.map((entry) => cleanStyledText(entry))
          : null;

        return {
          type: itemType,
          ...(customContent ? { content: customContent } : {}),
          props:
            item?.props && typeof item.props === 'object' ? item.props : {},
        };
      };

      const cleanTableContent = (content) => {
        const rows = Array.isArray(content?.rows) ? content.rows : [];
        return {
          type: 'tableContent',
          rows: rows.map((row) => {
            const cells = Array.isArray(row?.cells) ? row.cells : [];
            return {
              cells: cells.map((cell) => {
                if (!Array.isArray(cell)) return [];
                return cell.map((cellItem) => cleanInlineContent(cellItem));
              }),
            };
          }),
        };
      };

      // Ensure blocks array is not empty and has valid structure
      if (doc.blocks.length === 0) {
        console.warn('[BlockNote] Empty blocks array, using default block');
        doc.blocks = [
          {
            id: 'root',
            type: 'paragraph',
            content: [{ type: 'text', text: '', styles: {} }],
            props: {},
          },
        ];
      }

      // Clean up blocks - remove null/undefined values and ensure required fields
      const cleanedBlocks = doc.blocks.map((block) => {
        if (!block) {
          return {
            id: 'block_' + Date.now(),
            type: 'paragraph',
            content: [{ type: 'text', text: '', styles: {} }],
            props: {},
          };
        }

        let cleanedContent = null;

        if (Array.isArray(block.content)) {
          cleanedContent = block.content
            .filter(Boolean)
            .map((item) => cleanInlineContent(item));
        } else if (
          block.content &&
          typeof block.content === 'object' &&
          block.content.type === 'tableContent'
        ) {
          cleanedContent = cleanTableContent(block.content);
        }

        // Build cleaned block
        const cleanedBlock = {
          id: block.id || 'block_' + Date.now(),
          type: block.type || 'paragraph',
          props:
            block.props && typeof block.props === 'object' ? block.props : {},
        };

        if (cleanedContent != null) {
          cleanedBlock.content = cleanedContent;
        }

        // Only include children if it's not null/undefined
        if (block.children != null) {
          cleanedBlock.children = block.children;
        }

        return cleanedBlock;
      });

      console.log('[BlockNote] Cleaning blocks, count:', cleanedBlocks.length);
      console.log('[BlockNote] First block:', cleanedBlocks[0]);

      // Use BlockNote's replaceBlocks method
      if (editor.replaceBlocks) {
        const currentBlocks = editor.topLevelBlocks || [];
        console.log('[BlockNote] Current blocks count:', currentBlocks.length);
        editor.replaceBlocks(currentBlocks, cleanedBlocks);
        console.log('[BlockNote] Blocks replaced successfully');
      } else {
        console.warn(
          '[BlockNote] replaceBlocks not available, trying alternative method',
        );
        if (editor.blocks) {
          editor.blocks = cleanedBlocks;
        }
      }

      // Handle version safely
      if (doc.version) {
        if (
          typeof doc.version === 'object' &&
          doc.version.major !== undefined
        ) {
          documentVersionRef.current = doc.version.major;
        } else if (typeof doc.version === 'number') {
          documentVersionRef.current = doc.version;
        }
      }

      hasLoadedDocumentRef.current = true;

      // Reset previous blocks reference after document load
      // This ensures the next change only sends incremental updates
      if (
        window.resetPreviousBlocks &&
        typeof window.resetPreviousBlocks === 'function'
      ) {
        // Use a small delay to ensure editor state has updated
        setTimeout(() => {
          window.resetPreviousBlocks();
        }, 100);
      }

      console.log('[BlockNote] Document loaded successfully');
    } else {
      throw new Error('Invalid document format: blocks must be an array');
    }
  } catch (error) {
    console.error('[BlockNote] Error in loadDocument:', error);
    console.error('[BlockNote] Error stack:', error.stack);
    window.BlockNoteChannel.postMessage(
      JSON.stringify({
        type: 'error',
        data: { message: 'Failed to load document: ' + error.message },
      }),
    );
  }
}
