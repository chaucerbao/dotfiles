-- Helpers
local g, opt = vim.g, vim.opt

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function termcode(code)
  return vim.api.nvim_replace_termcodes(code, true, true, true)
end

-- Bootstrap the Plugin Manager
local packer_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if (vim.fn.empty(vim.fn.glob(packer_path))) then
  vim.fn.system({ 'git', 'clone', 'https://github.com/wbthomason/packer.nvim', packer_path })
end

-- Define Plugins
require('packer').startup(function(use)
  -- Package Manager
  use 'wbthomason/packer.nvim'

  -- Color Scheme
  use 'arcticicestudio/nord-vim'

  -- General
  use {
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } },
    cmd = { 'Telescope' },
    config = function()
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<Esc>'] = 'close',
              ['<C-a>'] = { '<Home>', type = 'command' },
              ['<C-e>'] = { '<End>', type = 'command' }
            },
          }
        }
      }
    end,
  }
  use { 'tpope/vim-abolish', cmd = { 'S' }, keys = { 'cr' } }
  use { 'justinmk/vim-sneak', keys = { '<Plug>Sneak_s', '<Plug>Sneak_S', '<Plug>Sneak_f', '<Plug>Sneak_F', '<Plug>Sneak_t', '<Plug>Sneak_T' } }
  use { 'junegunn/vim-easy-align', keys = { '<Plug>(EasyAlign)' } }

  -- Programming
  use { 'neovim/nvim-lspconfig' }
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use { 'tpope/vim-commentary', keys = { 'gc' } }
  use { 'jiangmiao/auto-pairs' }
  use { 'machakann/vim-sandwich' }
  use { 'alvan/vim-closetag', ft = { 'html', 'javascriptreact', 'typescriptreact' } }
  use { 'AndrewRadev/splitjoin.vim', keys = { 'gJ', 'gS' } }
  use { 'tpope/vim-fugitive', cmd = { 'G', 'Git' } }
  use { 'tpope/vim-dadbod', ft = { 'sql' } }
  use { 'diepm/vim-rest-console', ft = { 'rest' } }

  -- Tools
  use { 'vimwiki/vimwiki', keys = { '<Plug>VimwikiIndex', '<Plug>VimwikiTabIndex' } }
end)

-- General Settings
vim.cmd('colorscheme nord')
g.mapleader = ' '
opt.joinspaces = false
opt.mouse = 'a'
opt.number = true
opt.spell = true

-- Characters
opt.list = true
opt.listchars = { tab = '»·', trail = '·', nbsp = '◡' }

-- Completion
opt.completeopt = { 'menuone', 'noselect' }
opt.wildmode = { 'longest:full', 'full' }

-- Folding
opt.foldenable = false
opt.foldmethod = 'indent'

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 0
opt.expandtab = true
opt.shiftround = true

-- Search and Replace
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = 'nosplit'

-- Wrapping
opt.breakindent = true
opt.wrap = false

-- Mappings
map('n', '<Space>', '<Nop>')
map('n', '<Leader>/', ':nohlsearch<CR>')
map('n', ';', ':')
map('v', ';', ':')

-- Tabs
map('n', '<Leader><Tab>', ':$tabnew<CR>')
map('n', 'g<Tab>', ':$tab split<CR>')

-- Windows
opt.splitbelow = true
opt.splitright = true

map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Buffers
opt.hidden = true
opt.confirm = true

map('n', '<S-Tab>', ':bprevious<CR>')
map('n', '<Tab>', ':bnext<CR>')

-- Yanking
vim.cmd([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * lua vim.highlight.on_yank()
  augroup END
]])

map('n', '<Leader>y', '"+y')
map('v', '<Leader>y', '"+y')
map('n', '<Leader>p', '"+p')
map('v', '<Leader>p', '"+p')
map('n', '<Leader>P', '"+P')
map('v', '<Leader>P', '"+P')

-- File Navigation
g.netrw_banner = false

vim.cmd([[
  augroup Netrw
    autocmd!
    autocmd FileType netrw nnoremap <buffer> <nowait> q :Rexplore<CR>
  augroup END
]])

map('n', '-', ':Explore<CR>')

-- Line Navigation
vim.cmd([[
  augroup CursorLine
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
  augroup END
]])

