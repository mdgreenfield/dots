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

filetype plugin indent on

"Informative status line
set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}]\ [%l/%L\ (%p%%)]

"Set color scheme
colorscheme desert256

"Some shortcuts for find-replace
noremap ;; :%s:::g<Left><Left><Left>
noremap ;' :%s:::cg<Left><Left><Left><Left>
