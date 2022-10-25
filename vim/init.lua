-- General
vim.opt.confirm = true
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.spell = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.list = true
vim.opt.listchars = { tab = '»·', trail = '·', nbsp = '◡' }
vim.opt.diffopt:append({ 'algorithm:patience', 'vertical' })

-- Completion
vim.opt.complete:remove({ 't' })
vim.opt.completeopt = { 'menuone', 'noselect' }
vim.opt.wildmode = { 'longest:full', 'full' }

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 0
vim.opt.shiftround = true
vim.opt.expandtab = true

-- Folding
vim.opt.foldenable = false
vim.opt.foldmethod = 'indent'

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
if vim.fn.executable('rg') then
  vim.opt.grepprg = 'rg --vimgrep'
  vim.opt.grepformat = '%f:%l:%c:%m'
end

-- Line Wrapping
vim.opt.wrap = false
vim.opt.breakindent = true
vim.opt.linebreak = true

-- Diagnostics
vim.diagnostic.config({
  virtual_text = {
    spacing = 0,
    prefix = '«',
  },
})

vim.fn.sign_define({
  { name = 'DiagnosticSignHint', text = '?', texthl = 'DiagnosticHint' },
  { name = 'DiagnosticSignInfo', text = '𝒊', texthl = 'DiagnosticInfo' },
  { name = 'DiagnosticSignWarn', text = '⚠', texthl = 'DiagnosticWarn' },
  { name = 'DiagnosticSignError', text = '✖', texthl = 'DiagnosticError' },
})

-- Automatically Resize Windows
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = vim.api.nvim_create_augroup('AutoResizeWindows', {}),
  callback = function(args) vim.cmd.wincmd('=') end,
})

-- Lists
vim.api.nvim_create_autocmd({ 'QuickFixCmdPost' }, {
  group = vim.api.nvim_create_augroup('AutoOpenLists', {}),
  callback = function(args)
    if string.find(args.match, '^l') then
      vim.cmd.lwindow()
    else
      vim.cmd.cwindow()
    end
  end,
})

-- Cursor Line
vim.api.nvim_create_autocmd({ 'VimEnter', 'WinEnter', 'BufWinEnter', 'WinLeave' }, {
  group = vim.api.nvim_create_augroup('CursorLine', {}),
  callback = function(args) vim.opt_local.cursorline = args.event ~= 'WinLeave' end,
})

-- Highlight on Yank
vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
  group = vim.api.nvim_create_augroup('YankHighlight', {}),
  callback = function(args) vim.highlight.on_yank() end,
})
-- Built-in Packages
vim.cmd('packadd! cfilter')

-- Key Mappings: General
vim.g.mapleader = ' '
vim.keymap.set({ 'n', 'v' }, ';', ':')
vim.keymap.set('n', '<Leader>/', ':nohlsearch<CR>', { silent = true })
vim.keymap.set('n', '<Leader>cd', ':lcd %:p:h<CR>:pwd<CR>', { silent = true })

-- Key Mappings: Tabs
vim.keymap.set('n', '<Leader><Tab>', ':$tabnew<CR>', { silent = true })
vim.keymap.set('n', 'g<Tab>', ':$tab split<CR>', { silent = true })

-- Key Mappings: Windows
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')
vim.keymap.set('n', '<C-w>z', '<C-w>_<C-w><Bar>')

-- Key Mappings: Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { silent = true })
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { silent = true })
vim.keymap.set('n', '<BS>', '<C-^>')

-- Key Mappings: Yank/Paste
vim.keymap.set({ 'n', 'v' }, '<Leader>y', '"+y')
vim.keymap.set({ 'n', 'v' }, '<Leader>p', '"+p')
vim.keymap.set({ 'n', 'v' }, '<Leader>P', '"+P')
vim.keymap.set('x', 'p', 'col(".") == col("$") - 1 ? "\\"_dp" : "\\"_dP"', { expr = true })

-- Key Mappings: Movement
vim.keymap.set('n', 'j', 'v:count > 0 ? "j" : "gj"', { expr = true })
vim.keymap.set('n', 'k', 'v:count > 0 ? "k" : "gk"', { expr = true })
vim.keymap.set('i', '<C-a>', '<Home>')
vim.keymap.set('i', '<C-e>', '<End>')
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

-- Key Mappings: Lists
vim.keymap.set('n', '<Leader>d', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '[q', ':cprevious<CR>zz', { silent = true })
vim.keymap.set('n', ']q', ':cnext<CR>zz', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<Leader>q', function()
  for i, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      vim.cmd.cclose()
      return
    end
  end

  vim.cmd.copen()
end)

-- Key Mappings: Miscellaneous
vim.keymap.set({ 'n', 'v' }, '<Leader><CR>', require('fido').fetch)
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

if vim.fn.executable('prettier') then
  vim.keymap.set('n', '<Leader>gq', ':%! prettier --stdin-filepath %<CR>', { silent = true })
end

-- User Commands
vim.api.nvim_create_user_command('R', function(args)
  require('fido').fetch({
    name = 'Shell',
    vertical = args.bang,
    execute = function()
      local cmd = string.gsub(args.args, '%%', vim.fn.expand('%'))

      return vim.fn.systemlist(cmd), cmd
    end,
  })
end, { nargs = '*', bang = true })
