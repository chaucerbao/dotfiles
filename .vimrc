" General settings
set confirm hidden spell nojoinspaces noswapfile nowritebackup mouse=a updatetime=300
if has('nvim') | set guicursor= | endif
if has('mouse') && !has('nvim') | set ttymouse=xterm2 | endif
if executable('rg') | let &grepprg='rg --vimgrep' | set grepformat=%f:%l:%c:%m | endif

" Interface
set number breakindent linebreak nowrap splitbelow splitright fillchars=vert:│ list listchars=tab:»·,trail:·,nbsp:◡ signcolumn=number scrolloff=1 laststatus=2

" Indentation
set smarttab shiftround expandtab tabstop=2 shiftwidth=0

" Folding
set nofoldenable foldmethod=indent

" Autocompletion
set complete-=t,i
set completeopt=longest,menuone
set wildmenu wildmode=longest:full,full
set path=.,,**

" Search and replace
set ignorecase smartcase incsearch hlsearch
if has('nvim') | set inccommand=nosplit | endif

" Diff
set diffopt+=hiddenoff,vertical

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
  if exists('g:loaded_fugitive')
    let l:statusline.='%( 〉%{FugitiveHead()}%)'
  endif
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

augroup StlColors
  autocmd!
  autocmd SourcePost * highlight StlModeWhite ctermfg=15 ctermbg=8
    \ | highlight StlModeYellow ctermfg=3 ctermbg=8
    \ | highlight StlModeMagenta ctermfg=5 ctermbg=8
    \ | highlight StlModeRed ctermfg=1 ctermbg=8
    \ | highlight StatusLine cterm=none ctermfg=6 ctermbg=8
    \ | highlight StatusLineNC cterm=none ctermbg=0
augroup END

set statusline=%!StatusLine()

" CursorLine
augroup CursorLine
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END

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
  function! AddHighlight() abort
    let l:line_start=line("'<")
    let l:line_end=line("'>")

    for line_number in range(l:line_start, l:line_end)
      call nvim_buf_add_highlight(0, nvim_create_namespace('highlight'), 'DiffChange', line_number - 1, line_number == l:line_start ? col("'<") - 1 : 0, line_number == l:line_end ? col("'>") : col('$'))
    endfor
  endfunction

  vnoremap <Leader>h :call AddHighlight()<CR>
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

function! AutoClosePairs(open, close = '') abort
  let l:open = escape(a:open, '"')
  let l:close = escape(a:close, '"')

  if empty(a:close)
    execute 'inoremap <expr> ' . a:open . ' strpart(getline("."), col(".") - 1, 1) == "' . l:open . '" ? "<Right>" : "' . l:open . l:open . '<Left>"'
  else
    execute 'inoremap ' . a:open . ' ' . a:open . a:close . '<Left>'
    execute 'inoremap <expr> ' . a:close . ' strpart(getline("."), col(".") - 1, 1) == "' . l:close . '" ? "<Right>" : "' . l:close . '"'
  endif
endfunction

function! FallbackMappings() abort
  if empty(mapcheck('-', 'n'))
    let g:netrw_banner=0
    nnoremap - :Explore<CR>
  endif

  if empty(mapcheck('<Leader>f', 'n'))
    nnoremap <Leader>f :find<Space>
  endif

  if empty(mapcheck('<Leader>b', 'n'))
    nnoremap <Leader>b :buffers<CR>:buffer<Space>
  endif

  if empty(mapcheck('[', 'i')) | call AutoClosePairs('[', ']') | endif
  if empty(mapcheck('(', 'i')) | call AutoClosePairs('(', ')') | endif
  if empty(mapcheck('{', 'i')) | call AutoClosePairs('{', '}') | endif
  if empty(mapcheck("'", 'i')) | call AutoClosePairs("'") | endif
  if empty(mapcheck('"', 'i')) | call AutoClosePairs('"') | endif
  if empty(mapcheck('`', 'i')) | call AutoClosePairs('`') | endif
endfunction

augroup FallbackMappings
  autocmd!
  autocmd SourcePost * call FallbackMappings()
augroup END

" MatchIt plug-in
if !has('nvim') | packadd! matchit | endif

" Quickfix/Location list filtering
packadd! cfilter
