/**
 * Document cleaning utilities.
 * Extracted from documentLoader to reduce complexity.
 */

/**
 * Normalize a styled text item into a plain text node.
 * @param {Object} item - Source item that may contain `text` and `styles`.
 * @returns {Object} An object with `type: 'text'`, a `text` string (empty if missing), and a `styles` object when `item.styles` is an object.
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
 * Normalize an inline content item into a consistent cleaned structure.
 *
 * @param {object} item - Inline content item; may be a text node, a link, or a custom inline type.
 * @param {function} cleanStyledTextFn - Function that accepts a styled text item and returns a cleaned text node.
 * @returns {object} Cleaned inline content:
 *  - For text: the cleaned text node returned by `cleanStyledTextFn`.
 *  - For link: `{ type: 'link', content: Array<cleanedTextNode>, href: string }`.
 *  - For other types: `{ type: string, content?: Array<cleanedTextNode>, props: object }`.
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
 * Normalize a tableContent object into a consistent rows/cells structure.
 * @param {Object} content - Source object that may contain a `rows` array.
 * @param {Function} cleanInlineContentFn - Function used to normalize each inline content item.
 * @returns {Object} An object with `type: 'tableContent'` and a `rows` array where each row has `cells`; each cell is an array of cleaned inline content items (non-array cells become empty arrays).
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
 * Produce a minimal default block object used when no block data is provided.
 * @returns {{id: string, type: string, content: Array, props: Object}} An object with:
 *  - `id`: a unique id prefixed with "block_" and the current timestamp,
 *  - `type`: the block type (`"paragraph"`),
 *  - `content`: an array containing a single empty text node `{ type: "text", text: "", styles: {} }`,
 *  - `props`: an empty object for block-specific properties.
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
 * Normalize a block object into a consistent cleaned structure.
 *
 * Ensures the returned block has an `id`, `type`, and `props`, preserves `children` when present,
 * and sets `content` to a cleaned representation using the provided helpers (array content is mapped
 * through `cleanInlineContentFn`; `tableContent` objects are processed by `cleanTableContentFn`).
 *
 * @param {Object|null|undefined} block - The block to normalize; if falsy a default block is returned.
 * @param {function(Object): Object} cleanInlineContentFn - Function that normalizes an inline content item.
 * @param {function(Object): Object} cleanTableContentFn - Function that normalizes a `tableContent` object.
 * @returns {Object} A cleaned block object with normalized `id`, `type`, `props`, optional `content`, and optional `children`.
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