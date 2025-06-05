return {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  root_markers = { 'tsconfig.json', 'jsconfig.json' },
  root_dir = function(_bufnr, on_dir)
    local path = vim.fs.root(0, { 'tsconfig.json', 'jsconfig.json' })

    if path ~= nil then
      on_dir(path)
    end
  end,
}
