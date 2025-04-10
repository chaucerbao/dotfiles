-- Package Manager
local mini_path = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path })
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end
require('mini.deps').setup()

-- Disable `netrw`
vim.g.loaded_netrwPlugin = 1

-- Settings
MiniDeps.later(function()
  -- General
  vim.opt.confirm = true
  vim.opt.spell = true
  vim.opt.list = true
  vim.opt.listchars = { tab = '»·', trail = '·', nbsp = '◡' }
  vim.opt.diffopt:append({ 'algorithm:patience', 'vertical' })
  vim.g.mapleader = ' '

  -- Completion
  vim.opt.complete:remove({ 't' })
  vim.opt.wildmode = { 'longest:full', 'full' }

  -- Indentation
  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 0
  vim.opt.shiftround = true
  vim.opt.expandtab = true

  -- Folding
  vim.opt.foldenable = false
  vim.opt.foldmethod = 'indent'

  -- Diagnostics
  vim.diagnostic.config({
    signs = {
      numhl = {
        [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
        [vim.diagnostic.severity.WARN] = 'WarningMsg',
      },
      text = {
        [vim.diagnostic.severity.ERROR] = '✕',
        [vim.diagnostic.severity.WARN] = '△',
        [vim.diagnostic.severity.INFO] = 'ℹ',
        [vim.diagnostic.severity.HINT] = '?',
      },
    },
    virtual_text = { prefix = '«', spacing = 0 },
  })

  -- Search
  if vim.fn.executable('rg') > 0 then
    vim.opt.grepprg = 'rg --smart-case --fixed-strings --sort=path --vimgrep'
    vim.opt.grepformat = '%f:%l:%c:%m'
  end
end)

-- Events
MiniDeps.later(function()
  -- Resize Windows Equally
  vim.api.nvim_create_autocmd({ 'VimResized' }, {
    group = vim.api.nvim_create_augroup('AutoResizeWindows', {}),
    callback = function()
      vim.cmd.wincmd('=')
    end,
  })

  -- Open Lists
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
end)

-- Language Server Protocol
MiniDeps.now(function()
  MiniDeps.add({ source = 'neovim/nvim-lspconfig' })
  MiniDeps.add({ source = 'williamboman/mason.nvim' })
  MiniDeps.add({ source = 'williamboman/mason-lspconfig.nvim', depends = { 'williamboman/mason.nvim' } })
  MiniDeps.add({ source = 'creativenull/efmls-configs-nvim', depends = { 'neovim/nvim-lspconfig' } })

  local lspconfig = require('lspconfig')

  local function format_buffer(bufnr)
    if vim.tbl_isempty(vim.lsp.get_active_clients({ name = 'efm', bufnr = bufnr })) then
      vim.lsp.buf.format()
    else
      vim.lsp.buf.format({ name = 'efm' })
    end
  end

  require('mason').setup()
  require('mason-lspconfig').setup({
    ensure_installed = { 'efm' },
    handlers = {
      function(server_name)
        lspconfig[server_name].setup({})
      end,

      ['efm'] = function()
        local eslint = require('efmls-configs.linters.eslint_d')
        local eslint_fix = require('efmls-configs.formatters.eslint_d')
        local stylelint = require('efmls-configs.linters.stylelint')
        local stylelint_fix = require('efmls-configs.formatters.stylelint')
        local prettier = require('efmls-configs.formatters.prettier_d')
        local deno_fmt = require('efmls-configs.formatters.deno_fmt')
        local gofumpt = require('efmls-configs.formatters.gofumpt')

        local function prettier_parser(ext)
          return vim.tbl_extend(
            'force',
            prettier,
            { formatCommand = prettier.formatCommand:gsub('%${INPUT}', 'file.' .. ext) }
          )
        end

        local function deno_format(ext)
          return vim.tbl_extend('force', deno_fmt, {
            formatCommand = deno_fmt.formatCommand:gsub('%${FILEEXT}', ext),
            rootMarkers = { 'deno.json', 'deno.jsonc' },
          })
        end

        local languages = vim.tbl_extend('force', require('efmls-configs.defaults').languages(), {
          javascript = { eslint, deno_format('js'), prettier_parser('js'), eslint_fix },
          javascriptreact = { eslint, deno_format('jsx'), prettier_parser('jsx'), eslint_fix },
          typescript = { eslint, deno_format('ts'), prettier_parser('ts'), eslint_fix },
          typescriptreact = { eslint, deno_format('tsx'), prettier_parser('tsx'), eslint_fix },

          css = { stylelint, deno_format('css'), prettier_parser('css'), stylelint_fix },
          scss = { stylelint, deno_format('scss'), prettier_parser('scss'), stylelint_fix },

          graphql = { prettier_parser('graphql') },
          html = { deno_format('html'), prettier_parser('html') },
          json = { deno_format('json'), prettier_parser('json') },
          markdown = { deno_format('md'), prettier_parser('md') },
          yaml = { deno_format('yaml'), prettier_parser('yaml') },

          go = { gofumpt },
        })

        lspconfig.efm.setup({
          filetypes = vim.tbl_keys(languages),
          settings = { rootMarkers = { '.git/' }, languages = languages },
          init_options = { documentFormatting = true, documentRangeFormatting = true },
          on_attach = function(client, bufnr)
            vim.keymap.set({ 'n', 'v' }, 'gq', function()
              format_buffer(bufnr)
            end, { buffer = bufnr })

            -- Format on Save
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = vim.api.nvim_create_augroup('LspFormatting', {}),
              callback = function(args)
                format_buffer(args.buf)
              end,
            })
          end,
        })
      end,

      ['denols'] = function()
        lspconfig.denols.setup({
          root_dir = lspconfig.util.root_pattern('deno.json', 'deno.jsonc'),
        })
      end,

      ['ts_ls'] = function()
        lspconfig.ts_ls.setup({
          root_dir = lspconfig.util.root_pattern('package.json'),
          single_file_support = false,
          on_attach = function(client, bufnr)
            -- Organize Imports
            vim.keymap.set({ 'n' }, 'gi', function()
              client:exec_cmd({
                command = '_typescript.organizeImports',
                arguments = { vim.api.nvim_buf_get_name(bufnr) },
              })
            end, { buffer = bufnr })
          end,
        })
      end,
    },
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      vim.bo[args.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'

      vim.keymap.set({ 'n' }, 'gd', vim.lsp.buf.definition, { buffer = args.buf })
    end,
  })
end)

