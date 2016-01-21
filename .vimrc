"" locale
set enc=utf-8
set fencs=utf-8,koi8-r

"" global
" enable mouse. Also enables scroll for certain terminals lime iTerm. Works
" like magic!
if has("mouse")
	set mouse=a
endif
" enable highlighting
set hlsearch
" chdir for switching buffer
autocmd BufEnter * silent! lcd %:p:h
" show matching brackets
set showmatch
" set matching highlight color
highlight MatchParen ctermbg=blue guibg=lightblue

"" pathogen
execute pathogen#infect()
syntax on
filetype plugin indent on

"" NERD_tree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"" CtrlP
let g:ctrlp_map='<c-p>'
let g:ctrlp_cmd='CtrlP'

"" netrw
" disable top netrw banner
let g:netrw_banner=0
" use tree listing by default
let g:netrw_liststyle=3
" ignore swp files in explorer
let g:netrw_list_hide='.*\.swp$'
" open files in windows number # if exists
let g:netrw_chgwin=2
" remap shift-control to fire up the sidebar
" works like shit, todo research
nnoremap <C-w>e :leftabove 20vs<CR>:e `pwd`<CR>
" nnoremap <silent> <C-M> :leftabove 20vs<CR>:e .<CR>
" " remap control-enter to open files in new tab
" nmap <silent> <C-CR> t :rightbelow 20vs<CR>:e .<CR>:wincmd h<CR>
" nmap <silent> <NL> t :rightbelow 20vs<CR>:e .<CR>:wincmd h<CR>

"" perl utils
" Исправляет дурацкую цветовую схему "белое на желтом" в окне с ошибками
:hi Search ctermfg=0
" Check perl syntax - some magic thing
nmap @c :w<cr>:compiler perl<CR>:make<CR>:cw<CR>

function CheckSyntax()
        if &filetype != ''
                let cmd=''
                if &filetype == 'perl'
                        let cmd='perl -w -MO=Lint,no-context '
                elseif &filetype == 'c'
                        let cmd='gcc -fsyntax-only -pedantic '
                elseif &filetype == 'sh'
                        let cmd='bash -n '                        
                endif

                if cmd != ''
                        let output = system(cmd.expand('%'))
                        echo strpart(output, 0, strlen(output)-1)
                else
                        echo 'Have no idea how to check syntax for filetype '.&ft
                endif
        else
                echo 'unknown file type or filetype plugin not loaded'
        endif
endfunction

map  <silent><F9> :call CheckSyntax()<CR>
imap <silent><F9> :call CheckSyntax()<CR>
vmap <silent><F9> :call CheckSyntax()<CR>
