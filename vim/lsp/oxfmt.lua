local root_markers = { '.oxfmtrc.json', '.oxfmtrc.jsonc', 'oxfmt.config.ts', 'oxfmt.config.mts' }

return {
  cmd = { 'oxfmt', '--lsp' },
  filetypes = {
    'css',
    'graphql',
    'html',
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'markdown',
    'scss',
    'toml',
    'typescript',
    'typescriptreact',
    'yaml',
  },
  root_dir = function(_bufnr, on_dir)
    local path = vim.fs.root(0, root_markers)

    if path ~= nil then
      on_dir(path)
    end
  end,
}
