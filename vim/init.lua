-- Package Manager
local mini_path = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path })
  vim.cmd('packadd mini.nvim | helptags ALL')
end

-- mini.nvim
require('mini.deps').setup()

require('mini.ai').setup()
require('mini.basics').setup({ options = { extra_ui = true }, mappings = { windows = true } })
require('mini.bracketed').setup()
require('mini.completion').setup({ lsp_completion = { source_func = 'omnifunc', auto_setup = false } })
require('mini.diff').setup({ view = { style = 'sign', signs = { add = '+', change = '~', delete = '-' } } })
require('mini.extra').setup()
require('mini.files').setup({
  mappings = { close = '<Esc>', go_in = '', go_in_plus = '<CR>', go_out = '<BS>', go_out_plus = '', reset = '' },
})
require('mini.git').setup()
require('mini.icons').setup()
require('mini.jump').setup()
require('mini.jump2d').setup(
  vim.tbl_extend(
    'keep',
    require('mini.jump2d').builtin_opts.word_start,
    { allowed_lines = { blank = false }, allowed_windows = { not_current = false }, mappings = { start_jumping = 'S' } }
  )
)
require('mini.pairs').setup()
require('mini.pick').setup()
require('mini.snippets').setup()
require('mini.splitjoin').setup()
require('mini.statusline').setup()
require('mini.surround').setup()
require('mini.tabline').setup()
require('mini.visits').setup()

-- Color Scheme
MiniDeps.now(function()
  MiniDeps.add({ source = 'folke/tokyonight.nvim' })
  vim.cmd.colorscheme('tokyonight-storm')
  vim.api.nvim_set_hl(0, 'MiniJump', { link = 'MiniJump2dSpot' })
end)

-- Tree-sitter
MiniDeps.later(function()
  MiniDeps.add({ source = 'nvim-treesitter/nvim-treesitter' })
  MiniDeps.add({ source = 'nvim-treesitter/nvim-treesitter-context', depends = { 'nvim-treesitter/nvim-treesitter' } })

  require('nvim-treesitter.configs').setup({
    auto_install = vim.fn.executable('tree-sitter') > 0,
    ensure_installed = { 'diff' },
    highlight = { enable = true },
    indent = { enable = true },
  })
  require('treesitter-context').setup({ mode = 'topline', separator = '─' })
end)

-- Language Server Protocol
MiniDeps.now(function()
  MiniDeps.add({ source = 'mason-org/mason.nvim' })

  require('mason').setup()

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event)
      vim.bo[event.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

      vim.keymap.set({ 'n' }, 'gd', vim.lsp.buf.definition, { buffer = event.buf })
      vim.keymap.set({ 'n' }, 'gD', vim.lsp.buf.type_definition, { buffer = event.buf })

      local client = vim.lsp.get_client_by_id(event.data.client_id)

      if client then
        if client.name == 'efm-langserver' then
          vim.keymap.set({ 'n', 'x' }, 'gq', function()
            vim.lsp.buf.format({ name = 'efm-langserver' })
          end, { buffer = event.buf })

          vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
            group = vim.api.nvim_create_augroup('FormatOnSave', { clear = true }),
            callback = function()
              vim.lsp.buf.format({ name = 'efm-langserver' })
            end,
          })
        end

        if client.name == 'typescript-language-server' then
          vim.keymap.set({ 'n' }, 'gi', function()
            client:exec_cmd({
              command = '_typescript.organizeImports',
              arguments = { vim.api.nvim_buf_get_name(event.buf) },
            })
          end, { buffer = event.buf })
        end
      end
    end,
  })

  MiniIcons.tweak_lsp_kind()
  MiniSnippets.start_lsp_server()
  vim.lsp.enable({ 'efm-langserver' })
end)

-- Large Language Models
MiniDeps.later(function()
  MiniDeps.add({
    source = 'ravitemer/mcphub.nvim',
    hooks = {
      post_install = function(event)
        vim.cmd.source(event.path .. '/bundled_build.lua')
      end,
    },
  })
  MiniDeps.add({
    source = 'olimorris/codecompanion.nvim',
    depends = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
  })

  require('mcphub').setup({ use_bundled_binary = true })

  require('codecompanion').setup({
    strategies = {
      chat = { keymaps = { completion = { modes = { i = '<C-j>' } } } },
    },
    extensions = {
      mcphub = {
        callback = 'mcphub.extensions.codecompanion',
        opts = { make_slash_commands = true, make_vars = true },
      },
    },
  })

  vim.keymap.set({ 'ca' }, 'cc', 'CodeCompanion')
  vim.keymap.set({ 'n', 'x' }, "<Leader>'", '<CMD>CodeCompanionChat Toggle<CR>')
  vim.keymap.set({ 'n', 'x' }, '<Leader>;', '<CMD>CodeCompanionActions<CR>')
end)

