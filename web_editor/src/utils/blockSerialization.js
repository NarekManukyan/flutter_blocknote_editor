/**
 * Block serialization utilities.
 * Extracted from useEditorReady to reduce complexity.
 */

/**
 * Serializes styled text item.
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
 * Serializes inline content item.
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
 * Serializes table content.
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
 * Creates a serializeBlock function with proper dependencies.
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
