local root_markers = { '.oxlintrc.json', '.oxlintrc.jsonc', 'oxlint.config.ts', 'oxlint.config.mts' }

return {
  cmd = { 'oxlint', '--lsp' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
  root_dir = function(_bufnr, on_dir)
    local path = vim.fs.root(0, root_markers)

    if path ~= nil then
      on_dir(path)
    end
  end,
}
