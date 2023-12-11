local packer_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local is_packer_installed = vim.fn.empty(vim.fn.glob(packer_path)) == 0

if not is_packer_installed then
  vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', packer_path })
  vim.cmd('packadd! packer.nvim')
end

-- Disable `netrw` in lieu of `nvim-telescope/telescope-file-browser.nvim`
vim.g.loaded_netrwPlugin = 1

require('packer').startup(function(use)
  use({ 'wbthomason/packer.nvim' })

  use({
    'VonHeikemen/lsp-zero.nvim',
    branch = 'dev-v3',
    requires = {
      { 'neovim/nvim-lspconfig' },

      {
        'hrsh7th/nvim-cmp',
        requires = {
          { 'hrsh7th/cmp-nvim-lsp' },

          {
            'zbirenbaum/copilot-cmp',
            requires = {
              {
                'zbirenbaum/copilot.lua',
                cmd = 'Copilot',
                event = 'InsertEnter',
                config = function()
                  require('copilot').setup({
                    panel = { enabled = false },
                    suggestion = { enabled = false },
                    filetypes = { gitcommit = true },
                  })
                end,
              },
            },
            after = { 'copilot.lua' },
            config = function()
              require('copilot_cmp').setup()
            end,
          },

          {
            'saadparwaiz1/cmp_luasnip',
            requires = {
              {
                'L3MON4D3/LuaSnip',
                config = function()
                  local luasnip = require('luasnip')
                  luasnip.filetype_extend('javascript', { 'jsdoc' })
                  luasnip.filetype_extend('typescript', { 'javascript', 'tsdoc' })
                  luasnip.filetype_extend('node', { 'javascript' })

                  require('luasnip.loaders.from_vscode').lazy_load()
                  require('luasnip.loaders.from_lua').lazy_load({ paths = './snippets' })
                end,
              },
              { 'rafamadriz/friendly-snippets' },
            },
          },
        },

        config = function()
          local cmp = require('cmp')
          local luasnip = require('luasnip')
          local has_words_before = function()
            local line, col = (unpack or table.unpack)(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
          end

          cmp.setup({
            snippet = {
              expand = function(args)
                luasnip.lsp_expand(args.body)
              end,
            },
            sources = cmp.config.sources({
              { name = 'luasnip' },
              { name = 'nvim_lsp' },
            }, {
              { name = 'copilot' },
            }),
            matching = {
              disallow_fuzzy_matching = true,
              disallow_fullfuzzy_matching = true,
              disallow_partial_matching = true,
              disallow_prefix_unmatching = true,
            },
            mapping = cmp.mapping.preset.insert({
              ['<C-b>'] = cmp.mapping.scroll_docs(-4),
              ['<C-f>'] = cmp.mapping.scroll_docs(4),
              ['<C-y>'] = cmp.mapping.confirm({ select = true }),
              ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expand_or_locally_jumpable() then
                  luasnip.expand_or_jump()
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end, { 'i', 's' }),
              ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { 'i', 's' }),
            }),
          })
        end,
      },
    },

    config = function()
      local lsp_zero = require('lsp-zero')

      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })

        if vim.tbl_contains({ 'tsserver' }, client.name) then
          vim.keymap.set('n', '<Leader>i', function()
            vim.lsp.buf.execute_command({
              command = '_typescript.organizeImports',
              arguments = { vim.api.nvim_buf_get_name(0) },
            })
          end, { buffer = bufnr })
        end
      end)
    end,
  })

  use({
    'williamboman/mason-lspconfig.nvim',
    requires = {
      {
        'williamboman/mason.nvim',
        config = function()
          require('mason').setup()
        end,
      },
    },
    after = { 'lsp-zero.nvim' },
    config = function()
      require('mason-lspconfig').setup({ handlers = { require('lsp-zero').default_setup } })
    end,
  })

  use({
    'mhartington/formatter.nvim',
    config = function()
      local filetype_formatter = require('formatter.filetypes')

      local filetypeSettings = {
        jsonc = { filetype_formatter.json.prettierd },
        lua = { filetype_formatter.lua.stylua },
        ['*'] = { filetype_formatter.any.remove_trailing_whitespace },
      }

      local prettierFiletypes = { 'css', 'graphql', 'html', 'json', 'markdown', 'yaml' }
      for _, filetype in ipairs(prettierFiletypes) do
        filetypeSettings[filetype] = { filetype_formatter[filetype].prettierd }
      end

      local prettierEslintFiletypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }
      for _, filetype in ipairs(prettierEslintFiletypes) do
        filetypeSettings[filetype] = {
          filetype_formatter[filetype].prettierd,
          filetype_formatter[filetype].eslint_d,
        }
      end

      require('formatter').setup({ filetype = filetypeSettings })

      vim.keymap.set({ 'n', 'v' }, '<Leader>gq', ':FormatLock<CR>', { silent = true })

      vim.api.nvim_create_autocmd('BufWritePost', {
        group = vim.api.nvim_create_augroup('FormatOnSave', {}),
        command = 'FormatWrite',
      })
    end,
  })

  use({
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup({
        highlight = { enable = true },
      })
    end,
    run = function()
      require('nvim-treesitter.install').update({ with_sync = true })
    end,
  })

  use({
    'nvim-treesitter/nvim-treesitter-context',
    requires = { { 'nvim-treesitter/nvim-treesitter' } },
    config = function()
      require('treesitter-context').setup({
        mode = 'topline',
        separator = '-',
      })
    end,
  })

  use({
    'nvim-telescope/telescope.nvim',
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = function()
      require('telescope').setup({
        defaults = {
          sorting_strategy = 'ascending',
          layout_config = { prompt_position = 'top' },
        },
      })

      local builtin = require('telescope.builtin')
      local utils = require('telescope.utils')

      vim.keymap.set('n', '<Leader>b', builtin.buffers)
      vim.keymap.set('n', '<Leader>f', builtin.find_files)
      vim.keymap.set('n', '<Leader>F', function()
        builtin.find_files({ cwd = utils.buffer_dir() })
      end)
      vim.keymap.set('n', '<Leader>g/', builtin.live_grep)
      vim.keymap.set('n', '<Leader>G/', function()
        builtin.live_grep({ cwd = utils.buffer_dir() })
      end)
    end,
  })

  use({
    'nvim-telescope/telescope-file-browser.nvim',
    requires = { { 'nvim-telescope/telescope.nvim' } },
    config = function()
      require('telescope').load_extension('file_browser')

      local utils = require('telescope.utils')

      local file_browser_options = {
        grouped = true,
        hidden = true,
        hide_parent_dir = true,
        select_buffer = true,
      }

      vim.keymap.set('n', '<Leader>e', function()
        require('telescope').extensions.file_browser.file_browser(file_browser_options)
      end)

      vim.keymap.set('n', '<Leader>E', function()
        require('telescope').extensions.file_browser.file_browser(vim.tbl_extend('force', file_browser_options, {
          path = utils.buffer_dir(),
        }))
      end)
    end,
  })

  use({
    'folke/tokyonight.nvim',
    config = function()
      vim.cmd('colorscheme tokyonight-night')
    end,
  })

  use({ 'nvim-tree/nvim-web-devicons' })

  use({
    'echasnovski/mini.nvim',
    config = function()
      require('mini.statusline').setup({
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git = MiniStatusline.section_git({ trunc_width = 75 })
            local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
            local filename = MiniStatusline.section_filename({ trunc_width = 140 })
            local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })

            local left_separator = '〉'
            local right_separator = '〈'

            return string.format(
              ' %%#%s#%s%%#%s#%s%s%%<%%=%s%s%s ',
              mode_hl,
              mode,
              'StatusLine',
              #git > 0 and string.format(' %s%s', left_separator, git:gsub('^%s*(.-)', '')) or '',
              #filename > 0 and string.format(' %s%s', left_separator, filename) or '',
              #diagnostics > 0 and string.format('%s%s', diagnostics, right_separator) or '',
              #fileinfo > 0
                  and string.format(' %s%s ', string.gsub(fileinfo, '%s+%S+%[%S+%]', right_separator), right_separator)
                or '',
              '%p%%'
            )
          end,
        },
      })

      vim.defer_fn(function()
        vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormal', { fg = vim.g.terminal_color_15, ctermfg = 15, cterm = nil })
        vim.api.nvim_set_hl(0, 'MiniStatuslineModeVisual', { fg = vim.g.terminal_color_5, ctermfg = 5, cterm = nil })
        vim.api.nvim_set_hl(0, 'MiniStatuslineModeInsert', { fg = vim.g.terminal_color_3, ctermfg = 3, cterm = nil })
        vim.api.nvim_set_hl(0, 'MiniStatuslineModeReplace', { fg = vim.g.terminal_color_1, ctermfg = 1, cterm = nil })
        vim.api.nvim_set_hl(0, 'MiniStatuslineModeCommand', { fg = vim.g.terminal_color_3, ctermfg = 3, cterm = nil })
        vim.api.nvim_set_hl(0, 'MiniStatuslineModeOther', { fg = vim.g.terminal_color_3, ctermfg = 3, cterm = nil })

        vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { link = 'Comment' })

        vim.api.nvim_set_hl(0, 'MiniJump', { link = 'SpecialChar' })
        vim.api.nvim_set_hl(0, 'MiniJump2dSpot', { link = 'SpecialChar' })

        require('mini.align').setup()
        require('mini.comment').setup()
        require('mini.indentscope').setup({
          draw = { animation = require('mini.indentscope').gen_animation.none() },
        })
        require('mini.jump').setup({
          mappings = { repeat_jump = ',' },
        })
        require('mini.jump2d').setup({
          spotter = require('mini.jump2d').builtin_opts.word_start.spotter,
        })
        require('mini.pairs').setup()
        require('mini.splitjoin').setup()
        require('mini.surround').setup()
        require('mini.tabline').setup()
      end, 0)
    end,
  })

  use({
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        current_line_blame_opts = {
          virt_text_pos = 'right_align',
        },
        current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
      })

      vim.keymap.set('n', '<Leader>c', ':Gitsigns preview_hunk<CR>', { silent = true })
      vim.keymap.set('n', '[c', ':Gitsigns prev_hunk<CR>zz', { silent = true })
      vim.keymap.set('n', ']c', ':Gitsigns next_hunk<CR>zz', { silent = true })

      vim.keymap.set('n', '<Leader>gb', ':Gitsigns blame_line<CR>', { silent = true })
      vim.keymap.set('n', '<Leader>gg', ':Gitsigns setqflist all<CR>', { silent = true })

      vim.keymap.set({ 'n', 'v' }, '<Leader>gs', ':Gitsigns stage_hunk<CR>', { silent = true })
      vim.keymap.set({ 'n', 'v' }, '<Leader>gu', ':Gitsigns undo_stage_hunk<CR>', { silent = true })
      vim.keymap.set({ 'n', 'v' }, '<Leader>gr', ':Gitsigns reset_hunk<CR>', { silent = true })

      vim.keymap.set('n', '<Leader>gS', ':Gitsigns stage_buffer<CR>', { silent = true })
      vim.keymap.set('n', '<Leader>gU', ':Gitsigns reset_buffer_index<CR>', { silent = true })

      vim.keymap.set('n', '<Leader>gR', ':Gitsigns reset_buffer<CR>', { silent = true })
    end,
  })

  use({
    'tpope/vim-abolish',
    config = function()
      vim.keymap.set('v', '<Leader>cr', '<Plug>(abolish-coerce)')
    end,
  })

  use({
    'chaucerbao/fido.nvim',
    config = function()
      local fido = require('fido')
      fido.setup({ close_mapping = '<Leader>Q' })

      local fido_commands = require('fido.commands')
      fido_commands.shell.create({ command = 'Run' })
      fido_commands.git_blame.create({ command = 'GitBlame' })
      fido_commands.git_status.create({
        command = 'GitStatus',
        stage_mapping = '<Leader>s',
        unstage_mapping = '<Leader>S',
        refresh_mapping = '<Leader>r',
      })

      vim.keymap.set({ 'n', 'v' }, '<Leader><CR>', fido.fetch_by_filetype)
      vim.keymap.set('n', '<leader>gB', ':GitBlame<CR>', { silent = true })
    end,
  })

  if not is_packer_installed then
    require('packer').sync()
  end
end)
