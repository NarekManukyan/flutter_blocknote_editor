import React from 'react';
import { BlockNoteSchema } from '@blocknote/core';
import { createReactBlockSpec } from '@blocknote/react';

const registry = {
  blockSpecs: new Map(),
  inlineContentSpecs: new Map(),
  styleSpecs: new Map(),
};

const registerSpecs = (targetMap, specs, kind) => {
  if (!specs || typeof specs !== 'object') {
    return;
  }

  Object.entries(specs).forEach(([key, spec]) => {
    if (!key || !spec) {
      return;
    }

    let normalizedSpec = spec;
    if (typeof spec === 'function') {
      try {
        normalizedSpec = spec();
      } catch {
        normalizedSpec = spec;
      }
    }

    if (targetMap.has(key)) {
      console.warn(
        `[BlockNote] Overriding custom ${kind} spec for type: ${key}`,
      );
    }

    targetMap.set(key, normalizedSpec);
  });
};

export const registerBlockNoteCustomSchema = (specs = {}) => {
  registerSpecs(registry.blockSpecs, specs.blockSpecs, 'block');
  registerSpecs(
    registry.inlineContentSpecs,
    specs.inlineContentSpecs,
    'inline',
  );
  registerSpecs(registry.styleSpecs, specs.styleSpecs, 'style');
};

export const registerBlockNoteCustomBlocks = (blockSpecs = {}) => {
  registerBlockNoteCustomSchema({ blockSpecs });
};

const buildSpecsFromConfig = (schemaConfig, key, specsMap) => {
  if (!specsMap || specsMap.size === 0) {
    return {};
  }

  const configValue = schemaConfig?.[key];
  if (Array.isArray(configValue)) {
    const allowedTypes = new Set(configValue);
    return Object.fromEntries(
      [...specsMap.entries()].filter(([type]) => allowedTypes.has(type)),
    );
  }

  if (configValue && typeof configValue === 'object') {
    const enabledTypes = Object.entries(configValue)
      .filter(([, enabled]) => Boolean(enabled))
      .map(([type]) => type);
    const allowedTypes = new Set(enabledTypes);
    return Object.fromEntries(
      [...specsMap.entries()].filter(([type]) => allowedTypes.has(type)),
    );
  }

  return Object.fromEntries(specsMap.entries());
};

export const buildSchemaFromConfig = (schemaConfig) => {
  const schema = BlockNoteSchema.create();

  const blockSpecs = buildSpecsFromConfig(
    schemaConfig,
    'blockSpecs',
    registry.blockSpecs,
  );
  const inlineContentSpecs = buildSpecsFromConfig(
    schemaConfig,
    'inlineContentSpecs',
    registry.inlineContentSpecs,
  );
  const styleSpecs = buildSpecsFromConfig(
    schemaConfig,
    'styleSpecs',
    registry.styleSpecs,
  );

  const hasCustomSpecs =
    Object.keys(blockSpecs).length > 0 ||
    Object.keys(inlineContentSpecs).length > 0 ||
    Object.keys(styleSpecs).length > 0;

  return hasCustomSpecs
    ? schema.extend({
        blockSpecs,
        inlineContentSpecs,
        styleSpecs,
      })
    : schema;
};

if (typeof window !== 'undefined') {
  window.registerBlockNoteCustomBlocks = registerBlockNoteCustomBlocks;
  window.registerBlockNoteCustomSchema = registerBlockNoteCustomSchema;
  window.BlockNoteCustomSchema = {
    registerBlockNoteCustomBlocks,
    registerBlockNoteCustomSchema,
    createReactBlockSpec,
    React,
  };
}
