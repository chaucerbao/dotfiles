" Automatically load the plug-in manager
let s:pluginsInstalled=1
if empty(glob('~/.vim/autoload/plug.vim')) && executable('curl')
  let s:pluginsInstalled=0
  silent !curl --create-dirs -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Plug-ins
call plug#begin()

" Color scheme
Plug 'arcticicestudio/nord-vim'

" File navigation
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': { -> fzf#install() } }
Plug 'justinmk/vim-dirvish', { 'on': '<Plug>(dirvish_up)' }

" General
Plug 'tpope/vim-abolish'
Plug 'justinmk/vim-sneak', { 'on': ['<Plug>Sneak_s', '<Plug>Sneak_S', '<Plug>Sneak_f', '<Plug>Sneak_F', '<Plug>Sneak_t', '<Plug>Sneak_T'] }
Plug 'junegunn/vim-easy-align', { 'on': '<Plug>(EasyAlign)' }

" Programming
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'tpope/vim-commentary'
Plug 'jiangmiao/auto-pairs'
Plug 'machakann/vim-sandwich'
Plug 'alvan/vim-closetag', { 'for': ['html', 'javascriptreact', 'typescriptreact'] }
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dadbod', { 'for': 'sql' }
Plug 'diepm/vim-rest-console', { 'for': 'rest' }
Plug 'sheerun/vim-polyglot'

" Tools
Plug 'vimwiki/vimwiki', { 'on': ['<Plug>VimwikiIndex', '<Plug>VimwikiTabIndex'] }

call plug#end()

" Install plug-ins if needed
if s:pluginsInstalled == 0 | :PlugInstall | endif
unlet s:pluginsInstalled

" MatchIt plug-in
if !has('nvim') | packadd! matchit | endif

" General settings
set confirm hidden spell nojoinspaces noswapfile nowritebackup mouse=a updatetime=300
if has('nvim') | set guicursor= | endif
if has('mouse') && !has('nvim') | set ttymouse=xterm2 | endif
if executable('rg') | let &grepprg='rg --vimgrep' | set grepformat=%f:%l:%c:%m | endif

" Interface
set number breakindent linebreak nowrap splitbelow splitright fillchars=vert:│ list listchars=tab:»·,trail:·,nbsp:◡ signcolumn=number scrolloff=1 laststatus=2

" Color scheme
let g:nord_uniform_diff_background=1
colorscheme nord

" Status line
function! StlMode() abort
  let l:statusmode=''
  let l:is_active=g:statusline_winid == win_getid(winnr())
  let l:mode = mode()

  if l:mode=~'^n'
    if l:is_active | let l:statusmode.='%#StlModeWhite#' | endif
    let l:statusmode.='NORMAL'
  elseif l:mode=~?'^[v|]'
    if l:is_active | let l:statusmode.='%#StlModeMagenta#' | endif
    let l:statusmode.='VISUAL'
  elseif l:mode=~?'^[s|]'
    if l:is_active | let l:statusmode.='%#StlModeMagenta#' | endif
    let l:statusmode.='SELECT'
  elseif l:mode=~#'^i'
    if l:is_active | let l:statusmode.='%#StlModeYellow#' | endif
    let l:statusmode.='INSERT'
  elseif l:mode=~#'^R'
    if l:is_active | let l:statusmode.='%#StlModeRed#' | endif
    let l:statusmode.='REPLACE'
  elseif l:mode=~#'^c'
    if l:is_active | let l:statusmode.='%#StlModeYellow#' | endif
    let l:statusmode.='COMMAND'
  elseif l:mode=~#'^r'
    if l:is_active | let l:statusmode.='%#StlModeYellow#' | endif
    let l:statusmode.='PROMPT'
  elseif l:mode=~#'^!'
    if l:is_active | let l:statusmode.='%#StlModeWhite#' | endif
    let l:statusmode.='SHELL'
  elseif l:mode=~#'^t'
    if l:is_active | let l:statusmode.='%#StlModeWhite#' | endif
    let l:statusmode.='TERMINAL'
  else
    if l:is_active | let l:statusmode.='%#StlModeWhite#' | endif
    let l:statusmode.=l:mode
  endif

  let l:statusmode.='%*'

  return l:statusmode
