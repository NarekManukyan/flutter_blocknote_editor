/**
 * Toolbar building utility for BlockNote editor.
 * Builds custom formatting toolbar from Flutter configuration.
 */

import {
  BasicTextStyleButton,
  BlockTypeSelect,
  ColorStyleButton,
  CreateLinkButton,
  FileCaptionButton,
  FileReplaceButton,
  FormattingToolbar,
  FormattingToolbarController,
  NestBlockButton,
  TextAlignButton,
  UnnestBlockButton,
} from '@blocknote/react';

/**
 * Builds a custom formatting toolbar component from toolbar config.
 * @param {Object} toolbarConfig - Toolbar configuration from Flutter
 * @returns {JSX.Element|null} FormattingToolbarController component or null
 */
export function buildFormattingToolbar(toolbarConfig) {
  if (!toolbarConfig || !toolbarConfig.buttons) {
    return null; // Use default toolbar
  }

  const buttons = toolbarConfig.buttons
    .map((buttonConfig) => {
      switch (buttonConfig.type) {
        case 'blockTypeSelect':
          return <BlockTypeSelect key={buttonConfig.key} />;
        case 'fileCaptionButton':
          return <FileCaptionButton key={buttonConfig.key} />;
        case 'fileReplaceButton':
          return <FileReplaceButton key={buttonConfig.key} />;
        case 'basicTextStyleButton':
          return (
            <BasicTextStyleButton
              key={buttonConfig.key}
              basicTextStyle={buttonConfig.basicTextStyle}
            />
          );
        case 'textAlignButton':
          return (
            <TextAlignButton
              key={buttonConfig.key}
              textAlignment={buttonConfig.textAlignment}
            />
          );
        case 'colorStyleButton':
          return <ColorStyleButton key={buttonConfig.key} />;
        case 'nestBlockButton':
          return <NestBlockButton key={buttonConfig.key} />;
        case 'unnestBlockButton':
          return <UnnestBlockButton key={buttonConfig.key} />;
        case 'createLinkButton':
          return <CreateLinkButton key={buttonConfig.key} />;
        default:
          return null;
      }
    })
    .filter(Boolean);

  // FormattingToolbarController needs to be a child of BlockNoteView
  // to have access to the editor context for popups
  return (
    <FormattingToolbarController
      formattingToolbar={() => <FormattingToolbar>{buttons}</FormattingToolbar>}
    />
  );
}
