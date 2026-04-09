/**
 * Slash menu building utility for BlockNote editor.
 * Builds custom slash menu from Flutter configuration.
 */

import {
  SuggestionMenuController,
  getDefaultReactSlashMenuItems,
} from '@blocknote/react';
import { filterSuggestionItems } from '@blocknote/core/extensions';

// ---------------------------------------------------------------------------
// Slash command handler registry
// ---------------------------------------------------------------------------

/**
 * Registry mapping command-id strings to handler functions.
 * Built-in handlers are registered below. Flutter-injected JS can register
 * additional handlers via window.registerSlashCommandHandler(id, fn).
 */
const slashCommandHandlerRegistry = new Map();

/**
 * Register a slash command handler by id.
 * @param {string} id - Command identifier sent as item.onItemClickId from Flutter.
 * @param {function} fn - Handler function receiving (editor).
 */
function registerSlashCommandHandler(id, fn) {
  if (typeof id !== 'string' || typeof fn !== 'function') {
    console.warn('[BlockNote] registerSlashCommandHandler: id must be string and fn must be function');
    return;
  }
  slashCommandHandlerRegistry.set(id, fn);
}

// Expose globally so Flutter-injected JS can register handlers at runtime.
window.registerSlashCommandHandler = registerSlashCommandHandler;

// --- Built-in handlers ---
registerSlashCommandHandler('heading1', (editor) => {
  editor.updateBlock(editor.getTextCursorPosition().block, { type: 'heading', props: { level: 1 } });
});
registerSlashCommandHandler('heading2', (editor) => {
  editor.updateBlock(editor.getTextCursorPosition().block, { type: 'heading', props: { level: 2 } });
});
registerSlashCommandHandler('heading3', (editor) => {
  editor.updateBlock(editor.getTextCursorPosition().block, { type: 'heading', props: { level: 3 } });
});
registerSlashCommandHandler('bulletListItem', (editor) => {
  editor.updateBlock(editor.getTextCursorPosition().block, { type: 'bulletListItem' });
});
registerSlashCommandHandler('numberedListItem', (editor) => {
  editor.updateBlock(editor.getTextCursorPosition().block, { type: 'numberedListItem' });
});
registerSlashCommandHandler('checkListItem', (editor) => {
  editor.updateBlock(editor.getTextCursorPosition().block, { type: 'checkListItem' });
});
registerSlashCommandHandler('paragraph', (editor) => {
  editor.updateBlock(editor.getTextCursorPosition().block, { type: 'paragraph' });
});

// ---------------------------------------------------------------------------
// SVG sanitizer
// ---------------------------------------------------------------------------

/**
 * Strip <script> tags and on* event-handler attributes from an SVG string.
 * @param {string} svgContent
 * @returns {string}
 */
