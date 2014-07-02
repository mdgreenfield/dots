call pathogen#infect()
call pathogen#helptags()

syntax on

" Remove all trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" Set line numbers
set number

set title
set ruler
set ls=2

set showtabline=2

" Show the first match for the pattern while typing
set incsearch
" Highlight all matches for a pattern
set hlsearch

filetype plugin indent on

autocmd FileType * set tabstop=4|set softtabstop=4|set shiftwidth=4|set expandtab|set autoindent
autocmd FileType ruby set tabstop=2|set softtabstop=2|set shiftwidth=2|set expandtab|set autoindent

set backspace=indent,eol,start

"Informative status line
set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}]\ [%l/%L\ (%p%%)]

"Set color scheme
colorscheme desert256

"Some shortcuts for find-replace
noremap ;; :%s:::g<Left><Left><Left>
noremap ;' :%s:::cg<Left><Left><Left><Left>
