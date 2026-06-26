local root_markers = { '.git' }
local editorInfo = { name = 'Neovim', version = tostring(vim.version()) }

return {
  cmd = { 'copilot-language-server', '--stdio' },
  filetypes = {
    'lua',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
  },
  init_options = { editorInfo = editorInfo, editorPluginInfo = editorInfo },
  root_dir = function(_bufnr, on_dir)
    local path = vim.fs.root(0, root_markers)

    if path ~= nil then
      on_dir(path)
    end
  end,
}
