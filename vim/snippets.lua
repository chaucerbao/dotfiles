-- Helpers
vim.cmd([[lua
\ eat_space = function()
\   local char = vim.fn.nr2char(vim.fn.getchar(0))
\   return string.find(char, '%s') and '' or char
\ end
]])

local function create_snippet(expansion)
  return expansion .. (string.find(expansion, '|') and '<C-[>F|"_s' or '') .. '<C-r>=luaeval("eat_space()")<CR>'
end

-- Global
vim.cmd.inoreabbrev(
  'lorem',
  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.<C-[>'
)

-- FileTypes
local group = vim.api.nvim_create_augroup('AbbreviationSnippets', {})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = group,
  pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  callback = function()
    vim.cmd.inoreabbrev('<buffer>', '//i', '// Imports<C-[>')
    vim.cmd.inoreabbrev('<buffer>', '//t', '// Type Definitions<C-[>')
    vim.cmd.inoreabbrev('<buffer>', '//c', '// Constants<C-[>')
    vim.cmd.inoreabbrev('<buffer>', '//h', '// Helpers<C-[>')
    vim.cmd.inoreabbrev('<buffer>', '//e', '// Exports<C-[>')

    vim.cmd.inoreabbrev('<buffer>', 'clg', create_snippet('console.log({ | })'))
    vim.cmd.inoreabbrev('<buffer>', 'clgj', create_snippet('console.log(JSON.stringify(|, null, 2))'))
    vim.cmd.inoreabbrev('<buffer>', 'im', create_snippet("import {} from '|'"))
  end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = group,
  pattern = { 'html', 'javascriptreact', 'typescriptreact' },
  callback = function() vim.cmd.inoreabbrev('<buffer>', 'tb', create_snippet('target="_blank" rel="noreferrer"')) end,
})
