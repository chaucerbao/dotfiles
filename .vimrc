" Automatically load the plug-in manager
let s:pluginsInstalled=1
if empty(glob('~/.vim/autoload/plug.vim')) && executable('curl')
	let s:pluginsInstalled=0
	silent !curl --create-dirs -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Plug-ins
call plug#begin()

" Themes
Plug 'arcticicestudio/nord-vim'
Plug 'itchyny/lightline.vim'

" File navigation
Plug 'justinmk/vim-dirvish'
Plug 'junegunn/fzf', { 'on': 'FZF', 'dir': '~/.fzf', 'do': './install --all' }

" Programming
Plug 'dense-analysis/ale'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'machakann/vim-sandwich'
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'diepm/vim-rest-console', { 'for': 'rest' }

" Helpers
Plug 'tpope/vim-abolish', { 'on': ['S', '<Plug>(abolish-coerce-word)'] }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'junegunn/vim-easy-align', { 'on': '<Plug>(EasyAlign)' }
Plug 'chaucerbao/vim-onetab'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-repeat'

" File types
Plug 'sheerun/vim-polyglot'

" Tools
Plug 'vimwiki/vimwiki', { 'on': ['<Plug>VimwikiIndex', '<Plug>VimwikiTabIndex', '<Plug>VimwikiUISelect'] }

call plug#end()

" Install plug-ins if needed
if s:pluginsInstalled == 0 | :PlugInstall | endif
unlet s:pluginsInstalled

" MatchIt plug-in
if !has('nvim') | packadd! matchit | endif

" Color scheme
let g:nord_uniform_diff_background=1
colorscheme nord

" General settings
set confirm hidden lazyredraw spell splitbelow splitright noswapfile nowritebackup encoding=utf-8 backspace=indent,eol,start list listchars=tab:»·,trail:· mouse=a tags=./tags;,tags
if has('mouse') && !has('nvim') | set ttymouse=xterm2 | endif
if executable('rg') | let s:grepCommand='rg' | elseif executable('ag') | let s:grepCommand='ag' | endif
if exists('s:grepCommand') | let &grepprg=s:grepCommand.' --vimgrep' | set grepformat=%f:%l:%c:%m | unlet s:grepCommand | endif

" User interface
set number nowrap scrolloff=1 laststatus=2

" Folding
set nofoldenable foldmethod=indent

" Indentation
set autoindent smarttab shiftround expandtab tabstop=2 shiftwidth=2

" Search and replace
set ignorecase smartcase incsearch hlsearch

" Autocompletion
set complete-=t,i
set completeopt=longest,menuone
set wildmenu wildmode=longest:full,full

" Diff
set diffopt+=hiddenoff,vertical

" Trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Open QuickFix/Location List automatically
autocmd QuickFixCmdPost [^l]* cwindow
autocmd QuickFixCmdPost l* lwindow

" Mappings
let mapleader=' '
nnoremap <Leader>cd :lcd %:p:h<CR>:pwd<CR>
nnoremap <Leader>/ :nohlsearch<CR>
nnoremap <Leader>r :redraw!<CR>
nnoremap ; : | nnoremap : ; | vnoremap ; : | vnoremap : ;

" Yank/paste using the system clipboard
nnoremap <Leader>y "*y | xnoremap <Leader>y "*y
nnoremap <Leader>p "*p | xnoremap <Leader>p "*p
nnoremap <Leader>P "*P | xnoremap <Leader>P "*P

" Change/delete to black hole register
nnoremap <Leader>c "_c | xnoremap <Leader>c "_c
nnoremap <Leader>d "_d | xnoremap <Leader>d "_d
nnoremap <Leader>x "_x | xnoremap <Leader>x "_x

" Star search
nnoremap * /\V\<<C-r>=expand('<cword>')<CR>\>\C<CR>
nnoremap # ?\V\<<C-r>=expand('<cword>')<CR>\>\C<CR>
vnoremap * "9y/\V<C-r>=escape(@9, '/\')<CR>\C<CR>
vnoremap # "9y?\V<C-r>=escape(@9, '/\')<CR>\C<CR>
nnoremap <Leader>* :let @/=expand('<cword>')<CR>:silent execute 'grep -F "'.expand('<cword>').'"'<CR>:set hlsearch<CR>:redraw!<CR>
vnoremap <Leader>* "9y:let @/=@9<CR>:silent execute 'grep -F "'.@9.'"'<CR>:set hlsearch<CR>:redraw!<CR>