endfunction

function! StatusLine() abort
  let l:statusline=' '
  let l:statusline.=StlMode()
  let l:statusline.='%( 〉%{fugitive#head()}%)'
  let l:statusline.=' 〉%t'
  let l:statusline.='%( 〉%R%)'
  let l:statusline.='%( 〉%M%)'
  let l:statusline.='%='
  let l:statusline.='%(%{&filetype}〈 %)'
  let l:statusline.='%l:%c〈 '
  let l:statusline.='%p%%'
  let l:statusline.=' '

  return l:statusline
endfunction

highlight StlModeWhite ctermfg=15 ctermbg=8 guifg=#ECEFF4 guibg=#4C566A
highlight StlModeYellow ctermfg=3 ctermbg=8 guifg=#EBCB8B guibg=#4C566A
highlight StlModeMagenta ctermfg=5 ctermbg=8 guifg=#B48EAD guibg=#4C566A
highlight StlModeRed ctermfg=1 ctermbg=8 guifg=#BF616A guibg=#4C566A

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
set smarttab shiftround expandtab tabstop=2 shiftwidth=0

" Search and replace
set ignorecase smartcase incsearch hlsearch
if has('nvim') | set inccommand=nosplit | endif

" Autocompletion
set complete-=t,i
set completeopt=longest,menuone
set wildmenu wildmode=longest:full,full

" Diff
set diffopt+=hiddenoff,vertical

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
inoremap <expr> <Tab> <SID>isBeginningOfLine() ? '<C-i>' : pumvisible() ? '<C-n>' : '<C-]>'
inoremap <expr> <S-Tab> <SID>isBeginningOfLine() ? '<C-d>' : pumvisible() ? '<C-p>' : '<C-]>'

" Yank/paste using the system clipboard
nnoremap <Leader>y "+y| xnoremap <Leader>y "+y
nnoremap <Leader>p "+p| xnoremap <Leader>p "+p
nnoremap <Leader>P "+P| xnoremap <Leader>P "+P

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
noremap <expr> j v:count > 0 ? 'j' : 'gj'
noremap <expr> k v:count > 0 ? 'k' : 'gk'

" Buffer list navigation
function! s:listBuffers() abort
  redir => ls
  silent ls
  redir END

  return split(ls, '\n')
endfunction

function! s:openBuffer(query) abort
  execute 'buffer' matchstr(a:query, '^[ 0-9]*')
endfunction

nnoremap <silent> <Leader>b :call fzf#run(fzf#wrap({
  \'source': reverse(<SID>listBuffers()),
  \'sink': function('<SID>openBuffer')
\}))<CR>
nnoremap <BS> <C-^>
nnoremap <Tab> :bnext<CR>| nnoremap <S-Tab> :bprevious<CR>
nnoremap <Leader>o :%bdelete\|edit#\|bdelete#<CR>

" Tab navigation
nnoremap g<Tab> :$tab split<CR>
nnoremap <Leader><Tab> :$tabnew<CR>

" Split window navigation
augroup AutoWindowResize
  autocmd!
  autocmd VimResized * wincmd =
augroup END
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Insert mode navigation
inoremap <C-a> <C-o>I
inoremap <expr> <C-e> pumvisible() ? '<C-e>' : '<C-o>A'
inoremap <expr> <CR> pumvisible() ? '<C-y>' : '<CR>'

