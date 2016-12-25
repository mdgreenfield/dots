set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'git://github.com/bling/vim-airline'
Plugin 'git://github.com/mkitt/tabline.vim'
Plugin 'git://github.com/ervandew/supertab.git'
"  "git://github.com/godlygeek/tabular.git'
Plugin 'git://github.com/depuracao/vim-rdoc.git'
Plugin 'git://github.com/scrooloose/nerdtree.git'
"  "git://github.com/timcharper/textile.vim.git'
Plugin 'git://github.com/tpope/vim-fugitive.git'
Plugin 'git://github.com/tpope/vim-git.git'
Plugin 'git://github.com/tpope/vim-haml.git'
Plugin 'git://github.com/tpope/vim-markdown.git'
Plugin 'git://github.com/tpope/vim-rails.git'
Plugin 'git://github.com/tpope/vim-repeat.git'
Plugin 'git://github.com/tpope/vim-surround.git'
Plugin 'git://github.com/tpope/vim-vividchalk.git'
Plugin 'git://github.com/majutsushi/tagbar'
"  "git://github.com/tsaleh/taskpaper.vim.git'
"  "git://github.com/tsaleh/vim-matchit.git'
"  "git://github.com/tsaleh/vim-shoulda.git'
"  "git://github.com/tsaleh/vim-tcomment.git'
Plugin 'git://github.com/vim-ruby/vim-ruby.git'
Plugin 'git://github.com/vim-scripts/Gist.vim.git'
Plugin 'git://github.com/kien/ctrlp.vim.git'
Plugin 'git://github.com/airblade/vim-gitgutter'
Plugin 'git://github.com/flazz/vim-colorschemes.git'
Plugin 'https://github.com/vim-syntastic/syntastic.git'
Plugin 'https://github.com/bkad/CamelCaseMotion.git'
Plugin 'https://github.com/vim-scripts/argtextobj.vim'

" plugins from http://vim-scripts.org/vim/scripts.html
Plugin 'IndexedSearch'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

syntax on

" Remove all trailing whitespace
autocmd BufWritePre * :%s/\s\+$//e

" Set line numbers
set number
set relativenumber

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
autocmd FileType ruby setlocal tabstop=2|set softtabstop=2|set shiftwidth=2|set expandtab|set autoindent
autocmd FileType yaml setlocal tabstop=2|set softtabstop=2|set shiftwidth=2|set expandtab|set autoindent
autocmd FileType haml setlocal tabstop=2|set softtabstop=2|set shiftwidth=2|set expandtab|set autoindent
autocmd FileType scss setlocal tabstop=2|set softtabstop=2|set shiftwidth=2|set expandtab|set autoindent

autocmd Filetype gitcommit setlocal spell
autocmd Filetype md setlocal spell

set backspace=indent,eol,start

"Informative status line if for some reason https://github.com/bling/vim-airline is not installed
"set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}]\ [%l/%L\ (%p%%)]

" Syntastic settings
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"Set color scheme
silent! colorscheme desert256v2

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
let NERDTreeShowHidden=1

:nnoremap ; :CtrlPBuffer<CR>