-- Only used once to authenticate with GitHub Copilot (`:Copilot setup`)
-- MiniDeps.later(function()
--   MiniDeps.add({ source = 'github/copilot.vim' })
-- end)

-- Shelly
MiniDeps.later(function()
  MiniDeps.add({ source = 'chaucerbao/shelly.nvim' })

  local shelly = require('shelly')
  shelly.setup({ mappings = { close = 'q' } })

  shelly.commands.shell.create('Run')
  vim.keymap.set({ 'n', 'x' }, '<Leader><CR>', shelly.evaluate)
end)

-- Abolish
MiniDeps.later(function()
  MiniDeps.add({ source = 'tpope/vim-abolish' })
end)

-- Snippets
local gen_loader = MiniSnippets.gen_loader
MiniSnippets.config.snippets = {
  gen_loader.from_file(vim.fn.stdpath('config') .. '/snippets.lua'),
  gen_loader.from_file(vim.fn.stdpath('config') .. '/snippets/global.lua'),
  gen_loader.from_lang(),
}

-- Helpers
local function gen_local_picker(picker)
  return function()
    picker(nil, { source = { cwd = vim.fn.expand('%:p:h') } })
  end
end

local function toggle_list(list, open, close)
  return function()
    if vim.tbl_isempty(vim.tbl_filter(function(window)
      return window[list] > 0
    end, vim.fn.getwininfo())) then
      local ok = pcall(vim.cmd, open)
      if ok then
        vim.cmd.wincmd('p')
      else
        print('No list available')
      end
    else
      vim.cmd(close)
    end
  end
end

-- Disable Netrw
vim.g.loaded_netrwPlugin = 1

-- General Settings
vim.o.confirm = true
vim.o.spell = true
vim.o.winborder = 'rounded'
vim.opt.listchars = { tab = '»·', trail = '·', nbsp = '◡' }
vim.ui.select = MiniPick.ui_select

-- Indentation
vim.o.tabstop = 2
vim.o.shiftwidth = 0
vim.o.shiftround = true
vim.o.expandtab = true

-- Folding
vim.o.foldenable = false
vim.o.foldmethod = 'indent'

-- Diagnostics
vim.diagnostic.config({
  signs = {
    numhl = { [vim.diagnostic.severity.ERROR] = 'ErrorMsg', [vim.diagnostic.severity.WARN] = 'WarningMsg' },
    text = {
      [vim.diagnostic.severity.ERROR] = '⛌',
      [vim.diagnostic.severity.WARN] = '△',
      [vim.diagnostic.severity.INFO] = '𝓲',
      [vim.diagnostic.severity.HINT] = '»',
    },
  },
})

-- Keymaps
vim.keymap.set({ 'n', 'x' }, ';', ':')
vim.keymap.set({ 'n' }, '<Leader>cd', ':lcd %:p:h<CR>:pwd<CR>')
vim.keymap.set({ 'n' }, '<Leader>h', MiniDiff.toggle_overlay)
vim.keymap.set({ 'ca' }, 'vh', 'vertical help')

-- Tabs
vim.keymap.set({ 'n' }, '<Leader><Tab>', ':$tabnew<CR>')
vim.keymap.set({ 'n' }, 'g<Tab>', ':$tab split<CR>')

-- Buffers
vim.keymap.set({ 'n' }, '<Tab>', ':bnext<CR>')
vim.keymap.set({ 'n' }, '<S-Tab>', ':bprevious<CR>')
vim.keymap.set({ 'n' }, '<Leader>O', ':%bdelete|edit #|bdelete #|normal `"<CR>')

-- Movement
vim.keymap.set({ 'c', 'i' }, '<C-a>', '<Home>')
vim.keymap.set({ 'c', 'i' }, '<C-e>', '<End>')

-- Yank/Paste
vim.keymap.set({ 'x' }, 'p', 'pgvy')
vim.keymap.set({ 'n' }, 'gP', '"+P')

-- Smart `<Tab>`
local map_multistep = require('mini.keymap').map_multistep
map_multistep({ 'i' }, '<Tab>', { 'minisnippets_next', 'pmenu_next' })
map_multistep({ 'i' }, '<S-Tab>', { 'minisnippets_prev', 'pmenu_prev' })

