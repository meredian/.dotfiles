"" locale
set enc=utf-8
set fencs=utf-8,koi8-r

"" global
" drop all autocmd. Just is case
autocmd!
" enable mouse. Also enables scroll for certain terminals lime iTerm. Works
" like magic!
if has("mouse")
	set mouse=a
endif
" enable highlighting
set hlsearch
" show matching brackets
set showmatch
" set matching highlight color
highlight MatchParen ctermbg=blue guibg=lightblue
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
" highlight current line
set cursorline

" :set t_Co=256 " 256 colors
" :set background=dark

"" pathogen
execute pathogen#infect()
syntax on
filetype plugin indent on

"" CtrlP
let g:ctrlp_map='<c-p>'
let g:ctrlp_cmd='CtrlP :pwd'

"" netrw
" disable top netrw banner
let g:netrw_banner=0
" use tree listing by default
let g:netrw_liststyle=3
" ignore swp files in explorer
let g:netrw_list_hide='.*\.swp$'
" open files in windows number # if exists
let g:netrw_chgwin=2
" remap ctrl-w e to fire up the sidebar
nnoremap <C-w>e :leftabove 30vs<CR>:e %:h<CR>

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

"" Custom mappings
" run current script in shell
nnoremap ,r :<C-u>!%:p<CR>
" Ctrl-C to exit insert mode
inoremap <c-c> <esc>
" Expand %% to current file path in command mode
cnoremap <expr> %% expand('%:h').'/'

"" AutoCmd
augroup vimrcEx
  " clean autogroup
  autocmd!
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END

"" Multipurpose tab key
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

