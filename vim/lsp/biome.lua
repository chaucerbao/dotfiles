local root_markers = { 'biome.json', 'biome.jsonc' }

return {
  cmd = { 'biome', 'lsp-proxy' },
  filetypes = {
    'css',
    'graphql',
    'html',
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'scss',
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
