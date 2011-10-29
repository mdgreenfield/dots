syntax on
autocmd BufWritePre * :%s/\s\+$//e
set number
set title
set ruler
set ls=2

set showtabline=2

map ,t <Esc>:tabnew<CR>
