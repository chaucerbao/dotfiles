## Hard Rules

1. Writes are confined to the current working directory (cwd). Nothing outside may be created, modified, or deleted — not via file tools, shell (redirects, cp/mv, sed -i, package installs), symlinks, or path tricks. Reads are unrestricted.
2. Temp files: `<cwd>/.tmp/` (create if needed).
3. Writing outside cwd: stop and ask; proceed only with the user's explicit approval of the specific target.