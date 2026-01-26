/**
 * Block serialization utilities.
 * Extracted from useEditorReady to reduce complexity.
 */

/**
 * Serialize a styled text item into a plain object.
 * @param {Object|null|undefined} item - The styled text item; may contain `text` and optional `styles`.
 * @returns {{type: 'text', text: string, styles?: Object}|null} An object with `type: 'text'`, a `text` string (defaults to empty string), and optional `styles`, or `null` if `item` is falsy.
 */
export function serializeStyledText(item) {
  if (!item) return null;
  const serialized = {
    type: 'text',
    text: item.text || '',
  };

  if (item.styles && typeof item.styles === 'object') {
    serialized.styles = item.styles;
  }

  return serialized;
}

/**
 * Serialize an inline content item into a normalized plain object.
 *
 * @param {object} item - The inline item to serialize; may be falsy.
 * @param {function(object):object|null} serializeStyledTextFn - Function that serializes styled text items.
 * @returns {object|null} A serialized inline item:
 *  - For `null`/`undefined` input: `null`.
 *  - For type `'text'`: the value returned by `serializeStyledTextFn`.
 *  - For type `'link'`: an object `{ type: 'link', content: Array, href: string }`.
 *  - For other types: an object `{ type: string, content?: Array, props: object }`.
 */
export function serializeInlineContent(item, serializeStyledTextFn) {
  if (!item) return null;
  const itemType = item.type || 'text';

  if (itemType === 'text') {
    return serializeStyledTextFn(item);
  }

  if (itemType === 'link') {
    const linkContent = Array.isArray(item.content)
      ? item.content
          .map((entry) => serializeStyledTextFn(entry))
          .filter(Boolean)
      : [];

    return {
      type: 'link',
      content: linkContent,
      href: item.href || '',
    };
  }

  const customContent = Array.isArray(item.content)
    ? item.content.map((entry) => serializeStyledTextFn(entry)).filter(Boolean)
    : null;

  return {
    type: itemType,
    ...(customContent ? { content: customContent } : {}),
    props: item.props && typeof item.props === 'object' ? item.props : {},
  };
}

/**
 * Serialize a tableContent-like object into a plain object containing serialized rows and cells.
 *
 * Normalizes missing or malformed rows/cells: rows defaults to an empty array, non-array cells become empty arrays,
 * and each cell's items are mapped through the provided inline-content serializer and filtered of falsy results.
 * @param {Object|null|undefined} tableContent - Object that may contain a `rows` array; each row may contain a `cells` array.
 * @param {Function} serializeInlineContentFn - Function that takes an inline content item and returns its serialized form.
 * @returns {Object} An object with `type: 'tableContent'` and a `rows` array where each row has a `cells` array of serialized inline content arrays.
 */
export function serializeTableContent(tableContent, serializeInlineContentFn) {
  const rows = Array.isArray(tableContent?.rows) ? tableContent.rows : [];
  return {
    type: 'tableContent',
    rows: rows.map((row) => {
      const cells = Array.isArray(row?.cells) ? row.cells : [];
      return {
        cells: cells.map((cell) => {
          if (!Array.isArray(cell)) return [];
          return cell
            .map((cellItem) => serializeInlineContentFn(cellItem))
            .filter(Boolean);
        }),
      };
    }),
  };
}

/**
 * Create a block serializer that uses the provided inline-content and table-content serializers.
 * @param {Function} serializeInlineContentFn - Function that serializes an inline content item into a plain object.
 * @param {Function} serializeTableContentFn - Function that serializes a tableContent object into a plain object.
 * @returns {Function} A function that takes a block node and returns a plain serialized object with keys: `id`, `type`, optional `content` (array or tableContent), optional `props` (object), and optional `children` (array). Returns `null` for falsy input.
 */
export function createSerializeBlock(
  serializeInlineContentFn,
  serializeTableContentFn,
) {
  const serializeBlockInner = (node) => {
    if (!node) return null;

    const serialized = {
      id: node.id,
      type: node.type,
    };

    if (node.content && Array.isArray(node.content)) {
      serialized.content = node.content
        .map((item) => serializeInlineContentFn(item))
        .filter(Boolean);
    } else if (
      node.content &&
      typeof node.content === 'object' &&
      node.content.type === 'tableContent'
    ) {
      serialized.content = serializeTableContentFn(node.content);
    }

    if (node.props && typeof node.props === 'object') {
      serialized.props = node.props;
    }

    if (
      node.children &&
      Array.isArray(node.children) &&
      node.children.length > 0
    ) {
      serialized.children = node.children
        .map((child) => serializeBlockInner(child))
        .filter(Boolean);
    }

    return serialized;
  };

  return (block) => serializeBlockInner(block);
}
