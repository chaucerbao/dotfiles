local root_markers = { '.git' }

return {
  cmd = { 'efm-langserver' },
  filetypes = {
    'css',
    'graphql',
    'html',
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'lua',
    'markdown',
    'scss',
    'sh',
    'sql',
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
