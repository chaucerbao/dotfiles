return {
  -- Global
  {
    prefix = 'lorem',
    body = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    desc = 'Placeholder Text',
  },
  { prefix = 'uuid', body = '$UUID', desc = 'UUIDv4' },

  -- Shelly Fences
  { prefix = '`g', body = '```global\n$0\n```', desc = 'Global Fence' },
  { prefix = '`h', body = '```http\n$0\n```', desc = 'HTTP Fence' },
  { prefix = '`j', body = '```javascript\n$0\n```', desc = 'JavaScript Fence' },
  { prefix = '`t', body = '```typescript\n$0\n```', desc = 'TypeScript Fence' },
  { prefix = '`r', body = '```redis\n$0\n```', desc = 'Redis Fence' },
  { prefix = '`s', body = '```sql\n$0\n```', desc = 'SQL Fence' },
}
