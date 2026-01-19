/**
 * Constant map of all available toolbar popup options.
 * This replaces dynamic DOM extraction for better reliability and maintainability.
 * Icons are optional and can be used by Flutter to display icons in the modal.
 */
export const TOOLBAR_POPUP_OPTIONS = {
  /**
   * Block type select options.
   * These match the actual BlockNote toolbar menu items.
   * Icons are BlockNote icon names that can be used by Flutter.
   */
  blockTypeSelect: [
    { value: 'paragraph', label: 'Paragraph', id: 'paragraph' },
    {
      value: JSON.stringify({ type: 'heading', props: { level: 1 } }),
      label: 'Heading 1',
      id: 'heading_1',
    },
    {
      value: JSON.stringify({ type: 'heading', props: { level: 2 } }),
      label: 'Heading 2',
      id: 'heading_2',
    },
    {
      value: JSON.stringify({ type: 'heading', props: { level: 3 } }),
      label: 'Heading 3',
      id: 'heading_3',
    },
    {
      value: JSON.stringify({ type: 'heading', props: { level: 1 } }),
      label: 'Toggle Heading 1',
      id: 'toggle_heading_1',
    },
    {
      value: JSON.stringify({ type: 'heading', props: { level: 2 } }),
      label: 'Toggle Heading 2',
      id: 'toggle_heading_2',
    },
    {
      value: JSON.stringify({ type: 'heading', props: { level: 3 } }),
      label: 'Toggle Heading 3',
      id: 'toggle_heading_3',
    },
    { value: 'quote', label: 'Quote', id: 'quote' },
    { value: 'toggleListItem', label: 'Toggle List', id: 'toggle_list' },
    { value: 'bulletListItem', label: 'Bullet List', id: 'bullet_list' },
    { value: 'numberedListItem', label: 'Numbered List', id: 'numbered_list' },
    { value: 'checkListItem', label: 'Check List', id: 'check_list' },
  ],

  /**
   * Color style options.
   * These match the default BlockNote color styles.
   * Icons can be color swatches or color names.
   */
  colorStyle: [
    { value: 'default', label: 'Default', id: 'default' },
    { value: 'gray', label: 'Gray', id: 'gray' },
    { value: 'brown', label: 'Brown', id: 'brown' },
    { value: 'red', label: 'Red', id: 'red' },
    { value: 'orange', label: 'Orange', id: 'orange' },
    { value: 'yellow', label: 'Yellow', id: 'yellow' },
    { value: 'green', label: 'Green', id: 'green' },
    { value: 'blue', label: 'Blue', id: 'blue' },
    { value: 'purple', label: 'Purple', id: 'purple' },
    { value: 'pink', label: 'Pink', id: 'pink' },
  ],
};
