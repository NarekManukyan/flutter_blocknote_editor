/// Shared collection equality and hashing utilities.
///
/// Extracted to avoid duplication across model files.
library;

/// Sentinel value for optional copyWith parameters.
const Object kUnset = Object();

/// Returns true if two nullable lists have the same length and equal elements.
bool listEquals<T>(List<T>? a, List<T>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null || a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// Returns true if two nullable maps have the same keys and equal values.
bool mapEquals<K, V>(Map<K, V>? a, Map<K, V>? b) {
  if (identical(a, b)) return true;
  if (a == null || b == null || a.length != b.length) return false;
  for (final entry in a.entries) {
    if (!b.containsKey(entry.key)) return false;
    if (b[entry.key] != entry.value) return false;
  }
  return true;
}

/// Returns a combined hash for a nullable list.
int listHash<T>(List<T>? list) {
  if (list == null) return 0;
  return Object.hashAll(list);
}

/// Returns a combined hash for a nullable map.
int mapHash<K, V>(Map<K, V>? map) {
  if (map == null) return 0;
  return Object.hashAll(
    map.entries.map((entry) => Object.hash(entry.key, entry.value)),
  );
}
