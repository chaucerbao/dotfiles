# MCPorter Usage

## Typical Flow

1. `mcporter list` — available servers.
2. `mcporter list <server>` — tools and params, with docs; `--schema` for full JSON schemas (enum values, defaults, constraints).
3. `mcporter call <server.tool> <args>` — args in one of the forms below.

## Call Syntax Reference

Shell rules (all forms): double quotes expand `$`, `$(...)`, backticks before MCPorter sees them; single quotes are literal (insert a `'` with `'a''\''b'`).

- **Flag-based** — `key=value` pairs; for multi-line or quoting-hostile values use `key=@path` (reads the file verbatim; `@@` for a literal leading `@`).
  ```bash
  mcporter call database.execute_sql sql="select 'it''s ok'"   # $/backticks in this layer would expand!
  mcporter call linear.create_comment issueId=LNR-123 body=@comment.md
  ```
- **Function-call** — `'server.tool(name: "value")'`, as printed in `mcporter list` examples. In-string escapes: `\n`, `\'`, `\"` — raw newlines and doubled `""` don't parse (multi-line = `\n`). Values heavy in `'`: use the flag form's `@path` or the JSON form's heredoc instead.
  ```bash
  mcporter call 'database.execute_sql(sql: "select '\''q'\'' as v")'  # ' in value: '\'' shell concatenation
  mcporter call 'linear.create_comment(issueId: "LNR-123", body: "a\nb")'
  ```
- **JSON** — `--args '{"k": "v"}'`; `-` reads the payload from stdin. Use when the payload already exists as JSON or for deep nesting; raw newlines in strings are invalid — use `\n`.
  ```bash
  mcporter call database.execute_sql --args - <<'EOF'   # quoted heredoc: dodges all nesting
  {"sql": "select 'x' as v"}
  EOF
  ```

## Config

`mcporter config list` shows each server's source and the project/system config file paths.