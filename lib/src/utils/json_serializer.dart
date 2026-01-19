/// JSON serialization utilities for BlockNote models.
///
/// This file provides consistent JSON encoding/decoding with proper
/// error handling for malformed JSON and type conversion utilities.
library;

import 'dart:convert';
import 'package:flutter/foundation.dart';

/// JSON serialization utilities.
class JsonSerializer {
  /// Safely encodes an object to JSON string.
  ///
  /// Returns null if encoding fails, with optional error logging.
  static String? encode(dynamic value, {bool debugLogging = false}) {
    try {
      return jsonEncode(value);
    } catch (e) {
      if (debugLogging) {
        debugPrint('[JsonSerializer] Encoding error: $e');
      }
      return null;
    }
  }

  /// Safely decodes a JSON string to an object.
  ///
  /// Returns null if decoding fails, with optional error logging.
  static dynamic decode(String jsonString, {bool debugLogging = false}) {
    try {
      return jsonDecode(jsonString);
    } catch (e) {
      if (debugLogging) {
        debugPrint('[JsonSerializer] Decoding error: $e');
      }
      return null;
    }
  }

  /// Safely decodes a JSON string to a Map.
  ///
  /// Returns null if decoding fails or result is not a Map.
  static Map<String, dynamic>? decodeMap(
    String jsonString, {
    bool debugLogging = false,
  }) {
    final decoded = decode(jsonString, debugLogging: debugLogging);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return null;
  }

  /// Safely decodes a JSON string to a List.
  ///
  /// Returns null if decoding fails or result is not a List.
  static List<dynamic>? decodeList(
    String jsonString, {
    bool debugLogging = false,
  }) {
    final decoded = decode(jsonString, debugLogging: debugLogging);
    if (decoded is List) {
      return decoded;
    }
    return null;
  }
}
