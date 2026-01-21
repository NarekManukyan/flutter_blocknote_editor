(function () {
  const { createReactBlockSpec, React, registerBlockNoteCustomBlocks } =
    window.BlockNoteCustomSchema;

  const AgendaItemBlock = createReactBlockSpec(
    {
      type: "agenda_item",
      content: "inline",
      propSchema: {
        title: { default: "" },
        content: { default: {} },
      },
    },
    {
      render: ({ block, contentRef, editor }) => {
        const content = block.props.content || {};
        const createdBy = content.created_by || {};
        const photo = createdBy.photo;
        const completed = Boolean(content.completed);
        const title = content.title || block.props.title || "Agenda Item";
        const applyContentRef = (node) => {
          if (typeof contentRef === "function") {
            contentRef(node);
          } else if (contentRef && typeof contentRef === "object") {
            contentRef.current = node;
          }
        };

        React.useEffect(() => {
          const inlineContent = Array.isArray(block.content)
            ? block.content
            : [];
          const hasInlineText = inlineContent.some(
            (node) =>
              node && typeof node.text === "string" && node.text.length > 0,
          );

          if (!hasInlineText && title && editor) {
            const updatedContent = [
              {
                type: "text",
                text: title,
                styles: {},
              },
            ];
            editor.updateBlock(block, { content: updatedContent });
          }
        }, [block, editor, title]);

        const titleStyle = {
          fontSize: "14px",
          fontWeight: 600,
          color: completed ? "#6b7280" : "#111827",
          textDecoration: completed ? "line-through" : "none",
        };

        const handleToggle = (event) => {
          const nextCompleted = event.target.checked;
          const updatedContent = {
            ...content,
            completed: nextCompleted,
          };

          const updateSelection = () => {
            if (typeof editor?.setTextCursorPosition === "function") {
              editor.setTextCursorPosition(block.id, "start");
            }
            if (typeof editor?.focus === "function") {
              editor.focus();
            }
          };

          if (editor) {
            if (typeof editor.transact === "function") {
              editor.transact(() => {
                editor.updateBlock(block, {
                  props: {
                    ...block.props,
                    content: updatedContent,
                  },
                });
                updateSelection();
              });
            } else {
              editor.updateBlock(block, {
                props: {
                  ...block.props,
                  content: updatedContent,
                },
              });
              updateSelection();
            }
          }
        };

        const stopPropagation = (event) => {
          event.stopPropagation();
        };

        const preventMouseDown = (event) => {
          event.stopPropagation();
          event.preventDefault();
        };

        return React.createElement(
          "div",
          {
            className: "agenda-item",
            onClick: () => {},
          },
          React.createElement(
            "div",
            {
              className: completed
                ? "agenda-item__status agenda-item__status--done"
                : "agenda-item__status",
            },
            React.createElement(
              "label",
              {
                className:
                  "checkbox-v2 checkbox-v2-lg checkbox-v2-prime mw-24-px mb-0",
                tabIndex: 0,
                onClick: stopPropagation,
                onMouseDown: preventMouseDown,
              },
              React.createElement("input", {
                type: "checkbox",
                checked: completed,
                onChange: handleToggle,
                onClick: stopPropagation,
                onMouseDown: preventMouseDown,
              }),
              React.createElement("span", {
                className: "checkmark rounded-v2-100p",
              }),
            ),
          ),
          React.createElement(
            "div",
            { className: "agenda-item__content" },
            React.createElement("div", {
              className: "agenda-item__title",
              style: titleStyle,
              ref: applyContentRef,
              "data-placeholder": title,
              onMouseDown: () => {
                const activeTag = document.activeElement
                  ? document.activeElement.tagName
                  : null;
                const selection = window.getSelection
                  ? window.getSelection()
                  : null;
                const anchorNodeName =
                  selection && selection.anchorNode
                    ? selection.anchorNode.nodeName
                    : null;
              },
            }),
          ),
          photo
            ? React.createElement("img", {
                src: photo,
                alt: "User",
                className: "agenda-item__avatar",
              })
            : null,
        );
      },
      toExternalHTML: ({ block }) => {
        const content = block.props.content || {};
        const inlineContent = Array.isArray(block.content) ? block.content : [];
        const inlineText = inlineContent
          .map((node) =>
            node && typeof node.text === "string" ? node.text : "",
          )
          .join("");
        const text = inlineText || content.title || block.props.title || "";
        return React.createElement(
          "div",
          { "data-block-type": block.type },
          text,
        );
      },
    },
  );

  registerBlockNoteCustomBlocks({
    agenda_item: AgendaItemBlock,
  });
})();
