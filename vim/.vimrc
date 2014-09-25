set nocompatible

" Automatically load the plug-in manager
if empty(glob('~/.vim/autoload/plug.vim')) && executable('curl')
	silent !curl --create-dirs -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Plug-ins
call plug#begin()
Plug 'editorconfig/editorconfig-vim'
Plug 'kien/ctrlp.vim'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-abolish', { 'on' : 'S' }
Plug 'tpope/vim-surround'
Plug 'Raimondi/delimitMate'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic', { 'on' : [] }
Plug 'Chiel92/vim-autoformat'
Plug 'Lokaltog/vim-easymotion', { 'on' : '<Plug>(easymotion-s2)' }
Plug 'mattn/emmet-vim', { 'on' : '<Plug>(emmet-expand-abbr)' }
Plug 'bling/vim-airline'
Plug 'altercation/vim-colors-solarized'
call plug#end()

" MatchIt plug-in
runtime macros/matchit.vim

" General settings
set spell lazyredraw splitbelow splitright nowritebackup noswapfile backspace=indent,eol,start tags=./tags;/ pastetoggle=<F2>
if has('mouse')
	set mouse=a ttymouse=xterm2
endif

" User interface
set number nowrap scrolloff=1 laststatus=2
if has('gui_running')
	set lines=40 columns=80 guioptions-=T
endif

" Color scheme
set background=dark
colorscheme solarized

" Search and replace
set ignorecase smartcase incsearch hlsearch

" Indentation
set autoindent shiftround expandtab tabstop=2 shiftwidth=2

" Folding
set nofoldenable foldmethod=indent
let javaScript_fold=1
let php_folding=1
let ruby_fold=1

" Autocomplete
set wildmenu wildmode=longest:full,full wildignore=*.jpg,*.gif,*.png,*.ico,*.gz,*/tags,*/node_modules

" Trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" File-type dependent settings
autocmd FileType php,python setlocal tabstop=4 shiftwidth=4

" Mappings
let mapleader=','
nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>
nnoremap <Leader>/ :nohlsearch<CR>
map ; :
noremap ;; ;

" Tabs
nnoremap <Leader>tn :tabnew<CR>
nnoremap <Leader>tm :tabmove<Space>
nnoremap <Leader>to :tabonly!<CR>
nnoremap <Leader>td :tabclose!<CR>

" Split window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Navigate by displayed lines when wrapped
noremap j gj
noremap k gk

" CtrlP
let g:ctrlp_working_path_mode=0
if executable('find')
	let g:ctrlp_user_command='find -E %s -type f ! \( -iregex ".*\.(jpg|gif|png|ico|gz)$" -or -iregex ".*/(tags$|node_modules/.*|\..*)" \)'
endif

" NERD Commenter
let NERDSpaceDelims=1

" Autoformat
if executable('sass-convert')
	let g:formatprg_scss="sass-convert"
	let g:formatprg_args_expr_scss='"-F scss -T scss --indent " . (&expandtab ? &shiftwidth : "t")'
endif
nnoremap <Leader>gq :Autoformat<CR>

" EasyMotion
let g:EasyMotion_startofline=0
highlight link EasyMotionTarget2First EasyMotionTarget
highlight link EasyMotionTarget2Second EasyMotionTarget
map s <Plug>(easymotion-s2)

" Emmet
function! s:smart_tab_completion()
	let line=getline('.')
	let to_cursor=strpart(line, 0, col('.') - 1)
	let previous_character=matchstr(to_cursor, '[^ \t">]$')

	if (strlen(previous_character) > 0)
		return "\<Plug>(emmet-expand-abbr)"
	endif

	return "\<Tab>"
endfunction
imap <expr><Tab> <SID>smart_tab_completion()
let g:user_emmet_mode='i'

" On-demand loading for Syntastic
augroup loadSyntastic
	autocmd!
	autocmd BufWritePre * call plug#load('syntastic') | autocmd! loadSyntastic
augroup end