-- Tree-sitter
MiniDeps.now(function()
  MiniDeps.add({
    source = 'nvim-treesitter/nvim-treesitter',
    hooks = {
      post_checkout = function()
        vim.cmd('TSUpdate')
      end,
    },
  })
  MiniDeps.add({ source = 'nvim-treesitter/nvim-treesitter-context', depends = { 'nvim-treesitter/nvim-treesitter' } })

  require('nvim-treesitter.configs').setup({
    auto_install = vim.fn.executable('tree-sitter') > 0,
    ensure_installed = { 'diff' },
    highlight = { enable = true },
    indent = { enable = true },
  })
  require('treesitter-context').setup({ mode = 'topline', separator = '─' })
end)

-- GitHub Copilot
MiniDeps.later(function()
  MiniDeps.add({ source = 'zbirenbaum/copilot.lua' })

  require('copilot').setup({
    suggestion = {
      auto_trigger = true,
      keymap = { accept = '<C-y>', next = '<C-l>', prev = '<C-h>' },
    },
  })
end)

-- CodeCompanion
MiniDeps.later(function()
  MiniDeps.add({
    source = 'olimorris/codecompanion.nvim',
    depends = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
  })

  require('codecompanion').setup({
    display = { chat = { window = { width = 0.4 } } },
    strategies = {
      chat = {
        keymaps = {
          send = { modes = { n = { '<Leader><CR>', '<C-s>' } } },
          close = { modes = { n = 'q', i = {} } },
          stop = { modes = { n = '<C-c>' } },
          completion = { modes = { i = '<C-x><C-o>' } },
        },
      },
    },
  })

  vim.keymap.set({ 'n', 'v' }, '<Leader>\\', '<CMD>CodeCompanionActions<CR>')
end)

-- User Interface
MiniDeps.now(function()
  MiniDeps.add({ source = 'folke/tokyonight.nvim' })

  vim.cmd.colorscheme('tokyonight-night')

  require('mini.basics').setup({ mappings = { windows = true } })
  require('mini.statusline').setup()
end)