-- Pickers
vim.keymap.set({ 'n' }, '<Leader>b', MiniPick.builtin.buffers)
vim.keymap.set({ 'n' }, '<Leader>e', function()
  MiniFiles.open(nil, false)
end)
vim.keymap.set({ 'n' }, '<Leader>E', function()
  MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
end)
vim.keymap.set({ 'n' }, '<Leader>f', MiniPick.builtin.files)
vim.keymap.set({ 'n' }, '<Leader>F', gen_local_picker(MiniPick.builtin.files))
vim.keymap.set({ 'n' }, '<Leader>/', MiniPick.builtin.grep_live)
vim.keymap.set({ 'n' }, '<Leader>?', gen_local_picker(MiniPick.builtin.grep_live))
vim.keymap.set({ 'n' }, '<Leader>.', MiniPick.builtin.resume)
vim.keymap.set({ 'n' }, '<Leader>v', MiniExtra.pickers.visit_paths)
vim.keymap.set({ 'n' }, '<Leader>V', function()
  MiniExtra.pickers.visit_paths({ filter = MiniGit.get_buf_data().head_name or vim.fn.expand('%:p:h') })
end)

-- Search
if vim.o.grepprg:match('^rg ') then
  vim.o.grepprg = 'rg --no-config --case-sensitive --fixed-strings --sort=path --vimgrep'
end

vim.keymap.set({ 'n', 'x' }, '<Leader>*', function()
  local search_term
  if vim.fn.mode():match('^n') then
    search_term = vim.fn.expand('<cword>')
  else
    vim.cmd('normal y')
    search_term = vim.fn.getreg('"')
  end

  vim.fn.setreg('/', vim.fn.escape(search_term, '/\\'))
  vim.cmd.grep('"' .. vim.fn.escape(search_term, '"') .. '"')
  vim.opt.hlsearch = true
end)

vim.keymap.set({ 'ca' }, 'rg', 'grep')

-- Location/QuickFix Lists
vim.cmd.packadd('cfilter')

vim.keymap.set({ 'n' }, '\\l', toggle_list('loclist', 'lopen', 'lclose'))
vim.keymap.set({ 'n' }, '\\q', toggle_list('quickfix', 'copen', 'cclose'))

-- Automatically Open Lists
vim.api.nvim_create_autocmd({ 'QuickFixCmdPost' }, {
  callback = function(event)
    vim.cmd((event.match:find('^l') and 'lwindow' or 'cwindow'))
  end,
})

-- Toggle MiniVisit Labels
vim.keymap.set({ 'n' }, '\\v', function()
  local label = MiniGit.get_buf_data().head_name or vim.fn.expand('%:p:h')

  if vim.list_contains(MiniVisits.list_paths(nil, { filter = label }), vim.api.nvim_buf_get_name(0)) then
    MiniVisits.remove_label(label)
  else
    MiniVisits.add_label(label)
  end
end)

-- Git Navigation
vim.keymap.set({ 'n', 'x' }, '<Leader>g.', MiniGit.show_at_cursor)
vim.keymap.set({ 'n' }, '<Leader>gb', function()
  local git_root_path = vim.fn.expand('%'):match('^minigit://.+%-C%s+([^%s]+)') or MiniGit.get_buf_data().root
  if git_root_path == nil then
    print('File is not inside a repository')
    return
  end

  local cword = vim.fn.expand('<cword>')
  local filename = vim.fn.expand('%:p'):gsub('^.+ -- ', '')
  local revision = (cword:match('^%x%x%x%x%x%x%x+$') and cword:lower() == cword) and (cword .. '^') or 'HEAD'

  local ok, result =
    pcall(vim.cmd, 'vertical Git -C ' .. git_root_path .. ' blame --date=short ' .. revision .. ' -- ' .. filename)

  if ok then
    vim.keymap.set({ 'n' }, 'q', ':bdelete<CR>', { silent = true, buffer = true })
  elseif result:find('fatal: no such path ') then
    print(('`%s` does not exist before `%s`'):format(vim.fs.basename(filename), revision:gsub('%^$', '')))
  end
end)

-- Align Git Blame Windows
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniGitCommandSplit',
  callback = function(event)
    if event.data.git_subcommand ~= 'blame' then
      return
    end

    local win_source = event.data.win_source

    vim.wo.wrap = false
    vim.fn.winrestview({ topline = vim.fn.line('w0', win_source) })
    vim.api.nvim_win_set_cursor(0, { vim.fn.line('.', win_source), 0 })
  end,
})

-- Automatically Resize Windows
vim.api.nvim_create_autocmd('VimResized', {
  callback = function()
    vim.cmd.wincmd('=')
  end,
})
