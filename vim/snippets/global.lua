return {
  -- Global
  {
    prefix = 'lorem',
    body = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    desc = 'Placeholder Text',
  },
  { prefix = 'uuid', body = '$UUID', desc = 'UUIDv4' },

  -- Shelly Fences
  { prefix = '`global', body = '```global\n$0\n```', desc = 'Global Fence' },
  { prefix = '`http', body = '```http\n$0\n```', desc = 'HTTP Fence' },
  { prefix = '`json', body = '```json\n$0\n```', desc = 'JavaScript Fence' },
  { prefix = '`javascript', body = '```javascript\n$0\n```', desc = 'JavaScript Fence' },
  { prefix = '`typescript', body = '```typescript\n$0\n```', desc = 'TypeScript Fence' },
  { prefix = '`redis', body = '```redis\n$0\n```', desc = 'Redis Fence' },
  { prefix = '`sql', body = '```sql\n$0\n```', desc = 'SQL Fence' },
}