-- mini.nvim
MiniDeps.now(function()
  require('mini.extra').setup()
  require('mini.files').setup({
    windows = { preview = true, width_preview = 80 },
    mappings = { go_in = '', go_in_plus = '<CR>', go_out = '<BS>', go_out_plus = '', reset = '<Leader><BS>' },
  })
  require('mini.pick').setup()
  require('mini.visits').setup()

  -- Pickers
  vim.keymap.set({ 'n' }, '<Leader>b', MiniPick.builtin.buffers)

  vim.keymap.set({ 'n' }, '<Leader>d', MiniExtra.pickers.diagnostic)

  vim.keymap.set({ 'n' }, '<Leader>e', function()
    MiniFiles.open(nil, false)
  end)
  vim.keymap.set({ 'n' }, '<Leader>E', function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
  end)

  vim.keymap.set({ 'n' }, '<Leader>f', MiniExtra.pickers.explorer)
  vim.keymap.set({ 'n' }, '<Leader>F', function()
    MiniExtra.pickers.explorer({ cwd = vim.fn.expand('%:p:h') })
  end)

  vim.keymap.set({ 'n' }, '<Leader>gc', MiniExtra.pickers.git_commits)

  vim.keymap.set({ 'n' }, '<Leader>t', MiniPick.builtin.files)
  vim.keymap.set({ 'n' }, '<Leader>T', function()
    MiniPick.builtin.files(nil, { source = { cwd = vim.fn.expand('%:p:h') } })
  end)

  vim.keymap.set({ 'n' }, '<Leader>/', MiniPick.builtin.grep_live)
  vim.keymap.set({ 'n' }, '<Leader>?', function()
    MiniPick.builtin.grep_live(nil, { source = { cwd = vim.fn.expand('%:p:h') } })
  end)

  vim.keymap.set({ 'n' }, '<Leader>v', MiniExtra.pickers.visit_paths)
  vim.keymap.set({ 'n' }, '<Leader>V', MiniExtra.pickers.visit_labels)
  vim.keymap.set({ 'n' }, '<Leader>Vl', MiniVisits.add_label)
  vim.keymap.set({ 'n' }, '<Leader>VL', MiniVisits.remove_label)

  local function git_branch_current()
    local branch = vim.fn.system({ 'git', 'branch', '--show-current' })
    return vim.v.shell_error == 0 and vim.trim(branch) or nil
  end

  vim.keymap.set({ 'n' }, '<Leader>Vb', function()
    MiniVisits.add_label(git_branch_current())
  end)
  vim.keymap.set({ 'n' }, '<Leader>VB', function()
    MiniVisits.remove_label(git_branch_current())
  end)

  vim.keymap.set({ 'n' }, '<Leader>.', MiniPick.builtin.resume)
end)

MiniDeps.later(function()
  require('mini.ai').setup()
  require('mini.align').setup()
  require('mini.bracketed').setup()
  require('mini.comment').setup()
  require('mini.completion').setup({ lsp_completion = { source_func = 'omnifunc', auto_setup = false } })
  require('mini.diff').setup({
    view = { style = 'sign', signs = { add = '+', change = '~', delete = '-' } },
    options = { algorithm = 'patience' },
    mappings = { apply = 'gs', reset = 'gR', textobject = 'ah' },
  })
  require('mini.git').setup()
  require('mini.icons').setup()
  require('mini.indentscope').setup({ draw = { animation = require('mini.indentscope').gen_animation.none() } })
  require('mini.jump').setup({ mappings = { repeat_jump = '' } })
  require('mini.jump2d').setup({
    spotter = require('mini.jump2d').builtin_opts.word_start.spotter,
    allowed_lines = { blank = false },
    allowed_windows = { not_current = false },
    mappings = { start_jumping = 'S' },
  })
  require('mini.pairs').setup()
  require('mini.splitjoin').setup()
  require('mini.surround').setup()
  require('mini.tabline').setup()

  -- Snippets
  local gen_loader = require('mini.snippets').gen_loader
  require('mini.snippets').setup({
    snippets = {
      gen_loader.from_file('~/.config/nvim/snippets.lua'),
      gen_loader.from_file('~/.config/nvim/snippets/global.lua'),
      gen_loader.from_lang(),
    },
    mappings = { expand = '<C-;>' },
  })

  -- Replace the default `vim.ui.select` interface
  vim.ui.select = MiniPick.ui_select

  -- Apply `mini.icons`
  MiniIcons.mock_nvim_web_devicons()
  MiniIcons.tweak_lsp_kind()

  -- Jump to the matching line when opening `Git blame`
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniGitCommandSplit',
    callback = function(args)
      if args.data.git_subcommand ~= 'blame' then
        return
      end

      vim.fn.winrestview({ topline = vim.fn.line('w0', args.data.win_source) })
      vim.api.nvim_win_set_cursor(0, { vim.fn.line('.', args.data.win_source), 0 })
    end,
  })
end)