" Navigate by displayed lines when wrapped
noremap j gj
noremap k gk

" Buffer navigation
nnoremap gb :buffers<CR>:buffer<Space>

" Tab navigation
nnoremap <Leader><Tab> :$tabnew<CR>

" Split window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Insert mode navigation
inoremap <C-a> <Esc>I
inoremap <expr> <C-e> pumvisible() ? "\<C-e>" : "\<Esc>A"
inoremap <expr> <Enter> pumvisible() ? "\<C-y>" : "\<Enter>"

" Quickfix/Location list navigation
nnoremap [q :cprevious<CR>zz| nnoremap ]q :cnext<CR>zz| nnoremap [Q :cfirst<CR>zz| nnoremap ]Q :clast<CR>zz
nnoremap [l :lprevious<CR>zz| nnoremap ]l :lnext<CR>zz| nnoremap [L :lfirst<CR>zz| nnoremap ]L :llast<CR>zz

" Lightline
let g:lightline={
	\'colorscheme': 'nord',
	\'active': { 'left': [['mode', 'paste'], ['gitbranch', 'filename', 'readonly', 'modified']] },
	\'component': { 'lineinfo': '%3l:%-2v' },
	\'component_function': { 'gitbranch': 'fugitive#head' },
	\'separator': { 'left': '', 'right': '' },
	\'subseparator': { 'left': '', 'right': '' }
\}

" Dirvish
let g:dirvish_relative_paths=1
autocmd FileType dirvish setlocal nospell

" FZF Fuzzy Finder
nnoremap <Leader>f :FZF -m<CR>

" Asynchronous Lint Engine
nnoremap <Leader>gq :ALEFix<CR>
nnoremap <Leader>gi :ALEOrganizeImports<CR>
nnoremap <Leader>K :ALEDetail<CR>
nnoremap K :ALEHover<CR>
nnoremap gD :ALEFindReferences -relative<CR>
nnoremap gd :ALEGoToDefinition<CR>
nnoremap <F2> :ALERename<CR>
nnoremap [e :ALEPreviousWrap<CR>zz| nnoremap ]e :ALENextWrap<CR>zz| nnoremap [E :ALEFirst<CR>zz| nnoremap ]E :ALELast<CR>zz
let g:ale_completion_enabled=1
let g:ale_completion_tsserver_autoimport=1
let g:ale_sign_error='✖'
let g:ale_sign_warning='▵'
let g:ale_fixers={
	\'*': ['remove_trailing_lines', 'trim_whitespace'],
	\'css': ['prettier', 'stylelint'],
	\'html': ['prettier'],
	\'javascript': ['prettier', 'eslint'],
	\'json': ['prettier'],
	\'markdown': ['prettier'],
	\'scss': ['prettier', 'stylelint'],
	\'typescript': ['prettier', 'tslint'],
	\'typescriptreact': ['prettier', 'tslint']
\}

" Sandwich
runtime macros/sandwich/keymap/surround.vim

" Close Tags
let g:closetag_filetypes='html,javascript,typescriptreact'

" REST Console
let g:vrc_curl_opts={
	\'--include': '',
	\'--location': '',
	\'--show-error': '',
	\'--silent': ''
\}

" Abolish
nmap cr <Plug>(abolish-coerce-word)

" Undotree
nnoremap <Leader>u :UndotreeToggle<CR>

" EasyAlign
nmap ga <Plug>(EasyAlign)| xmap ga <Plug>(EasyAlign)

" OneTab
let g:onetab=['tab', 'abbrev', 'file', 'keyword', 'dictionary']

" Sneak
map f <Plug>Sneak_f| map F <Plug>Sneak_F| sunmap f| sunmap F
map t <Plug>Sneak_t| map T <Plug>Sneak_T| sunmap t| sunmap T
let g:sneak#label=1
let g:sneak#s_next=1

" VimWiki
nmap <silent><unique> <Leader>ww <Plug>VimwikiIndex
nmap <silent><unique> <Leader>wt <Plug>VimwikiTabIndex
nmap <silent><unique> <Leader>ws <Plug>VimwikiUISelect
