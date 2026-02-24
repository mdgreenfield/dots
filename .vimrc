set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'bling/vim-airline'
Plugin 'mkitt/tabline.vim'
Plugin 'lifepillar/vim-mucomplete'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-vividchalk'
Plugin 'majutsushi/tagbar'
Plugin 'fatih/vim-go' " need to run :GoInstallBinaries
Plugin 'vim-ruby/vim-ruby'
Plugin 'depuracao/vim-rdoc'
Plugin 'vim-scripts/Gist.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'flazz/vim-colorschemes'
Plugin 'bkad/CamelCaseMotion'
Plugin 'vim-scripts/argtextobj.vim'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'dense-analysis/ale'
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

set nowrap

" Set line numbers
set number
"set relativenumber

set ttymouse=xterm2
set mouse=a


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

autocmd FileType * set tabstop=4 softtabstop=4 shiftwidth=4 expandtab autoindent
autocmd FileType ruby setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab autoindent
autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab autoindent
autocmd FileType haml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab autoindent
autocmd FileType scss setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab autoindent
autocmd Filetype go setlocal tabstop=4 softtabstop=0 noexpandtab

autocmd Filetype gitcommit setlocal spell
autocmd Filetype markdown setlocal spell
autocmd Filetype txt setlocal spell

set backspace=indent,eol,start

set splitbelow
set splitright

"Informative status line if for some reason https://github.com/bling/vim-airline is not installed
"set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}]\ [%l/%L\ (%p%%)]

set t_Co=256

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

set wildignore+=.hg,.git,.svn "Version Control files"
set wildignore+=*.sw? "Vim swap files"
set wildignore+=*.DS_Store "OSX specific"
set wildignore+=*.class "java/scala class files"
set wildignore+=*/target/* "java/scala target directory"
set wildignore+=*/.idea,*.iml "intellij droppings"

" The Silver Searcher
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
endif

" bind K to grep word under cursor
:nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" bind \ (backward slash) to grep shortcut
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

:nnoremap \ :Ag<SPACE>

"""""" PLUGING SETTINGS
:nnoremap \e :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" yank to clipboard
if has("clipboard")
  set clipboard=unnamed " copy to the system clipboard

  if has("unnamedplus") " X11 support
    set clipboard+=unnamedplus
  endif
endif

" Load fzf (installed using Homebrew)
execute 'set rtp+=' . trim(system('brew --prefix')) . '/opt/fzf'

" Unset paste on InsertLeave
augroup unset_paste
  autocmd!
  autocmd InsertLeave * silent! set nopaste
augroup END

" Plugin vim-mucomplete
set completeopt+=menuone
set completeopt+=noselect
set shortmess+=c
set belloff+=ctrlg
let g:mucomplete#enable_auto_at_startup = 1

" Go syntax highlighting
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1

" Auto formatting and importing
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"

" Status line types/signatures
let g:go_auto_type_info = 1
