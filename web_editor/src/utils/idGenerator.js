/**
 * Generate a UUID v4 for use as a block id.
 * Uses crypto.randomUUID() when available (UUID v4), otherwise a RFC 4122 compliant UUID v4 fallback.
 *
 * @returns {string} A UUID v4 string (e.g. "550e8400-e29b-41d4-a716-446655440000").
 */
export function generateBlockId() {
  if (typeof crypto !== 'undefined' && crypto.randomUUID) {
    return crypto.randomUUID();
  }
  return uuidV4Fallback();
}

/**
 * RFC 4122 UUID v4 fallback when crypto.randomUUID is not available.
 * Uses crypto.getRandomValues for random bytes when available, else Math.random.
 *
 * @returns {string} A UUID v4 string.
 */
function uuidV4Fallback() {
  const bytes = new Array(16);
  if (typeof crypto !== 'undefined' && crypto.getRandomValues) {
    crypto.getRandomValues(bytes);
  } else {
    for (let i = 0; i < 16; i++) {
      bytes[i] = Math.floor(Math.random() * 256);
    }
  }
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  const hex = Array.from(bytes, (b) => b.toString(16).padStart(2, '0'));
  return [
    hex.slice(0, 4).join(''),
    hex.slice(4, 6).join(''),
    hex.slice(6, 8).join(''),
    hex.slice(8, 10).join(''),
    hex.slice(10, 16).join(''),
  ].join('-');
}
