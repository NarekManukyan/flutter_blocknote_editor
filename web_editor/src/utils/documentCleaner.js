/**
 * Document cleaning utilities.
 * Extracted from documentLoader to reduce complexity.
 */

/**
 * Cleans styled text item.
 */
export function cleanStyledText(item) {
  const cleaned = {
    type: 'text',
    text: item?.text || '',
  };
  if (item?.styles && typeof item.styles === 'object') {
    cleaned.styles = item.styles;
  }
  return cleaned;
}

/**
 * Cleans inline content item.
 */
export function cleanInlineContent(item, cleanStyledTextFn) {
  const itemType = item?.type || 'text';

  if (itemType === 'text') {
    return cleanStyledTextFn(item);
  }

  if (itemType === 'link') {
    const linkContent = Array.isArray(item?.content)
      ? item.content.map((entry) => cleanStyledTextFn(entry))
      : [];
    return {
      type: 'link',
      content: linkContent,
      href: item?.href || '',
    };
  }

  const customContent = Array.isArray(item?.content)
    ? item.content.map((entry) => cleanStyledTextFn(entry))
    : null;

  return {
    type: itemType,
    ...(customContent ? { content: customContent } : {}),
    props: item?.props && typeof item.props === 'object' ? item.props : {},
  };
}

/**
 * Cleans table content.
 */
export function cleanTableContent(content, cleanInlineContentFn) {
  const rows = Array.isArray(content?.rows) ? content.rows : [];
  return {
    type: 'tableContent',
    rows: rows.map((row) => {
      const cells = Array.isArray(row?.cells) ? row.cells : [];
      return {
        cells: cells.map((cell) => {
          if (!Array.isArray(cell)) return [];
          return cell.map((cellItem) => cleanInlineContentFn(cellItem));
        }),
      };
    }),
  };
}

/**
 * Creates a default block.
 */
export function createDefaultBlock() {
  return {
    id: 'block_' + Date.now(),
    type: 'paragraph',
    content: [{ type: 'text', text: '', styles: {} }],
    props: {},
  };
}

/**
 * Cleans a single block.
 */
export function cleanBlock(block, cleanInlineContentFn, cleanTableContentFn) {
  if (!block) {
    return createDefaultBlock();
  }

  let cleanedContent = null;

  if (Array.isArray(block.content)) {
    cleanedContent = block.content
      .filter(Boolean)
      .map((item) => cleanInlineContentFn(item));
  } else if (
    block.content &&
    typeof block.content === 'object' &&
    block.content.type === 'tableContent'
  ) {
    cleanedContent = cleanTableContentFn(block.content);
  }

  const cleanedBlock = {
    id: block.id || 'block_' + Date.now(),
    type: block.type || 'paragraph',
    props: block.props && typeof block.props === 'object' ? block.props : {},
  };

  if (cleanedContent != null) {
    cleanedBlock.content = cleanedContent;
  }

  if (block.children != null) {
    cleanedBlock.children = block.children;
  }

  return cleanedBlock;
}
