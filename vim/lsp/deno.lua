local root_markers = { 'deno.json', 'deno.jsonc' }

return {
  cmd = { 'deno', 'lsp' },
  filetypes = {
    'css',
    'html',
    'javascript',
    'javascriptreact',
    'json',
    'jsonc',
    'markdown',
    'scss',
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