-- Miscellaneous
MiniDeps.later(function()
  MiniDeps.add({ source = 'tpope/vim-abolish' })
  MiniDeps.add({ source = 'chaucerbao/shelly.nvim' })

  vim.cmd.packadd('cfilter')

  vim.keymap.set({ 'v' }, 'cr', '<Plug>(abolish-coerce)')

  local shelly = require('shelly')
  shelly.setup({ mappings = { close = 'q' } })

  vim.keymap.set({ 'n', 'v' }, '<Leader><CR>', shelly.evaluate)
  shelly.commands.shell.create('Run')
  shelly.commands.git_status.create('GitStatus', {
    mappings = {
      edit = '<CR>',
      stage = 'gs',
      unstage = 'gS',
      restore = 'gR',
      refresh = '<Leader>r',
    },
  })
end)

-- Key Mappings
MiniDeps.later(function()
  -- General
  vim.keymap.set({ 'n', 'v' }, ';', ':')
  vim.keymap.set({ 'n' }, '<Leader>cd', ':lcd %:p:h<CR>:pwd<CR>', { silent = true })
  vim.keymap.set({ 'c' }, 'vh', 'vertical help')

  -- Tabs
  vim.keymap.set({ 'n' }, '<Leader><Tab>', ':$tabnew<CR>', { silent = true })
  vim.keymap.set({ 'n' }, 'g<Tab>', ':$tab split<CR>', { silent = true })

  -- Buffers
  vim.keymap.set({ 'n' }, '<Tab>', ':bnext<CR>', { silent = true })
  vim.keymap.set({ 'n' }, '<S-Tab>', ':bprevious<CR>', { silent = true })
  vim.keymap.set({ 'n' }, '<Leader>O', ':%bdelete|edit #|bdelete #|normal `"<CR>', { silent = true })

  -- Quickfix
  function toggle_list(list, open, close)
    if vim.tbl_isempty(vim.tbl_filter(function(window)
      return window[list] > 0
    end, vim.fn.getwininfo())) then
      vim.cmd(open)
      vim.cmd.wincmd('p')
    else
      vim.cmd(close)
    end
  end

  vim.keymap.set({ 'n' }, '\\q', function()
    toggle_list('quickfix', 'copen', 'cclose')
  end)
  vim.keymap.set({ 'n' }, '\\l', function()
    toggle_list('loclist', 'lopen', 'lclose')
  end)

  -- Yank/Paste
  vim.keymap.set({ 'x' }, 'p', 'pgvy')
  vim.keymap.set('n', 'gP', '"+P')

  -- Movement
  vim.keymap.set({ 'c', 'i' }, '<C-a>', '<Home>')
  vim.keymap.set({ 'c', 'i' }, '<C-e>', '<End>')

  -- Search
  vim.keymap.set({ 'n', 'v' }, '<Leader>*', function()
    local search_term
    if string.find(string.lower(vim.fn.mode()), '^n') then
      search_term = vim.fn.expand('<cword>')
    else
      vim.cmd('normal y')
      search_term = vim.fn.getreg('"')
    end

    vim.fn.setreg('/', vim.fn.escape(search_term, '/\\'))
    vim.cmd.grep('"' .. vim.fn.escape(search_term, '"') .. '"')
    vim.opt.hlsearch = true
  end)

  -- Git/Diff
  vim.keymap.set({ 'n' }, '<Leader>gb', function()
    local cword = vim.fn.expand('<cword>')
    local filename = vim.fn.expand('%')

    if string.find(filename, ' -- ') then
      filename = filename:gsub('^.+ -- ', '')
    end

    local revision = (string.find(cword, '^%x%x%x%x%x%x%x+$') ~= nil and string.lower(cword) == cword)
        and (cword .. '^')
      or 'HEAD'

    local ok, result = pcall(vim.cmd, 'vertical Git blame --date=short ' .. revision .. ' -- ' .. filename)

    local bufnr = vim.fn.winbufnr(0)
    vim.keymap.set({ 'n' }, 'q', ':' .. bufnr .. 'bdelete<CR>', { silent = true, buffer = bufnr })

    if not ok and string.find(result, 'fatal: no such path ') ~= nil then
      print('`' .. vim.fs.basename(filename) .. '` does not exist before `' .. revision:gsub('%^$', '') .. '`')
    end
  end)

  vim.keymap.set({ 'n' }, '<Leader>gs', function()
    pcall(vim.cmd, 'Git add -- ' .. vim.fn.expand('%'))
  end)
  vim.keymap.set({ 'n' }, '<Leader>gS', function()
    pcall(vim.cmd, 'Git restore --staged -- ' .. vim.fn.expand('%'))
  end)
  vim.keymap.set({ 'n' }, '<Leader>gR', function()
    pcall(vim.cmd, 'Git restore -- ' .. vim.fn.expand('%'))
  end)

  vim.keymap.set({ 'n' }, '<Leader>h', MiniDiff.toggle_overlay)
end)
