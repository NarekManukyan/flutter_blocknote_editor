import React, { useRef, useState } from 'react';
import { BlockNoteView } from '@blocknote/mantine';
import '@blocknote/mantine/style.css';
import '@blocknote/core/fonts/inter.css';
import PropTypes from 'prop-types';
import { useBlockNoteEditor } from './hooks/useBlockNoteEditor';
import { useEditorReady } from './hooks/useEditorReady';
import { useFlutterMessages } from './hooks/useFlutterMessages';
import { useToolbarPopup } from './hooks/useToolbarPopup';
import { usePopupPortals } from './hooks/usePopupPortals';
import { buildFormattingToolbar } from './utils/toolbarBuilder.jsx';
import { buildSlashMenuItems } from './utils/slashMenuBuilder.jsx';
import { buildBlockNoteTheme } from './utils/themeBuilder';

class BlockNoteErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { error: null };
  }

  static getDerivedStateFromError(error) {
    return { error };
  }

  componentDidCatch(error) {
    console.error('[BlockNote] Error rendering BlockNoteView:', error);
  }

  render() {
    const { error } = this.state;
    if (!error) {
      return this.props.children;
    }

    return (
      <div
        style={{
          width: '100%',
          height: '100%',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          padding: '20px',
          color: 'red',
          backgroundColor: '#fff',
        }}
      >
        <div>
          <h2>Render Error</h2>
          <p>{error.message}</p>
          <pre style={{ fontSize: '12px', overflow: 'auto' }}>
            {error.stack}
          </pre>
        </div>
      </div>
    );
  }
}

BlockNoteErrorBoundary.propTypes = {
  children: PropTypes.node.isRequired,
};

function App() {
  const [error, setError] = useState(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isReadonly, setIsReadonly] = useState(false);
  const [theme, setTheme] = useState(null);
  const [toolbarConfig, setToolbarConfig] = useState(null);
  const [slashCommandConfig, setSlashCommandConfig] = useState(null);
  const documentVersionRef = useRef(0);
  const hasLoadedDocumentRef = useRef(false);
  const toolbarPopupCallbacksRef = useRef(new Map());

  // Initialize editor
  const editor = useBlockNoteEditor();

  // Handle editor ready state
  const isReady = useEditorReady(
    editor,
    documentVersionRef,
    setIsLoading,
    setError,
  );

  // Set up Flutter message handling
  useFlutterMessages(
    editor,
    setIsReadonly,
    setTheme,
    setToolbarConfig,
    setSlashCommandConfig,
    documentVersionRef,
    hasLoadedDocumentRef,
    toolbarPopupCallbacksRef,
  );

  // Set up toolbar popup interception
  useToolbarPopup(editor, isReady, toolbarPopupCallbacksRef);

  // Ensure popup portals can render correctly
  usePopupPortals();

  // Determine if we should use custom toolbar
  const useCustomToolbar =
    toolbarConfig && toolbarConfig.buttons && toolbarConfig.enabled !== false;
  const formattingToolbarComponent = useCustomToolbar
    ? buildFormattingToolbar(toolbarConfig)
    : null;

  // Determine if we should use custom slash menu
  const useCustomSlashMenu =
    slashCommandConfig &&
    slashCommandConfig.items &&
    slashCommandConfig.enabled !== false;
  const slashMenuComponent = useCustomSlashMenu
    ? buildSlashMenuItems(slashCommandConfig, editor)
    : null;

  if (error) {
    console.error('[BlockNote] App error:', error);
    return (
      <div
        style={{
          width: '100%',
          height: '100%',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          flexDirection: 'column',
          padding: '20px',
          color: 'red',
          backgroundColor: '#fff',
        }}
      >
        <h2>Error Loading Editor</h2>
        <p style={{ margin: '10px 0', wordBreak: 'break-word' }}>{error}</p>
        <button
          onClick={() => window.location.reload()}
          style={{ padding: '10px 20px', marginTop: '10px' }}
        >
          Reload
        </button>
      </div>
    );
  }

  if (isLoading || !editor) {
    console.log(
      '[BlockNote] Loading state - isLoading:',
      isLoading,
      'editor:',
      !!editor,
    );
    return (
      <div
        style={{
          width: '100%',
          height: '100%',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          backgroundColor: '#fff',
          color: '#333',
        }}
      >
        <div>Loading BlockNote editor...</div>
      </div>
    );
  }

  console.log('[BlockNote] Rendering BlockNoteView with editor:', !!editor);

  // Convert theme to BlockNote format if provided
  const blockNoteTheme = buildBlockNoteTheme(theme);

  return (
    <BlockNoteErrorBoundary>
      <div
        style={{
          width: '100%',
          height: '100%',
          position: 'relative',
          overflow: 'visible',
        }}
      >
        <BlockNoteView
          editor={editor}
          editable={!isReadonly}
          {...(blockNoteTheme ? { theme: blockNoteTheme } : {})}
          formattingToolbar={useCustomToolbar ? false : undefined}
          slashMenu={useCustomSlashMenu ? false : undefined}
        >
          {formattingToolbarComponent}
          {slashMenuComponent}
        </BlockNoteView>
      </div>
    </BlockNoteErrorBoundary>
  );
}

export default App;
