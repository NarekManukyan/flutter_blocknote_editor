/**
 * Slash menu building utility for BlockNote editor.
 * Builds custom slash menu from Flutter configuration.
 */

import {
  SuggestionMenuController,
  getDefaultReactSlashMenuItems,
} from '@blocknote/react';
import { filterSuggestionItems } from '@blocknote/core/extensions';

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
      icon: item.icon ? <span>{item.icon}</span> : undefined,
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
