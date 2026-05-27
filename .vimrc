set nocompatible
filetype off

" Auto-install vim-plug if missing
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'bling/vim-airline'
Plug 'mkitt/tabline.vim'
Plug 'lifepillar/vim-mucomplete'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vividchalk'
Plug 'majutsushi/tagbar'
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'vim-ruby/vim-ruby'
Plug 'depuracao/vim-rdoc'
Plug 'vim-scripts/Gist.vim'
Plug 'airblade/vim-gitgutter'
Plug 'flazz/vim-colorschemes'
Plug 'bkad/CamelCaseMotion'
Plug 'vim-scripts/argtextobj.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'dense-analysis/ale'
Plug 'vim-scripts/IndexedSearch'

call plug#end()

" Brief help
" :PlugInstall      - install plugins
" :PlugUpdate       - update plugins
" :PlugClean        - remove unused plugins
" :PlugStatus       - status of plugins
" see :h plug for details

syntax on

" Remove trailing whitespace without disturbing cursor or jumplist
function! s:StripTrailingWhitespace()
  let l:view = winsaveview()
  silent! keeppatterns %s/\s\+$//e
  call winrestview(l:view)
endfunction
autocmd BufWritePre * call s:StripTrailingWhitespace()

" Persistent undo across sessions
if has('persistent_undo')
  if !isdirectory(expand('~/.vim/undo'))
    call mkdir(expand('~/.vim/undo'), 'p', 0700)
  endif
  set undodir=~/.vim/undo
  set undofile
endif

" Restore cursor position when reopening a file
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

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
if has('termguicolors')
  set termguicolors
endif

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

" Prefer ripgrep, fall back to ag
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
  set grepformat=%f:%l:%c:%m
elseif executable('ag')
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
