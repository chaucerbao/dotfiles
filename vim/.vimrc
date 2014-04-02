" Vundle plug-in manager
set nocompatible
filetype off

set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()

Plugin 'gmarik/vundle'

Plugin 'altercation/vim-colors-solarized'
Plugin 'bling/vim-airline'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'kien/ctrlp.vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'Raimondi/delimitMate'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdcommenter'
Plugin 'junegunn/vim-easy-align'
Plugin 'scrooloose/syntastic'
Plugin 'mattn/emmet-vim'
Plugin 'maksimr/vim-jsbeautify'

filetype plugin indent on

" MatchIt plug-in
runtime macros/matchit.vim

" Netrw plug-in
let g:netrw_liststyle=1

" General settings
set spell noswapfile splitbelow splitright backspace=indent,eol,start
if has("mouse")
	set mouse=a ttymouse=xterm2
endif

" User interface
set number nowrap scrolloff=1 laststatus=2
if has("gui_running")
	set lines=40 columns=80 guioptions-=T
endif

" Color scheme
syntax enable
set background=dark
colorscheme solarized

" Search and replace
set ignorecase smartcase hlsearch

" Indentation
set autoindent shiftround tabstop=2 shiftwidth=2

" Autocomplete
set wildmenu wildmode=longest:full,full wildignore=*.jpg,*.gif,*.png,*.swf,*.gz,*.swp,*/node_modules,.git/*,.svn/*,.DS_Store,Thumbs.db

" Trim trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" File-type dependent settings
autocmd FileType php,cf,html,css,scss,javascript set foldmethod=indent nofoldenable autoindent
autocmd FileType ruby set foldmethod=syntax nofoldenable

" Tags
set tags=./tags;/

" Mappings
let mapleader=","
nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>
nnoremap <Leader>/ :nohlsearch<CR>
nnoremap ; :
nnoremap : ;

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

" Cut, Copy, and Paste for Windows environments
if has('win32') || has('win64')
	vnoremap <C-x> "+x
	vnoremap <C-c> "+y
	map <C-v> "+gP
	cmap <C-v> <C-r>+
	exe 'inoremap <script> <C-v> <C-g>u' . paste#paste_cmd['i']
endif

" Don't let CtrlP manage the working directory
let g:ctrlp_working_path_mode=0

" Pad comments with a space
let NERDSpaceDelims=1

" EasyMotion mappings
let g:EasyMotion_startofline=0
map s <Plug>(easymotion-s2)
map <Leader>h <Plug>(easymotion-linebackward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>l <Plug>(easymotion-lineforward)

" EasyAlign mappings
vmap <Enter> <Plug>(EasyAlign)

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

" JsBeautify mappings
autocmd FileType javascript nnoremap <buffer> <Leader>b :call JsBeautify()<CR>
autocmd FileType html nnoremap <buffer> <Leader>b :call HtmlBeautify()<CR>
autocmd FileType scss,css nnoremap <buffer> <Leader>b :call CSSBeautify()<CR>

autocmd FileType javascript vnoremap <buffer> <Leader>b :call RangeJsBeautify()<CR>
autocmd FileType html vnoremap <buffer> <Leader>b :call RangeHtmlBeautify()<CR>
autocmd FileType scss,css vnoremap <buffer> <Leader>b :call RangeCSSBeautify()<CR>
