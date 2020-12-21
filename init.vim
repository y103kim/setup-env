" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/nvim/plugged')
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'terryma/vim-expand-region'
Plug 'tomasiser/vim-code-dark'
Plug 'fatih/vim-go'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'mg979/vim-visual-multi'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'mhinz/vim-startify'
Plug 'rhysd/git-messenger.vim'
Plug 'wellle/targets.vim'
Plug 'justinmk/vim-sneak'
Plug 'sheerun/vim-polyglot'
call plug#end()

"" SmartHome setting =============================================================================
nmap <silent><Home> :call SmartHome("n")<CR>
nmap <silent><End> :call SmartEnd("n")<CR>
imap <silent><Home> <C-r>=SmartHome("i")<CR>
imap <silent><End> <C-r>=SmartEnd("i")<CR>
vmap <silent><Home> <Esc>:call SmartHome("v")<CR>
vmap <silent><End> <Esc>:call SmartEnd("v")<CR>

function SmartHome(mode)
  let curcol = col(".")
  "gravitate towards beginning for wrapped lines
  if curcol &gt; indent(".") + 2
    call cursor(0, curcol - 1)
  endif
  if curcol == 1 || curcol &gt; indent(".") + 1
    if &wrap
      normal g^
    else
      normal ^
    endif
  else
    if &wrap
      normal g0
    else
      normal 0
    endif
  endif
  if a:mode == "v"
    normal msgv`s
  endif
  return ""
endfunction

"" default setting ===============================================================================
syntax on
set ai
set ci
set si
set relativenumber
set nu
set imi=1
set hidden
let mapleader=","
set mouse=a
set backspace=2
set updatetime=200
set colorcolumn=100
set belloff=all
set clipboard=
set tw=100
set updatetime=100

"" Indent settings ===============================================================================
set ts=2
set sw=2
set sts=2
set expandtab

" Gnu style indent settings
function! GnuIndent()
  set cinoptions=>4,n-2,{2,^-2,:2,=2,g0,h2,p5,t0,+2,(0,u0,w1,m1
  set shiftwidth=2
  set tabstop=8
endfunction

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* ET call ET()
function! ET()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
    set expandtab
  endif
  call SummarizeTabs()
endfunction

command! -nargs=* NT call NT()
function! NT()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
    set noexpandtab
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction

"" set function keys =============================================================================
set nopaste
set pastetoggle=<F4>
map <F9> @q
map <F8> <esc><<esc><esc><esc>:w<cr>:make<cr><cr><cr><cr>
map ,bu <esc><esc>:w<cr>:make<cr><cr><cr><cr>
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

"" mouse key toggle
set mouse=a
function! ShowMouseMode()
  if (&mouse == 'a')
    echo "mouse-vim"
  else
    echo "mouse-xterm"
  endif
endfunction
map <silent><F5> :let &mouse=(&mouse == "a"?"":"a")<CR>:call ShowMouseMode()<CR>
imap <silent><F5> :let &mouse=(&mouse == "a"?"":"a")<CR>:call ShowMouseMode()<CR>

"" number key toggle
let g:nu_state = 1
function! NumberToggle()
  if(g:nu_state == 0)
    set number
    set relativenumber
    let g:nu_state = 1
    execute "GitGutterEnable"
  elseif(g:nu_state == 1)
    set number
    set norelativenumber
    let g:nu_state = 2
    execute "GitGutterEnable"
  elseif(g:nu_state == 2)
    set nonu
    set norelativenumber
    let g:nu_state = 0
    execute "GitGutterDisable"
  endif
endfunc
noremap <F3> :call NumberToggle()<CR>

"" buffer setting ================================================================================
map <C-L> :bnext<cr>
map <C-h> :bNext<cr>
map <leader>q :bp <BAR> bd #<CR>

"" config (c) ====================================================================================
map <leader>cv :e ~/.config/nvim/init.vim<cr>
map <leader>cz :e ~/.zshrc<cr>
map <leader>cl :e ~/.zshrc-local<cr>
map <leader>cr :source ~/.config/nvim/init.vim<cr>

"" execution (e) =================================================================================
map <leader>ef :CocCommand explorer<CR>

"" Git (g) =======================================================================================
autocmd BufWritePost * GitGutter
nmap <Leader>gm <Plug>(git-messenger)

" Fzf ============================================================================================
map <leader>fr :Rg <C-R>=expand("<cword>")<CR><CR>
silent! !git rev-parse --is-inside-work-tree 1>/dev/null 2>&1
if v:shell_error == 0
  map <leader>ff :GFiles <CR>
  map <leader>fs :GFiles! <CR>
else
  map <leader>ff :Files <CR>
  map <leader>fs :Files <CR>
endif
map <leader>fb :Buffers <CR>
map <leader>fb :Buffers <CR>
map <leader>ft :Tags <C-R>=expand("<cword>")<CR><CR>
cnoreabbrev rg Rg

nmap <leader>fo call CocAction("format")<CR>

"" Slect, Motion, Copy ===========================================================================
" Xclip copy
vmap <C-c> y:call system("xclip -i -selection clipboard", getreg("\""))<CR>
map <leader>ya :call system("xclip -i -selection clipboard", getreg("%"))<CR>
map <leader>yf :call system("xclip -i -selection clipboard", expand("%:t"))<CR>

" Vim expand region setting
map L <Plug>(expand_region_expand)
map H <Plug>(expand_region_shrink)

"" Easy motion setting
map f <Nop>
map s <Nop>
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map s <Plug>Sneak_s
map S <Plug>Sneak_S
map ; <Plug>Sneak_;

"" color scheme, indent theme ===================================================================
colorscheme codedark
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  ctermbg=235
hi IndentGuidesEven ctermbg=236

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='codedark'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#fnamemod = ':t'

"" hls color
set hls
hi Search cterm=NONE ctermfg=black ctermbg=yellow
map <leader>/ :let @/ = ""<cr>

"" trailing white space
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
map <leader>dw :%s/\s\+$//<cr>

"" COC setup ====================================================================================
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
au BufWritePost *.py call CocAction("format")

"" Cscope setup ==================================================================================
if has("cscope")

  set cscopetag
  set csto=0

  if filereadable("cscope.out")
    cs add cscope.out
  elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
  endif

  set cscopeverbose

  nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
  nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
  nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
endif
