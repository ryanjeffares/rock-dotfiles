syntax on

set number
set relativenumber
set expandtab
set autoindent
set shiftwidth=4
set smartindent
set nocompatible
set completeopt=menu,menuone,noselect
set nobackup
set nowritebackup
set updatetime=300
set signcolumn=yes

filetype plugin indent on

call plug#begin()

function! UpdateRemotePlugins(...)
    let &rtp = &rtp
    UpdateRemotePlugins
endfunction

" Themes
Plug 'joshdick/onedark.vim'

" QOL
Plug 'terryma/vim-multiple-cursors'
Plug 'vim-scripts/delimitMate.vim'
Plug 'preservim/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'

" Syntax highlighting
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

" Intellisense
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

call plug#end()

colorscheme onedark
 
let delimitMate_expand_cr=1
 
nmap <S-t> :NERDTreeFocus<CR>

call wilder#setup({ 'modes': [':', '/', '?'] })
call wilder#set_option('rendered', wilder#popupmenu_renderer({
    \   'highlighter': wilder#basic_highlighter(),
    \   'left': [' ', wilder#popupmenu_devicons()],
    \   'right': [' ', wilder#popupmenu_scrollbar()],
    \ }))
  
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_int') | execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

nnoremap :n<CR> :nohl<CR>

" Navigation shortcuts
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gn <Plug>(coc-rename)

" Use return to accept code completion
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" Use tab/shift tab to cycle through completion options
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#next(1) : CheckBackspace() ? "\<Tab>" : coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
" Control + space to retrigger completion 
inoremap <silent><expr> <C-space> coc#refresh()
" K to show documentation for a symbol in floating window
nnoremap <silent> K :call ShowDocumentation()

function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1] =~# '\s'
endfunction

function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
    else
        call feedkeys('K', 'in')
    endif
endfunction

" Highlight all occurances of the same symbol under the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

lua <<EOF

require'nvim-treesitter.configs'.setup({
    ensure_initialised = "maintained",
    sync_install = false,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    }
})

EOF
