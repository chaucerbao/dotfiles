return {
  cmd = { 'deno', 'lsp' },
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  root_markers = { 'deno.json', 'deno.jsonc' },
  root_dir = function(_bufnr, on_dir)
    local path = vim.fs.root(0, { 'deno.json', 'deno.jsonc' })

    if path ~= nil then
      on_dir(path)
    end
  end,
}
