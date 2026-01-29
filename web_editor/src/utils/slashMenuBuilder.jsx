/**
 * Slash menu building utility for BlockNote editor.
 * Builds custom slash menu from Flutter configuration.
 */

import {
  SuggestionMenuController,
  getDefaultReactSlashMenuItems,
} from '@blocknote/react';
import { filterSuggestionItems } from '@blocknote/core/extensions';

const SLASH_ICON_SIZE = '1em';

/**
 * Renders a slash command icon from Flutter config.
 * Supports: string (emoji/text), or object { type: 'text'|'svg'|'image', value|content|url }.
 * @param {string|object|null} itemIcon - Icon from item.icon
 * @returns {JSX.Element|undefined}
 */
function renderSlashCommandIcon(itemIcon) {
  if (itemIcon == null) return undefined;
  // Backward compat: plain string (emoji or text)
  if (typeof itemIcon === 'string') {
    return <span>{itemIcon}</span>;
  }
  if (typeof itemIcon !== 'object') return undefined;
  switch (itemIcon.type) {
    case 'text':
      return (
        <span>{itemIcon.value != null ? String(itemIcon.value) : ''}</span>
      );
    case 'svg':
      if (itemIcon.content == null) return undefined;
      return (
        <div
          className="bn-slash-icon-svg"
          style={{
            display: 'inline-flex',
            width: SLASH_ICON_SIZE,
            height: SLASH_ICON_SIZE,
            minWidth: SLASH_ICON_SIZE,
            minHeight: SLASH_ICON_SIZE,
            alignItems: 'center',
            justifyContent: 'center',
            flexShrink: 0,
          }}
          dangerouslySetInnerHTML={{ __html: itemIcon.content }}
        />
      );
    case 'image':
      if (itemIcon.url == null) return undefined;
      return (
        <img
          src={itemIcon.url}
          alt=""
          className="bn-slash-icon-image"
          style={{
            width: SLASH_ICON_SIZE,
            height: SLASH_ICON_SIZE,
            objectFit: 'contain',
          }}
        />
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
        typeof cmd === 'string' ? cmd : cmd,
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
        try {
          const handler = new Function('editor', item.onItemClick);
          handler(editor);
        } catch (error) {
          console.error('[BlockNote] Error executing slash command:', error);
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
