" set the runtime path to include Vundle and initialize
set rtp+=$HOME/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'commentary.vim'
Plugin 'tpope/vim-surround'
Plugin 'easymotion/vim-easymotion'
Plugin 'terryma/vim-expand-region'
Plugin 'tomasiser/vim-code-dark'
Plugin 'francoiscabrol/ranger.vim'
Plugin 'fatih/vim-go'
call vundle#end()
filetype plugin indent on    " required

"" default setting
syntax on
set ai
set ci
set si
set relativenumber
set nu
set imi=1
set hidden
let mapleader=","

"" tab settings
set ts=2
set sw=2
set sts=2
set expandtab

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

"" Trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
map <leader>dw :%s/\s\+$//<cr>

"" set function keys
set nopaste
set pastetoggle=<F4>
map <F11> @q
map <F8> <esc><<esc><esc><esc>:w<cr>:make<cr><cr><cr><cr>
map ,bu <esc><esc>:w<cr>:make<cr><cr><cr><cr>
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

"" buffer setting
map <C-L> :bnext<cr>
map <C-h> :bNext<cr>
map <leader>q :bp <BAR> bd #<CR>

"" config
map <leader>cv :e ~/.vimrc<cr>
map <leader>cs :e ~/.screenrc<cr>
map <leader>cb :e ~/.bashrc<cr>
map <leader>cz :e ~/.zpreztorc<cr>
map <leader>cr :source ~/.vimrc<cr>

"" NerdTree setup
map <leader>ef :NERDTreeToggle<CR>

"" Ranger setup
map <leader>er :Ranger<CR>
let g:ranger_command_override = 'ranger --cmd "set show_hidden=true"'

"" Airline setup
" set laststatus=2
" set term=xterm-256color
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='codedark'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#fnamemod = ':t'

"" xclip
vmap <C-c> y:call system("xclip -i -selection clipboard", getreg("\""))<CR>
map <leader>ya :call system("xclip -i -selection clipboard", getreg("%"))<CR>
map <leader>yf :call system("xclip -i -selection clipboard", expand("%:t"))<CR>

"" multi-cursor
let g:multi_cursor_quit_keys='<Esc>,<C-c>'

"" Easy motion setting
map s <Nop>
nmap ss <Plug>(easymotion-overwin-f2)
map sl <Plug>(easymotion-bd-jk)
nmap sl <Plug>(easymotion-overwin-line)
let g:EasyMotion_smartcase = 0

"" Vim expand region setting
map L <Plug>(expand_region_expand)
map H <Plug>(expand_region_shrink)

"" GitGutter
set updatetime=100
autocmd BufWritePost * GitGutter

"" color scheme
" colorscheme wombat256dave
colorscheme codedark

