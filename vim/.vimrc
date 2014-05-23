" Vundle plug-in manager
set nocompatible
filetype off

set runtimepath+=~/.vim/bundle/vundle/
call vundle#begin()
Plugin 'gmarik/vundle'

Plugin 'editorconfig/editorconfig-vim'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-vinegar'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-surround'
Plugin 'Raimondi/delimitMate'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'
Plugin 'Chiel92/vim-autoformat'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'mattn/emmet-vim'
Plugin 'sjl/gundo.vim'
Plugin 'bling/vim-airline'
Plugin 'altercation/vim-colors-solarized'
call vundle#end()

filetype plugin indent on

" MatchIt plug-in
runtime macros/matchit.vim

" General settings
set spell noswapfile splitbelow splitright backspace=indent,eol,start
if has('mouse')
	set mouse=a ttymouse=xterm2
endif

" User interface
set number nowrap scrolloff=1 laststatus=2
if has('gui_running')
	set lines=40 columns=80 guioptions-=T
endif

" Color scheme
syntax enable
set background=dark
colorscheme solarized

" Search and replace
set ignorecase smartcase hlsearch

" Indentation
set autoindent shiftround expandtab tabstop=2 shiftwidth=2

" Autocomplete
set wildmenu wildmode=longest:full,full wildignore=*.jpg,*.gif,*.png,*.ico,*.gz,*/node_modules

" Trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" File-type dependent settings
autocmd FileType php,cf,html,css,scss,javascript set foldmethod=indent nofoldenable autoindent
autocmd FileType php,python set tabstop=4 shiftwidth=4
autocmd FileType ruby set foldmethod=syntax nofoldenable

" Tags
set tags=./tags;/

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

" Paste toggle
set pastetoggle=<F2>

" CtrlP settings
let g:ctrlp_working_path_mode=0
if executable('find') && executable('grep')
	let g:ctrlp_user_command = 'find %s -type f | grep -v -E ".jpg$|.gif$|.png$|.ico$|.gz$|node_modules/|/\."'
endif

" Pad comments with a space
let NERDSpaceDelims=1

" Autoformat settings
if executable('sass-convert')
	let g:formatprg_scss = "sass-convert"
	let g:formatprg_args_expr_scss = '"-F scss -T scss --indent " . (&expandtab ? &shiftwidth : "t")'
endif
nnoremap <Leader>gq :Autoformat<CR>

" EasyMotion mappings
let g:EasyMotion_startofline=0
highlight link EasyMotionTarget2First EasyMotionTarget
highlight link EasyMotionTarget2Second EasyMotionTarget
map s <Plug>(easymotion-s2)

" Smart tab completion for Emmet
function! s:smart_tab_completion()
	let line = getline('.')
	let to_cursor = strpart(line, 0, col('.') - 1)
	let previous_character = matchstr(to_cursor, '[^ \t">]$')

	if (strlen(previous_character) > 0)
		return "\<Plug>(emmet-expand-abbr)"
	endif

	return "\<Tab>"
endfunction
imap <expr><Tab> <SID>smart_tab_completion()
let g:user_emmet_mode='i'

" Gundo mappings
nnoremap <Leader>u :GundoToggle<CR>
