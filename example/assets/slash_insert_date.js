// Slash command handler: inserts current date as a paragraph.
// Runs with `editor` in scope (same as inline onItemClick).
const d = new Date();
const text = d.toLocaleDateString(undefined, {
  weekday: 'short',
  year: 'numeric',
  month: 'short',
  day: 'numeric',
});
editor.insertBlocks(
  [
    {
      type: 'paragraph',
      content: [{ type: 'text', text: text }],
    },
  ],
  editor.getTextCursorPosition().block,
  'after'
);
