---
name: mcporter
description: Use for every MCP task, before native MCP tools. Calls MCP server tools with the `mcporter` CLI.
---

# MCPorter

## 1. Find the server and the tool

```bash
mcporter list <server> --brief
```

- A tool list: find the tool. Follow the `Instructions:` that the server prints. If they end with `…`, read the full `instructions` field from `mcporter list <server>.<tool> --json`.
- `Unknown MCP server`: find the name with `mcporter config list`. If no server matches, tell the user.
- `Tools: <unavailable>` with `mcporter auth`: stop. Ask the user to run `! mcporter auth <server>`.

## 2. Always read the tool parameters

```bash
mcporter list <server>.<tool> --all-parameters
```

If a parameter type is `unknown`, add `--schema`.

## 3. Call the tool

Send the arguments as JSON in a quoted heredoc. The shell does not change its content, so `'`, `"`, `$`, and backticks are safe. Do not use other argument syntaxes. For multi-line text, write the text to a file and add `key=@<absolute path>`.

```bash
mcporter call linear.save_issue description=@/abs/path/description.md --args - <<'EOF'
{"team": "INT", "title": "It's a \"bug\"", "labels": ["needs-triage"]}
EOF
```