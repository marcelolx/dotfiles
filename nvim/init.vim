call plug#begin('~/AppData/Local/nvim/plugged')
Plug 'joshdick/onedark.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'sheerun/vim-polyglot'
Plug 'scrooloose/nerdTree'
Plug 'vim-ruby/vim-ruby'
Plug 'tpope/vim-rails'
Plug 'ctrlpvim/ctrlp.vim'
call plug#end()

let g:python3_host_prog = 'C:\Users\marce\AppData\Local\Programs\Python\Python37-32\python.exe'
let g:airline_theme='onedark'
set tabstop=2
set shiftwidth=2
set backspace=2
set number
set relativenumber
set incsearch
set hlsearch

set nocompatible
filetype plugin indent on
syntax on
colorscheme onedark

autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2
autocmd FileType eruby setlocal expandtab shiftwidth=2 tabstop=2

"Tell to vim where is ctags file
set tags=./tags;

" Abre o NERDTree sempre à esquerda
let g:NERDTreeWinPos = "left"
" Deletes buffer of the file when file deleted with nerdtree
let NERDTreeAutoDeleteBuffer = 1
" Close nerdtree after open file
" let NERDTreeQuitOnOpen = 1

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" Abre o NERDTree ao abrir o VIM
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Close vim if nerdtree is only tab open
" autocmd bufenter * if (winnr(“$”) == 1 && exists(“b:NERDTreeType”) && b:NERDTreeType == “primary”) | q | endif

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" Mapeamentos
" CTRL + J
inoremap <silent><expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
" CTRL + K
inoremap <silent><expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"
" Abre o NerdTree direto no arquivo
inoremap <silent> <Leader>v :NERDTreeFind<CR>

