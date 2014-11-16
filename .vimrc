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
autocmd FileType yaml set tabstop=2|set softtabstop=2|set shiftwidth=2|set expandtab|set autoindent
autocmd FileType haml set tabstop=2|set softtabstop=2|set shiftwidth=2|set expandtab|set autoindent
autocmd FileType scss set tabstop=2|set softtabstop=2|set shiftwidth=2|set expandtab|set autoindent

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

set wildignore+=.hg,.git,.svn " Version Controls"
set wildignore+=*.sw? "Vim swap files"
set wildignore+=*.DS_Store "OSX specific"
set wildignore+=*.class "java/scala class files"
set wildignore+=*/target/* "java/scala target directory"
set wildignore+=*/.idea,*.iml "intellij droppings"

" http://robots.thoughtbot.com/faster-grepping-in-vim/
" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" bind K to grep word under cursor
:nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" bind \ (backward slash) to grep shortcut
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

:nnoremap \ :Ag<SPACE>

"""""" PLUGING SETTINGS
:nnoremap \e :NERDTreeToggle<CR>

:nnoremap ; :CtrlPBuffer<CR>
