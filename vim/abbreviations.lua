vim.cmd([[
  function! EatSpace()
    let character = nr2char(getchar(0))
    return (character =~ '\s') ? '' : character
  endfunction
]])

local eat_space = '<C-r>=EatSpace()<CR>'

vim.cmd(
  'inoreabbrev lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
    .. eat_space
)

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('FileTypeAbbreviations', {}),
  pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  callback = function()
    vim.cmd('iabclear <buffer>')

    vim.cmd('inoreabbrev <buffer> //i // Imports<Esc>')
    vim.cmd('inoreabbrev <buffer> //t // Type Definitions<Esc>')
    vim.cmd('inoreabbrev <buffer> //c // Constants<Esc>')
    vim.cmd('inoreabbrev <buffer> //s // Styles<Esc>')
    vim.cmd('inoreabbrev <buffer> //h // Helpers<Esc>')
    vim.cmd('inoreabbrev <buffer> //e // Exports<Esc>')

    vim.cmd("inoreabbrev <buffer> im import {} from '+'<Esc>F+\"_s" .. eat_space)
    vim.cmd('inoreabbrev <buffer> log console.log(+)<Esc>F+"_s' .. eat_space)
    vim.cmd('inoreabbrev <buffer> jst JSON.stringify(+, null, 2)<Esc>F+"_s' .. eat_space)
    vim.cmd('inoreabbrev <buffer> iife ;(() => {+})()<Esc>F+"_s' .. eat_space)
    vim.cmd('inoreabbrev <buffer> aiife ;(async () => {+})()<Esc>F+"_s' .. eat_space)
  end,
})

vim.cmd('inoreabbrev ```g ```global<CR><CR>``<Up>' .. eat_space)
vim.cmd('inoreabbrev ```h ```http<CR><CR>``<Up>' .. eat_space)
vim.cmd('inoreabbrev ```j ```javascript<CR><CR>``<Up>' .. eat_space)
vim.cmd('inoreabbrev ```t ```typescript<CR><CR>``<Up>' .. eat_space)
vim.cmd('inoreabbrev ```r ```redis<CR><CR>``<Up>' .. eat_space)
vim.cmd('inoreabbrev ```s ```sql<CR><CR>``<Up>' .. eat_space)