function sanitizeSvgContent(svgContent) {
  if (typeof svgContent !== 'string') return '';
  // Remove <script>...</script> blocks (including multiline)
  let sanitized = svgContent.replace(/<script[\s\S]*?<\/script>/gi, '');
  // Remove on* event handler attributes (e.g. onclick="...", onerror='...')
  sanitized = sanitized.replace(/\bon\w+\s*=\s*(?:"[^"]*"|'[^']*'|[^\s>]*)/gi, '');
  return sanitized;
}

/** Match the default BlockNote icon size (18px) */
const SLASH_ICON_SIZE = 18;

/**
 * Renders a slash command icon from Flutter config.
 * All icons are wrapped in an SVG-sized container matching BlockNote's default
 * icon dimensions (18×18px) so they render consistently alongside default items.
 *
 * Supports: string (emoji/text), or object { type: 'text'|'svg'|'image', value|content|url }.
 * @param {string|object|null} itemIcon - Icon from item.icon
 * @returns {JSX.Element|undefined}
 */
function renderSlashCommandIcon(itemIcon) {
  if (itemIcon == null) return undefined;

  // Common wrapper style matching default icon sizing
  const wrapperStyle = {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    width: SLASH_ICON_SIZE,
    height: SLASH_ICON_SIZE,
    minWidth: SLASH_ICON_SIZE,
    minHeight: SLASH_ICON_SIZE,
    flexShrink: 0,
    fontSize: SLASH_ICON_SIZE,
    lineHeight: 1,
  };

  // Backward compat: plain string (emoji or text)
  if (typeof itemIcon === 'string') {
    return <div style={wrapperStyle}>{itemIcon}</div>;
  }
  if (typeof itemIcon !== 'object') return undefined;
  switch (itemIcon.type) {
    case 'text':
      return (
        <div style={wrapperStyle}>
          {itemIcon.value != null ? String(itemIcon.value) : ''}
        </div>
      );
    case 'svg':
      if (itemIcon.content == null) return undefined;
      return (
        <div
          className="bn-slash-icon-svg"
          style={wrapperStyle}
          dangerouslySetInnerHTML={{ __html: sanitizeSvgContent(itemIcon.content) }}
        />
      );
    case 'image':
      if (itemIcon.url == null) return undefined;
      return (
        <div style={wrapperStyle}>
          <img
            src={itemIcon.url}
            alt=""
            className="bn-slash-icon-image"
            style={{
              width: '100%',
              height: '100%',
              objectFit: 'contain',
              display: 'block',
            }}
          />
        </div>
      );
    default:
      return undefined;
  }
}

/**
 * Builds a custom slash menu component from slash command config.
 * @param {Object} slashCommandConfig - Slash command configuration from Flutter
 * @param {Object} editor - The BlockNote editor instance
 * @returns {JSX.Element|null} SuggestionMenuController component or null
 */
export function buildSlashMenuItems(slashCommandConfig, editor) {
  if (!slashCommandConfig) {
    return null; // Use default items
  }

  // Get default items
  const defaultItems = getDefaultReactSlashMenuItems(editor);

  // Filter default items based on availableSlashCommands whitelist if specified
  let filteredDefaultItems = defaultItems;
  if (
    slashCommandConfig.availableSlashCommands &&
    Array.isArray(slashCommandConfig.availableSlashCommands) &&
    slashCommandConfig.availableSlashCommands.length > 0
  ) {
    const availableTitles = new Set(
      slashCommandConfig.availableSlashCommands.map((cmd) =>
        typeof cmd === 'string' ? cmd : cmd.title ?? String(cmd),
      ),
    );
    filteredDefaultItems = defaultItems.filter((item) =>
      availableTitles.has(item.title),
    );
  }

  // Build custom items if provided
  const customItems =
    slashCommandConfig.items?.map((item) => ({
      title: item.title,
      onItemClick: () => {
        // Prefer id-based dispatch
        if (item.onItemClickId) {
          const handler = slashCommandHandlerRegistry.get(item.onItemClickId);
          if (handler) {
            try {
              handler(editor);
            } catch (error) {
              console.error('[BlockNote] Error executing slash command handler:', error);
            }
          } else {
            console.warn(`[BlockNote] No handler registered for slash command id: "${item.onItemClickId}"`);
          }
          return;
        }
        // Legacy: onItemClick as string — do NOT eval, just warn
        if (typeof item.onItemClick === 'string') {
          console.warn(
            '[BlockNote] item.onItemClick as a string is no longer supported. Use onItemClickId with a registered handler instead.',
          );
          return;
        }
      },
      subtext: item.subtext,
      badge: item.badge,
      aliases: item.aliases,
      group: item.group,
      icon: renderSlashCommandIcon(item.icon),
    })) || [];

  // Combine filtered default items with custom items
  const allItems = [...filteredDefaultItems, ...customItems];

  return (
    <SuggestionMenuController
      triggerCharacter={slashCommandConfig.triggerCharacter || '/'}
      getItems={async (query) => filterSuggestionItems(allItems, query)}
    />
  );
}
