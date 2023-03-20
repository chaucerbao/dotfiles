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
  vim.opt.grepprg = 'rg --no-config --fixed-strings --sort=path --vimgrep'
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

-- Cursor Line
vim.api.nvim_create_autocmd({ 'VimEnter', 'WinEnter', 'BufWinEnter', 'WinLeave' }, {
  group = vim.api.nvim_create_augroup('CursorLine', {}),
  callback = function(args) vim.opt_local.cursorline = args.event ~= 'WinLeave' end,
})

-- Highlight on Yank
vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
  group = vim.api.nvim_create_augroup('YankHighlight', {}),
  callback = function() vim.highlight.on_yank() end,
})

-- Automatically Resize Windows
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = vim.api.nvim_create_augroup('AutoResizeWindows', {}),
  callback = function() vim.cmd.wincmd('=') end,
})

-- Automatically Open Lists
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

-- Automatically Reload Files
vim.api.nvim_create_autocmd({ 'CursorHold' }, {
  group = vim.api.nvim_create_augroup('AutoReloadFiles', {}),
  pattern = { '*' },
  callback = function() vim.cmd('checktime') end,
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
vim.keymap.set('n', '<Leader>O', ':%bdelete|edit #|normal `"<CR>', { silent = true })

-- Key Mappings: Yank/Paste
vim.keymap.set({ 'n', 'v' }, '<Leader>y', '"+y')
vim.keymap.set({ 'n', 'v' }, '<Leader>p', '"+p')
vim.keymap.set({ 'n', 'v' }, '<Leader>P', '"+P')
vim.keymap.set('x', 'p', 'pgvy')

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
  for _, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      vim.cmd.cclose()
      return
    end
  end

  vim.cmd.copen()
end)

-- Key Mappings: Search
vim.keymap.set('n', '*', '/\\V\\<<C-r>=expand("<cword>")<CR>\\>\\C<CR>')
vim.keymap.set('v', '*', 'y/\\V<C-r>=escape(@", "/\\\\")<CR>\\C<CR>')
vim.keymap.set({ 'n', 'v' }, '<Leader>*', function()
  local search_term
  if string.find(string.lower(vim.fn.mode()), '^n') then
    search_term = vim.fn.expand('<cword>')
  else
    vim.cmd('normal y')
    search_term = vim.fn.getreg('"')
  end

  vim.fn.setreg('/', vim.fn.escape(search_term, '/\\'))
  vim.cmd('silent grep "' .. vim.fn.escape(search_term, '"') .. '"')
  vim.opt.hlsearch = true
end, { silent = true })

-- Highlighting
local highlight_namespace = vim.api.nvim_create_namespace('highlight')
vim.keymap.set({ 'v' }, '<Leader>h', function()
  vim.api.nvim_input('<C-[>')

  vim.defer_fn(function()
    local line_start = vim.fn.line("'<")
    local line_end = vim.fn.line("'>")
    local visual_block_mode = vim.fn.visualmode() == ''

    for line_number = line_start, line_end do
      vim.api.nvim_buf_add_highlight(
        0,
        highlight_namespace,
        'StatusLineNC',
        line_number - 1,
        (line_number == line_start or visual_block_mode) and (vim.fn.col("'<") - 1) or 0,
        (line_number == line_end or visual_block_mode) and (vim.fn.col("'>")) or -1
      )
    end
  end, 0)
end)
vim.keymap.set({ 'n' }, '<Leader>H', function() vim.api.nvim_buf_clear_namespace(0, highlight_namespace, 0, -1) end)

-- Formatting
local prettier_filetypes = {
  html = 'html',
  css = 'css',
  scss = 'scss',
  javascript = 'typescript',
  javascriptreact = 'typescript',
  typescript = 'typescript',
  typescriptreact = 'typescript',
  json = 'json',
  graphql = 'graphql',
  markdown = 'markdown',
  yaml = 'yaml',
  node = 'typescript',
}

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = vim.api.nvim_create_augroup('PrettierFormat', {}),
  pattern = {
    'html',
    'css',
    'scss',
    'javascript',
    'javascriptreact',
    'typescript',
    'typescriptreact',
    'json',
    'graphql',
    'markdown',
    'yaml',
    'node',
  },
  callback = function()
    if vim.fn.executable('npx') then
      vim.opt_local.formatprg = 'npx prettier --parser ' .. prettier_filetypes[vim.bo.filetype]
      vim.opt_local.formatexpr = nil
    end
  end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = vim.api.nvim_create_augroup('StyLuaFormat', {}),
  pattern = { 'lua' },
  callback = function()
    if vim.fn.executable('npx') then vim.opt_local.formatprg = 'npx @johnnymorganz/stylua-bin -' end
  end,
})

vim.keymap.set({ 'n', 'v' }, '<Leader>gq', function()
  local is_normal_mode = (string.find(vim.fn.mode(), '^n') or 0) > 0

  if is_normal_mode then
    vim.cmd(":normal mzgggqG'zzz")
  else
    vim.cmd(':normal gq')
  end
end, buffer_options)

-- Key Mappings: Miscellaneous
vim.keymap.set({ 'n', 'v' }, '<Leader><CR>', require('fido').fetch)
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = vim.api.nvim_create_augroup('NodeSyntaxOverride', {}),
  pattern = { 'node' },
  callback = function()
    vim.defer_fn(function() vim.bo.syntax = 'javascript' end, 0)
  end,
})

if vim.fn.executable('git') then
  vim.keymap.set('n', '<Leader>gB', function()
    require('fido').fetch({
      name = 'GitBlame',
      vertical = true,
      execute = function()
        local cmd_opts = {
          '-c',
          '--date=short',
        }

        table.insert(cmd_opts, '--')
        table.insert(cmd_opts, vim.fn.expand('%'))

        local cmd = 'git blame ' .. table.concat(cmd_opts, ' ')
        return vim.fn.systemlist(cmd), cmd
      end,
      hook = {
        before = function()
          vim.wo.cursorbind = false
          vim.wo.scrollbind = false
        end,
        after = function(window)
          -- Synchronize the scroll-binding
          window.child.focus()

          vim.cmd('normal gg')
          vim.wo.cursorbind = true
          vim.wo.scrollbind = true

          window.parent.focus()

          local current_line = vim.fn.line('.')
          vim.cmd('normal gg')
          vim.wo.cursorbind = true
          vim.wo.scrollbind = true
          vim.cmd('normal ' .. current_line .. 'ggzz')

          -- Key Mappings: Follow blame history
          local follow_mapping = '<Leader>gB'

          window.child.focus()
          if vim.fn.empty(vim.fn.mapcheck(follow_mapping, 'n')) then
            vim.keymap.set('n', follow_mapping, function()
              -- Disable scroll-binding
              window.parent.focus()
              vim.wo.cursorbind = false
              vim.wo.scrollbind = false

              window.child.focus()
              vim.wo.cursorbind = false
              vim.wo.scrollbind = false

              local revision = vim.fn.expand('<cword>')

              local cmd_opts = {
                '-c',
                '--date=short',
              }

              table.insert(cmd_opts, revision .. '^1')
              table.insert(cmd_opts, '--')
              table.insert(cmd_opts, vim.fn.bufname(window.parent.bufnr))

              local cmd = 'git blame ' .. table.concat(cmd_opts, ' ')
              local response_lines = vim.fn.systemlist(cmd)

              local line = vim.fn.line('.')
              window.child.replace_buffer(response_lines)
              vim.cmd('normal ' .. line .. 'ggzz')

              print(cmd)
            end, { buffer = window.child.bufnr })
          end

          window.parent.focus()
        end,
      },
    })
  end)
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
