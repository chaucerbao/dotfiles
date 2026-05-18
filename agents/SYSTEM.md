# Model Context Protocol (MCP)

Use the `mcporter` CLI to perform **all** MCP tasks

1. List servers with `mcporter list`
2. List server tools with `mcporter list <server>`
3. Call server tools with `mcporter call "<server>.<tool>([arguments])"`
   - Escape special characters in the shell command
   - Example: `mcporter call "my_server.my_tool(arg1: \"value1\", arg2: \"value2\")"`
