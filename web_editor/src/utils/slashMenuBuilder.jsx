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
  if (!slashCommandConfig || !slashCommandConfig.items) {
    return null; // Use default items
  }

  const customItems = slashCommandConfig.items.map((item) => ({
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
  }));

  const allItems = [...getDefaultReactSlashMenuItems(editor), ...customItems];

  return (
    <SuggestionMenuController
      triggerCharacter={slashCommandConfig.triggerCharacter || '/'}
      getItems={async (query) => filterSuggestionItems(allItems, query)}
    />
  );
}
