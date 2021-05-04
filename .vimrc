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
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': { -> fzf#install() } }
Plug 'justinmk/vim-dirvish'

" Programming
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'machakann/vim-sandwich'
Plug 'jiangmiao/auto-pairs'
Plug 'alvan/vim-closetag'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'diepm/vim-rest-console', { 'for': 'rest' }
Plug 'tpope/vim-dadbod', { 'for': 'sql' }

" Helpers
Plug 'chrisbra/NrrwRgn', { 'on': ['<Plug>NrrwrgnDo', '<Plug>NrrwrgnBangDo'] }
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'junegunn/vim-easy-align', { 'on': '<Plug>(EasyAlign)' }
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-abolish'
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
if has('nvim') | set guicursor= | endif
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

" Open QuickFix/Location List automatically
autocmd QuickFixCmdPost [^l]* cwindow
autocmd QuickFixCmdPost l* lwindow

" Mappings
let mapleader=' '
nnoremap <Leader>cd :lcd %:p:h<CR>:pwd<CR>
nnoremap <Leader>/ :nohlsearch<CR>
nnoremap <Leader>r :redraw!<CR>
nnoremap ; :| nnoremap : ;| vnoremap ; :| vnoremap : ;
nnoremap n nzz| nnoremap N Nzz

" Smart Tab
function s:isBeginningOfLine()
  return strpart(getline('.'), 0, col('.') - 1) =~ '^\s*$'
endfunction
inoremap <expr> <Tab> <SID>isBeginningOfLine() ? '<Tab>' : pumvisible() ? '<C-n>' : '<C-]>'
inoremap <expr> <S-Tab> <SID>isBeginningOfLine() ? '<C-d>' : pumvisible() ? '<C-p>' : '<C-]>'

" Yank/paste using the system clipboard
nnoremap <Leader>y "*y| xnoremap <Leader>y "*y
nnoremap <Leader>p "*p| xnoremap <Leader>p "*p
nnoremap <Leader>P "*P| xnoremap <Leader>P "*P

" Change/delete to black hole register
nnoremap <Leader>c "_c| xnoremap <Leader>c "_c
nnoremap <Leader>d "_d| xnoremap <Leader>d "_d
nnoremap <Leader>x "_x| xnoremap <Leader>x "_x

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
function! s:listBuffers() abort
	redir => ls
	silent ls
	redir END

	return split(ls, '\n')
endfunction

function! s:openBuffer(query) abort
	execute 'buffer' matchstr(a:query, '^[ 0-9]*')
endfunction

nnoremap <silent> <Leader>b :call fzf#run({
	\'source': reverse(<SID>listBuffers()),
	\'sink': function('<SID>openBuffer'),
	\'options': '+m',
	\'down': len(<SID>listBuffers()) + 2
\})<CR>
nnoremap <Tab> :bnext<CR>| nnoremap <S-Tab> :bprevious<CR>
nnoremap <Leader>o :%bdelete\|edit#\|bdelete#<CR>

" Tab navigation
nnoremap g<Tab> :$tabnew<CR>
nnoremap <Leader><Tab> :tab split<CR>

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
function! ToggleList(list, open, close)
	if empty(filter(getwininfo(), 'v:val.'.a:list))
		try
			execute a:open
		catch
			echo "List is empty"
		endtry
	else
		execute a:close
	end
endfunction

nnoremap <Leader>q :call ToggleList('quickfix', 'copen', 'cclose')<CR>
nnoremap <Leader>l :call ToggleList('loclist', 'lopen', 'lclose')<CR>
nnoremap [q :cprevious<CR>zz| nnoremap ]q :cnext<CR>zz| nnoremap [Q :cabove<CR>zz| nnoremap ]Q :cbelow<CR>zz
autocmd FileType qf nnoremap <CR> :execute 'wincmd p \| cc '.line('.')<CR>

" FZF Fuzzy Finder
nnoremap <Leader>f :FZF -m<CR>

" Dirvish
let g:loaded_netrwPlugin=1
let g:dirvish_mode=':sort ,^.*[\/],'

" Conquer of Completion
let g:coc_global_extensions=['coc-eslint', 'coc-json', 'coc-prettier', 'coc-tsserver']
nmap <F2> <Plug>(coc-rename)
nmap <Leader>gq <Plug>(coc-format)| xmap <Leader>gq <Plug>(coc-format-selected)
nnoremap <Leader>i :call CocAction('runCommand', 'editor.action.organizeImport')<CR>
nnoremap [g :call CocActionAsync('diagnosticPrevious')<CR>zz| nnoremap ]g :call CocActionAsync('diagnosticNext')<CR>zz
nnoremap gd :call CocActionAsync('jumpDefinition')<CR>zz| nmap gD <Plug>(coc-references)
nnoremap <Leader>gd :call CocActionAsync('jumpDefinition', 'vsplit')<CR>zz
nnoremap K :call CocActionAsync('doHover')<CR>
if exists('&tagfunc')
	set tagfunc=CocTagFunc
	nnoremap gd <C-]>zz
	nnoremap <Leader>gd <C-w>v<C-]>zz
endif

" Sandwich
runtime macros/sandwich/keymap/surround.vim

" Auto Pairs
let g:AutoPairsMultilineClose=0

" Close Tags
let g:closetag_filetypes='html,javascript,typescriptreact'

" REST Console
let g:vrc_curl_opts={
	\'--include': '',
	\'--location': '',
	\'--show-error': '',
	\'--silent': ''
\}

" Dadbod
autocmd FileType sql nnoremap <buffer> <CR> :%DB<CR>
autocmd FileType sql vnoremap <buffer> <CR> :DB<CR>

" NrrwRgn
xmap <Leader>nr <Plug>NrrwrgnDo| nmap <Leader>nr <Plug>NrrwrgnDo
xmap <Leader>Nr <Plug>NrrwrgnBangDo

" Undotree
nnoremap <Leader>u :UndotreeToggle<CR>

" EasyAlign
nmap ga <Plug>(EasyAlign)| xmap ga <Plug>(EasyAlign)

" Sneak
let g:sneak#label=1
let g:sneak#s_next=1
map f <Plug>Sneak_f| map F <Plug>Sneak_F| sunmap f| sunmap F
map t <Plug>Sneak_t| map T <Plug>Sneak_T| sunmap t| sunmap T

" Abolish
vmap <Leader>cr <Plug>(abolish-coerce)

" VimWiki
nmap <Leader>ww <Plug>VimwikiIndex
nmap <Leader>wt <Plug>VimwikiTabIndex
nmap <Leader>ws <Plug>VimwikiUISelect
