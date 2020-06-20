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

" File navigation
Plug 'junegunn/fzf', { 'on': 'FZF', 'dir': '~/.fzf', 'do': { -> fzf#install() } }

" Programming
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
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
set confirm hidden lazyredraw spell splitbelow splitright noswapfile nowritebackup encoding=utf-8 backspace=indent,eol,start list listchars=tab:»·,trail:· mouse=a tags=./tags;,tags updatetime=300
if has('mouse') && !has('nvim') | set ttymouse=xterm2 | endif
if executable('rg') | let s:grepCommand='rg' | elseif executable('ag') | let s:grepCommand='ag' | endif
if exists('s:grepCommand') | let &grepprg=s:grepCommand.' --vimgrep' | set grepformat=%f:%l:%c:%m | unlet s:grepCommand | endif

" User interface
set number nowrap scrolloff=1 laststatus=2

" Status line
function! StlMode() abort
	let l:mode = mode()
	let l:statusline=' '

	if l:mode=~'^n'
		let l:statusline.='%#StlModeNormal#NORMAL%*'
	elseif l:mode=~#'^i'
		let l:statusline.='%#StlModeInsert#INSERT%*'
	elseif l:mode=~?'^[v|]'
		let l:statusline.='%#StlModeVisual#VISUAL%*'
	elseif l:mode=~?'^[s|]'
		let l:statusline.='%#StlModeSelect#SELECT%*'
	elseif l:mode=~#'^R'
		let l:statusline.='%#StlModeReplace#REPLACE%*'
	else
		let l:statusline.=l:mode
	endif

	let l:statusline.=' 〉'

	return l:statusline
endfunction

function! StatusLine() abort
	let l:statusline=StlMode()
	let l:statusline.='%(%{fugitive#head()} 〉%)'
	let l:statusline.='%t'
	let l:statusline.='%( 〉%R%)'
	let l:statusline.='%( 〉%M%)'
	let l:statusline.='%='
	let l:statusline.='%(%{&filetype}〈 %)'
	let l:statusline.='%l:%c〈 %p%% '

	return l:statusline
endfunction

highlight StlModeNormal term=bold,reverse ctermfg=15 ctermbg=8 guifg=#ECEFF4 guibg=#4C566A
highlight StlModeInsert term=bold,reverse ctermfg=3 ctermbg=8 guifg=#EBCB8B guibg=#4C566A
highlight StlModeVisual term=bold,reverse ctermfg=5 ctermbg=8 guifg=#B48EAD guibg=#4C566A
highlight StlModeSelect term=bold,reverse ctermfg=13 ctermbg=8 guifg=#B48EAD guibg=#4C566A
highlight StlModeReplace term=bold,reverse ctermfg=1 ctermbg=8 guifg=#BF616A guibg=#4C566A
set statusline=%!StatusLine()

" CursorLine
augroup CursorLine
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

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

" Smart Tab
function s:isBeginningOfLine()
  return strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
endfunction
inoremap <expr> <Tab> <SID>isBeginningOfLine() ? '<Tab>' : pumvisible() ? '<C-n>' : '<C-]>'
inoremap <expr> <S-Tab> <SID>isBeginningOfLine() ? '<C-d>' : pumvisible() ? '<C-p>' : '<C-]>'

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

" Directory navigation
let g:netrw_banner=0
let g:netrw_bufsettings='number'
let g:netrw_fastbrowse=0
let g:netrw_preview=1
let g:netrw_alto=0
nnoremap - :Explore<CR>

" Buffer navigation
nnoremap gb :buffers<CR>:buffer<Space>
nnoremap <Tab> :bnext<CR>| nnoremap <S-Tab> :bprevious<CR>

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

" FZF Fuzzy Finder
nnoremap <Leader>f :FZF -m<CR>

" Conquer of Completion
let g:coc_global_extensions=['coc-eslint', 'coc-json', 'coc-prettier', 'coc-tsserver']
nmap <silent> <F2> <Plug>(coc-rename)
nmap <silent> <Leader>gq <Plug>(coc-format)| xmap <silent> <Leader>gq <Plug>(coc-format-selected)
nnoremap <silent> <Leader>i :call CocAction('runCommand', 'editor.action.organizeImport')<CR>
nnoremap <silent> <Leader><Enter> :CocList commands<CR>| xmap <silent> <Leader><Enter> <Plug>(coc-codeaction-selected)
nnoremap <silent> [g :call CocAction('diagnosticPrevious')<CR>zz| nnoremap <silent> ]g :call CocAction('diagnosticNext')<CR>zz
nnoremap <silent> gd :call CocAction('jumpDefinition')<CR>zz| nmap <silent> gD <Plug>(coc-references)
nnoremap <silent> K :call CocActionAsync('doHover')<CR>

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

" Sneak
let g:sneak#label=1
let g:sneak#s_next=1
map f <Plug>Sneak_f| map F <Plug>Sneak_F| sunmap f| sunmap F
map t <Plug>Sneak_t| map T <Plug>Sneak_T| sunmap t| sunmap T

" VimWiki
nmap <silent> <Leader>ww <Plug>VimwikiIndex
nmap <silent> <Leader>wt <Plug>VimwikiTabIndex
nmap <silent> <Leader>ws <Plug>VimwikiUISelect
