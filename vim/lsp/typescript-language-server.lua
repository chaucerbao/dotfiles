local root_markers = { 'jsconfig.json', 'tsconfig.json' }

return {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_dir = function(_bufnr, on_dir)
    local path = vim.fs.root(0, root_markers)

    if path ~= nil then
      on_dir(path)
    end
  end,
}
