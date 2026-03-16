#!/usr/bin/env node
/**
 * Extract image URLs from YouMind getChat API response (stdin).
 * Writes results as JSON to stdout.
 */
let data = '';
process.stdin.on('data', chunk => data += chunk);
process.stdin.on('end', () => {
  const chat = JSON.parse(data);
  const status = chat.status || 'unknown';
  let imageUrls = [];

  // Strategy 1: Extract from message blocks (structured)
  const messages = (chat.messages || []).filter(m => m.role === 'assistant');
  for (const msg of messages) {
    const blocks = msg.blocks || [];
    for (const block of blocks) {
      if (block.type === 'tool' && block.tool_result && Array.isArray(block.tool_result.image_urls)) {
        imageUrls.push(...block.tool_result.image_urls);
      }
    }
  }

  // Strategy 2: Fallback to regex from content
  if (imageUrls.length === 0) {
    for (const msg of messages) {
      const content = msg.content || '';
      const matches = content.match(/https?:\/\/[^\s)"]+\.(?:png|jpg|jpeg|webp|gif)[^\s)"]*/gi) || [];
      imageUrls.push(...matches);
    }
  }

  // Deduplicate
  imageUrls = [...new Set(imageUrls)];

  console.log(JSON.stringify({ status, imageUrls, count: imageUrls.length }));
});
