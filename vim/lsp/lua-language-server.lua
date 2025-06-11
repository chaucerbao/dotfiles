local root_markers = { '.luarc.json', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml' }

return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_dir = function(_bufnr, on_dir)
    local path = vim.fs.root(0, root_markers)

    if path ~= nil then
      on_dir(path)
    end
  end,
}
