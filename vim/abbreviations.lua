vim.cmd(
  'inoreabbrev lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.'
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

    vim.cmd("inoreabbrev <buffer> im import {} from '+'<Esc>F+s")
    vim.cmd('inoreabbrev <buffer> clg console.log(+)<Esc>F+s')
    vim.cmd('inoreabbrev <buffer> clgs console.log(JSON.stringify(+, null, 2))<Esc>F+s')
    vim.cmd('inoreabbrev <buffer> iife ;(() => {+})()<Esc>F+s')
    vim.cmd('inoreabbrev <buffer> aiife ;(async () => {+})()<Esc>F+s')
  end,
})
