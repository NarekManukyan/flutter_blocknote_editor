import React, { useEffect, useMemo, useRef, useState } from 'react';
import { BlockNoteView } from '@blocknote/mantine';
import '@blocknote/mantine/style.css';
import '@blocknote/core/fonts/inter.css';
import PropTypes from 'prop-types';
import { useBlockNoteEditor } from './hooks/useBlockNoteEditor';
import { useEditorReady } from './hooks/useEditorReady';
import { useFlutterMessages } from './hooks/useFlutterMessages';
import { useToolbarPopup } from './hooks/useToolbarPopup';
import { usePopupPortals } from './hooks/usePopupPortals';
import { loadDocument } from './utils/documentLoader';
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

/**
 * Creates a BlockNote editor instance from a schema configuration and forwards the instance to a parent via callback.
 *
 * Calls `onEditorChange` with the created editor when available and calls `onEditorChange(null)` on cleanup or when the editor changes.
 *
 * @param {Object|null} schemaConfig - Configuration object used to initialize the BlockNote editor; may be null to indicate no schema.
 * @param {(editor: Object|null) => void} onEditorChange - Callback invoked with the editor instance or `null` when the editor is disposed or unavailable.
 */
function EditorHost({ schemaConfig, onEditorChange }) {
  const editor = useBlockNoteEditor(schemaConfig);

  useEffect(() => {
    onEditorChange(editor);
    return () => {
      onEditorChange(null);
    };
  }, [editor, onEditorChange]);

  return null;
}

EditorHost.propTypes = {
  schemaConfig: PropTypes.object,
  onEditorChange: PropTypes.func.isRequired,
};

/**
 * Top-level React component that initializes and coordinates the BlockNote editor, its configuration, and related UI states.
 *
 * Manages editor lifecycle and readiness, applies theme and custom toolbar/slash-menu configurations, handles incoming messages
 * (e.g., from Flutter) and document loading, and renders the editor or appropriate loading/error UI.
 *
 * @returns {JSX.Element} The root UI element containing the BlockNote editor, or a loading/error view when applicable.
 */
function App() {
  const [error, setError] = useState(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isReadonly, setIsReadonly] = useState(false);
  const [theme, setTheme] = useState(null);
  const [toolbarConfig, setToolbarConfig] = useState(null);
  const [slashCommandConfig, setSlashCommandConfig] = useState(null);
  const [schemaConfig, setSchemaConfig] = useState(null);
  const [schemaConfigReady, setSchemaConfigReady] = useState(false);
  const [schemaConfigRequired, setSchemaConfigRequired] = useState(true);
  const [editor, setEditor] = useState(null);
  const documentVersionRef = useRef(0);
  const hasLoadedDocumentRef = useRef(false);
  const toolbarPopupCallbacksRef = useRef(new Map());
  const pendingDocumentRef = useRef(null);
  const schemaChangePendingRef = useRef(false);

  const shouldRenderEditor = useMemo(
    () => schemaConfigReady || !schemaConfigRequired,
    [schemaConfigReady, schemaConfigRequired],
  );

  const updateEditor = (nextEditor) => {
    setEditor(nextEditor ?? null);
  };

  const allowMissingEditor = !shouldRenderEditor || !editor;

  // Handle editor ready state
  const isReady = useEditorReady(
    editor,
    documentVersionRef,
    setIsLoading,
    setError,
    allowMissingEditor,
  );

  // Set up Flutter message handling
  useFlutterMessages(
    editor,
    setIsReadonly,
    setTheme,
    setToolbarConfig,
    setSlashCommandConfig,
    setSchemaConfig,
    setSchemaConfigReady,
    setSchemaConfigRequired,
    documentVersionRef,
    hasLoadedDocumentRef,
    toolbarPopupCallbacksRef,
    pendingDocumentRef,
    schemaChangePendingRef,
  );

  useEffect(() => {
    if (!editor || !pendingDocumentRef.current) {
      return;
    }

    loadDocument(
      editor,
      pendingDocumentRef.current,
      documentVersionRef,
      hasLoadedDocumentRef,
    );
    pendingDocumentRef.current = null;
    schemaChangePendingRef.current = false;
  }, [editor, documentVersionRef, hasLoadedDocumentRef]);

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

  useEffect(() => {
    if (!shouldRenderEditor) {
      return;
    }
    return () => {
      updateEditor(null);
    };
  }, [shouldRenderEditor]);

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
        {shouldRenderEditor && (
          <EditorHost
            schemaConfig={schemaConfig}
            onEditorChange={updateEditor}
          />
        )}
        {error ? (
          <>
            {(() => {
              console.error('[BlockNote] App error:', error);
              return null;
            })()}
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
              <p style={{ margin: '10px 0', wordBreak: 'break-word' }}>
                {error}
              </p>
              <button
                onClick={() => window.location.reload()}
                style={{ padding: '10px 20px', marginTop: '10px' }}
              >
                Reload
              </button>
            </div>
          </>
        ) : !shouldRenderEditor || isLoading || !editor ? (
          <>
            {(() => {
              console.log(
                '[BlockNote] Loading state - isLoading:',
                isLoading,
                'editor:',
                !!editor,
              );
              return null;
            })()}
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
          </>
        ) : (
          <>
            {(() => {
              console.log(
                '[BlockNote] Rendering BlockNoteView with editor:',
                !!editor,
              );
              return null;
            })()}
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
          </>
        )}
      </div>
    </BlockNoteErrorBoundary>
  );
}

export default App;