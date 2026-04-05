import React, {
  useCallback,
  useEffect,
  useMemo,
  useReducer,
  useRef,
  useState,
} from 'react';
import { BlockNoteView } from '@blocknote/mantine';
import '@blocknote/mantine/style.css';
import '@blocknote/core/fonts/inter.css';
import { useBlockNoteEditor } from './hooks/useBlockNoteEditor';
import { useEditorReady } from './hooks/useEditorReady';
import { useFlutterMessages } from './hooks/useFlutterMessages';
import { useToolbarPopup } from './hooks/useToolbarPopup';
import { usePopupPortals } from './hooks/usePopupPortals';
import { useThemeBackground } from './hooks/useThemeBackground';
import { useLinkTapHandler } from './hooks/useLinkTapHandler';
import { loadDocument } from './utils/documentLoader';
import { buildFormattingToolbar } from './utils/toolbarBuilder.jsx';
import { buildSlashMenuItems } from './utils/slashMenuBuilder.jsx';
import { buildBlockNoteTheme } from './utils/themeBuilder';
import { ErrorDisplay } from './components/ErrorDisplay';

// --- Schema state reducer ---

const SCHEMA_ACTIONS = {
  SET_CONFIG: 'SET_CONFIG',
  SET_READY: 'SET_READY',
  SET_REQUIRED: 'SET_REQUIRED',
};

function schemaReducer(state, action) {
  switch (action.type) {
    case SCHEMA_ACTIONS.SET_CONFIG:
      return { ...state, config: action.payload };
    case SCHEMA_ACTIONS.SET_READY:
      return { ...state, ready: action.payload };
    case SCHEMA_ACTIONS.SET_REQUIRED:
      return { ...state, required: action.payload };
    default:
      return state;
  }
}

const initialSchemaState = { config: null, ready: false, required: true };

// --- Error Boundary ---

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
    if (!error) return this.props.children;

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

// --- Editor Host (manages editor instance lifecycle) ---

function EditorHost({ schemaConfig, onEditorChange }) {
  const editor = useBlockNoteEditor(schemaConfig);

  useEffect(() => {
    onEditorChange(editor);
    return () => onEditorChange(null);
  }, [editor, onEditorChange]);

  return null;
}

// --- Main App ---

function App() {
  const [error, setError] = useState(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isReadonly, setIsReadonly] = useState(false);
  const [theme, setTheme] = useState(null);
  const [toolbarConfig, setToolbarConfig] = useState(null);
  const [slashCommandConfig, setSlashCommandConfig] = useState(null);
  const [schema, dispatchSchema] = useReducer(schemaReducer, initialSchemaState);
  const [editor, setEditor] = useState(null);

  // Refs for mutable cross-hook state
  const refs = useRef({
    documentVersion: 0,
    hasLoadedDocument: false,
    toolbarPopupCallbacks: new Map(),
    pendingDocument: null,
    schemaChangePending: false,
  }).current;

  const shouldRenderEditor = schema.ready || !schema.required;

  const updateEditor = useCallback((nextEditor) => {
    setEditor(nextEditor ?? null);
  }, []);

  const allowMissingEditor = !shouldRenderEditor || !editor;

  const isReady = useEditorReady(
    editor,
    refs,
    setIsLoading,
    setError,
    allowMissingEditor,
  );

  useFlutterMessages(
    editor,
    { setIsReadonly, setTheme, setToolbarConfig, setSlashCommandConfig },
    { dispatchSchema, SCHEMA_ACTIONS },
    refs,
  );

  // Load pending document after editor + schema are ready
  useEffect(() => {
    if (!editor || !refs.pendingDocument) return;

    loadDocument(editor, refs.pendingDocument, refs);
    refs.pendingDocument = null;
    refs.schemaChangePending = false;
  }, [editor, refs]);

  useToolbarPopup(editor, isReady, refs.toolbarPopupCallbacks);
  usePopupPortals();
  useLinkTapHandler(editor);

  // Memoize toolbar component
  const useCustomToolbar =
    toolbarConfig?.buttons && toolbarConfig.enabled !== false;
  const formattingToolbarComponent = useMemo(
    () => (useCustomToolbar ? buildFormattingToolbar(toolbarConfig) : null),
    [useCustomToolbar, toolbarConfig],
  );

  // Memoize slash menu component
  const useCustomSlashMenu =
    slashCommandConfig?.enabled !== false &&
    (slashCommandConfig?.items ||
      slashCommandConfig?.availableSlashCommands?.length > 0);
  const slashMenuComponent = useMemo(
    () =>
      useCustomSlashMenu
        ? buildSlashMenuItems(slashCommandConfig, editor)
        : null,
    [useCustomSlashMenu, slashCommandConfig, editor],
  );

  // Cleanup editor when schema rendering changes
  useEffect(() => {
    if (!shouldRenderEditor) return;
    return () => updateEditor(null);
  }, [shouldRenderEditor, updateEditor]);

  const blockNoteTheme = useMemo(() => buildBlockNoteTheme(theme), [theme]);

  useThemeBackground(theme, blockNoteTheme);

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
            schemaConfig={schema.config}
            onEditorChange={updateEditor}
          />
        )}
        {error ? (
          <ErrorDisplay error={error} />
        ) : !shouldRenderEditor || isLoading || !editor ? null : (
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
        )}
      </div>
    </BlockNoteErrorBoundary>
  );
}

export default App;