map('n', 'j', 'v:count > 0 ? "j" : "gj"', { expr = true })
map('n', 'k', 'v:count > 0 ? "k" : "gk"', { expr = true })

-- Status Line
function _G.cursor_mode()
  local mode = vim.api.nvim_get_mode().mode

  if (string.find(mode, '^n')) then return 'NORMAL'
  elseif (string.find(mode:lower(), '^v') or string.find(mode, '^')) then return 'VISUAL'
  elseif (string.find(mode:lower(), '^s') or string.find(mode, '^')) then return 'SELECT'
  elseif (string.find(mode, '^i')) then return 'INSERT'
  elseif (string.find(mode, '^R')) then return 'REPLACE'
  elseif (string.find(mode, '^c')) then return 'COMMAND'
  elseif (string.find(mode, '^r')) then return 'PROMPT'
  elseif (string.find(mode, '^!')) then return 'SHELL'
  elseif (string.find(mode, '^t')) then return 'TERMINAL'
  else return mode
  end
end

opt.statusline = ' %{v:lua.cursor_mode()} 〉%t%( 〉%R%)%( 〉%M%)%=%(%{&filetype}%)〈 %l:%c〈 %p%% '

-- Telescope
map('n', '<Leader>b', ':Telescope buffers<CR>')
map('n', '<Leader>f', ':Telescope find_files<CR>')
map('n', '<Leader>g', ':Telescope live_grep<CR>')

-- Sneak
g['sneak#label'] = 1
g['sneak#s_next'] = 1

map('n', 's', '<Plug>Sneak_s', { noremap = false })
map('n', 'S', '<Plug>Sneak_S', { noremap = false })
map('n', 'f', '<Plug>Sneak_f', { noremap = false })
map('n', 'F', '<Plug>Sneak_F', { noremap = false })
map('n', 't', '<Plug>Sneak_t', { noremap = false })
map('n', 'T', '<Plug>Sneak_T', { noremap = false })

-- EasyAlign
map('n', 'ga', '<Plug>(EasyAlign)', { noremap = false })
map('v', 'ga', '<Plug>(EasyAlign)', { noremap = false })

-- Language Server Protocol (LSP)
local function on_attach(_, bufnr)
  local function set_buf_keymap(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then options = vim.tbl_extend('force', options, opts) end

    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, options)
  end

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  set_buf_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
  set_buf_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.references()<CR>')
  set_buf_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
  set_buf_keymap('n', '<F2>', '<Cmd>lua vim.lsp.buf.rename()<CR>')
  set_buf_keymap('n', '<Leader>gq', '<Cmd>lua vim.lsp.buf.formatting()<CR>')
  set_buf_keymap('n', '<Leader><CR>', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
end

local lspconfig = require('lspconfig')
local lsp_servers = { 'tsserver' }
for _, lsp_server in ipairs(lsp_servers) do
  lspconfig[lsp_server].setup {
    on_attach = on_attach,
    flags = { debounce_text_changes = 200 }
  }
end

local diagnostic_symbols = { Error = '✖', Warning = '⚠', Hint = '﹖', Information = 'ℹ' }
for level, symbol in pairs(diagnostic_symbols) do
  local hl = "LspDiagnosticsSign" .. level
  vim.fn.sign_define(hl, { text = symbol, texthl = hl, numhl = "" })
end

-- Auto Pairs
g.AutoPairsMultilineClose = 0

-- Sandwich
vim.cmd('runtime macros/sandwich/keymap/surround.vim')

-- Close Tags
g.closetag_filetypes = 'html,javascriptreact,typescriptreact'

-- Dadbod
vim.cmd([[
  augroup Dadbod
    autocmd!
    autocmd FileType sql nnoremap <buffer> <CR> :%DB<CR>
    autocmd FileType sql vnoremap <buffer> <CR> :DB<CR>
  augroup END
]])

-- REST Console
g.vrc_curl_opts = {
  ['--include'] = '',
  ['--location'] = '',
  ['--show-error'] = '',
  ['--silent'] = ''
}

-- VimWiki
map('n', '<Leader>ww', '<Plug>VimwikiIndex', { noremap = false })
map('n', '<Leader>wt', '<Plug>VimwikiTabIndex', { noremap = false })
