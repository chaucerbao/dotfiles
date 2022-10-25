local packer_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local is_packer_installed = vim.fn.empty(vim.fn.glob(packer_path)) == 0

if not is_packer_installed then
  vim.fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', packer_path })
  vim.cmd('packadd! packer.nvim')
end

require('packer').startup(function(use)
  use('wbthomason/packer.nvim')

  use({
    'neovim/nvim-lspconfig',
    config = function()
      local on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        local buffer_options = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, buffer_options)
        vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, buffer_options)
        vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, buffer_options)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, buffer_options)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, buffer_options)
        vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, buffer_options)
        vim.keymap.set({ 'n', 'v' }, '<Leader> ', vim.lsp.buf.code_action, buffer_options)
        vim.keymap.set({ 'n', 'v' }, '<Leader>gq', function() vim.lsp.buf.format({ async = true }) end, buffer_options)
      end

      local language_servers = { tsserver = 'typescript-language-server' }
      for server, binary in pairs(language_servers) do
        if vim.fn.executable(binary) then require('lspconfig')[server].setup({ on_attach = on_attach }) end
      end

      local snippet_servers = {
        cssls = 'vscode-css-language-server',
        html = 'vscode-html-language-server',
        jsonls = 'vscode-json-language-server',
      }
      for server, binary in pairs(snippet_servers) do
        if vim.fn.executable(binary) then
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities.textDocument.completion.completionItem.snippetSupport = true

          require('lspconfig')[server].setup({ capabilities = capabilities })
        end
      end

      if vim.fn.executable('vscode-eslint-language-server') then
        require('lspconfig').eslint.setup({
          on_attach = function()
            vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
              group = vim.api.nvim_create_augroup('FormatOnSave', {}),
              pattern = { '*.js', '*.jsx', '*.ts', '*.tsx' },
              command = 'EslintFixAll',
            })
          end,
        })
      end
    end,
  })

  use({
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
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

      vim.keymap.set('n', '<Leader>b', builtin.buffers)
      vim.keymap.set('n', '<Leader>f', builtin.find_files)
    end,
  })

  use({
    'nvim-telescope/telescope-file-browser.nvim',
    requires = { { 'nvim-telescope/telescope.nvim' } },
    config = function()
      require('telescope').load_extension('file_browser')

      vim.keymap.set(
        'n',
        '<Leader>e',
        function()
          require('telescope').extensions.file_browser.file_browser({
            path = '%:p:h',
            grouped = true,
            select_buffer = true,
          })
        end
      )
    end,
  })

  use({
    'arcticicestudio/nord-vim',
    config = function()
      vim.g.nord_uniform_diff_background = 1
      vim.g.nord_uniform_status_lines = 1
      vim.cmd('colorscheme nord')
    end,
  })

  use({
    'echasnovski/mini.nvim',
    config = function()
      require('mini.statusline').setup({
        use_icons = false,
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
              ' %%#%s#%s%%#%s#%s%s%%<%s%%=%s%s ',
              mode_hl,
              mode,
              'StatusLine',
              #git > 0 and string.format(' %s%s', left_separator, git) or '',
              #diagnostics > 0 and string.format(' %s%s', left_separator, diagnostics) or '',
              #filename > 0 and string.format(' %s%s', left_separator, filename) or '',
              #fileinfo > 0
                  and string.format(' %s%s ', string.gsub(fileinfo, '%s+%S+%[%S+%]', right_separator), right_separator)
                or '',
              '%p%%'
            )
          end,
        },
      })

      vim.defer_fn(function()
        vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormal', { ctermfg = 15, ctermbg = 8, cterm = nil })
        vim.api.nvim_set_hl(0, 'MiniStatuslineModeVisual', { ctermfg = 5, ctermbg = 8, cterm = nil })
        vim.api.nvim_set_hl(0, 'MiniStatuslineModeInsert', { ctermfg = 3, ctermbg = 8, cterm = nil })
        vim.api.nvim_set_hl(0, 'MiniStatuslineModeReplace', { ctermfg = 1, ctermbg = 8, cterm = nil })
        vim.api.nvim_set_hl(0, 'MiniStatuslineModeCommand', { ctermfg = 3, ctermbg = 8, cterm = nil })
        vim.api.nvim_set_hl(0, 'MiniStatuslineModeOther', { ctermfg = 3, ctermbg = 8, cterm = nil })

        require('mini.comment').setup()
        require('mini.completion').setup()
        require('mini.pairs').setup()
        require('mini.surround').setup()
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
    end,
  })

  use({
    'tpope/vim-abolish',
    config = function() vim.keymap.set('v', '<Leader>cr', '<Plug>(abolish-coerce)') end,
  })

  use({
    'vimwiki/vimwiki',
    config = function()
      vim.g.vimwiki_list = {
        {
          path = '~/Library/Mobile Documents/com~apple~CloudDocs/Wiki/',
          nested_syntaxes = { javascript = 'javascript' },
        },
      }
    end,
  })

  if not is_packer_installed then require('packer').sync() end
end)
