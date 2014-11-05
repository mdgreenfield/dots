call pathogen#infect()
call pathogen#helptags()
syntax on
filetype plugin indent on

" Remove all trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" Set line numbers
set number

set title
set ruler
set ls=2

set showtabline=2

set timeoutlen=500

" Show the first match for the pattern while typing
set incsearch
set ignorecase
set smartcase
" Highlight all matches for a pattern
set hlsearch
:nnoremap \q :nohlsearch<CR>

autocmd FileType * set tabstop=4|set softtabstop=4|set shiftwidth=4|set expandtab|set autoindent
autocmd FileType ruby set tabstop=2|set softtabstop=2|set shiftwidth=2|set expandtab|set autoindent

set backspace=indent,eol,start

"Informative status line if for some reason https://github.com/bling/vim-airline is not installed
"set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}]\ [%l/%L\ (%p%%)]

"Set color scheme
colorscheme desert256v2

"Some shortcuts for find-replace
:nnoremap ;; :%s:::g<Left><Left><Left>
:nnoremap ;' :%s:::cg<Left><Left><Left><Left>

"Fix the way 'j' and 'k' move around wrapped lines.
:nnoremap j gj
:nnoremap k gk

"Set ctrl-e to jump between buffers
:nnoremap <C-e> :e#<CR>

"Cycle between buffers
:nnoremap <C-n> :bnext<CR>
:nnoremap <C-p> :bprev<CR>

:nnoremap \t :set expandtab tabstop=4 shiftwidth=4 softtabstop=4<CR>
:nnoremap \T :set expandtab tabstop=8 shiftwidth=8 softtabstop=4<CR>
:nnoremap \M :set noexpandtab tabstop=8 softtabstop=4 shiftwidth=4<CR>
:nnoremap \m :set expandtab tabstop=2 shiftwidth=2 softtabstop=2<CR>

"""""" PLUGING SETTINGS
:nnoremap \e :NERDTreeToggle<CR>

:nnoremap ; :CtrlPBuffer<CR>