" Highlighting
if has('nvim')
  vnoremap <Leader>h :call nvim_buf_add_highlight(0, nvim_create_namespace('highlight'), 'DiffChange', line("'<") - 1, col("'<") - 1, col("'>"))<CR>
  nnoremap <Leader>H :call nvim_buf_clear_namespace(0, nvim_create_namespace('highlight'), 0, line('$'))<CR>
else
  call prop_type_add('highlight', { 'highlight': 'DiffChange' })
  vnoremap <Leader>h :call prop_add(line("'<"), col("'<"), { 'end_lnum': line("'>"), 'end_col': col("'>") + 1, 'type': 'highlight' })<CR>
  nnoremap <Leader>H :call prop_clear(1, line('$'))<CR>
endif

" Quickfix/Location lists
augroup AutoOpenLists
  autocmd!
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost l* lwindow
augroup END

augroup QuickFixLastWindow
  autocmd!
  autocmd FileType qf nnoremap <CR> :execute 'wincmd p \| cc '.line('.')<CR>
augroup END

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

" FZF Fuzzy Finder
nnoremap <Leader>f :FZF --multi<CR>

" Dirvish
let g:loaded_netrw=1
let g:loaded_netrwPlugin=1
let g:dirvish_mode=':sort ,^.*[\/],'
nmap - <Plug>(dirvish_up)

" Abolish
vmap <Leader>cr <Plug>(abolish-coerce)

" Sneak
let g:sneak#label=1
let g:sneak#s_next=1
map s <Plug>Sneak_s| map S <Plug>Sneak_S| sunmap s| sunmap S
map f <Plug>Sneak_f| map F <Plug>Sneak_F| sunmap f| sunmap F
map t <Plug>Sneak_t| map T <Plug>Sneak_T| sunmap t| sunmap T

" EasyAlign
nmap ga <Plug>(EasyAlign)| xmap ga <Plug>(EasyAlign)

" Conquer of Completion
highlight! link CocCodeLens Comment
let g:coc_global_extensions=['coc-eslint', 'coc-json', 'coc-prettier', 'coc-tsserver']
nmap <F2> <Plug>(coc-rename)
nmap <Leader>gq <Plug>(coc-format)| xmap <Leader>gq <Plug>(coc-format-selected)
nmap <Leader><CR> <Plug>(coc-codeaction-cursor)
nnoremap <Leader>i :call CocAction('runCommand', 'editor.action.organizeImport')<CR>
nnoremap [e :call CocActionAsync('diagnosticPrevious', 'error')<CR>zz| nnoremap ]e :call CocActionAsync('diagnosticNext', 'error')<CR>zz
nnoremap [g :call CocActionAsync('diagnosticPrevious')<CR>zz| nnoremap ]g :call CocActionAsync('diagnosticNext')<CR>zz
nnoremap gd :call CocActionAsync('jumpDefinition')<CR>zz| nmap gD <Plug>(coc-references)
nnoremap <Leader>gd :call CocActionAsync('jumpDefinition', 'vsplit')<CR>zz
nnoremap K :call CocActionAsync('doHover')<CR>
if exists('&tagfunc')
  set tagfunc=CocTagFunc
  nnoremap gd <C-]>zz
  nnoremap <Leader>gd <C-w>v<C-]>zz
endif

" Auto Pairs
let g:AutoPairsMultilineClose=0

" Sandwich
runtime macros/sandwich/keymap/surround.vim

" Close Tags
let g:closetag_filetypes='html,javascriptreact,typescriptreact'

" Dadbod
augroup Dadbod
  autocmd!
  autocmd FileType sql nnoremap <buffer> <CR> :%DB<CR>
  autocmd FileType sql vnoremap <buffer> <CR> :DB<CR>
augroup END

" REST Console
let g:vrc_curl_opts={
  \'--include': '',
  \'--location': '',
  \'--show-error': '',
  \'--silent': ''
\}

" VimWiki
nmap <Leader>ww <Plug>VimwikiIndex
nmap <Leader>wt <Plug>VimwikiTabIndex
