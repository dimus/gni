version 6.0
if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim
cmap <D-g> <D-g>
imap <D-g> <D-g>
cmap <D-f> <D-f>
imap <D-f> <D-f>
cmap <D-a> <D-a>
imap <D-a> <D-a>
cnoremap <D-v> +
cnoremap <D-c> 
cmap <D-z> <D-z>
imap <D-z> <D-z>
cmap <S-D-s> <D-s>
imap <S-D-s> <D-s>
cmap <D-s> <D-s>
imap <D-s> <D-s>
cmap <D-w> <D-w>
imap <D-w> <D-w>
cmap <D-o> <D-o>
imap <D-o> <D-o>
cmap <D-n> <D-n>
imap <D-n> <D-n>
map K :!ispell 
map L :!ispell % 
map Q gq
map R :!python % 
xmap S <Plug>VSurround
map \mbt <Plug>TMiniBufExplorer
map \mbu <Plug>UMiniBufExplorer
map \mbc <Plug>CMiniBufExplorer
map \mbe <Plug>MiniBufExplorer
nmap \so <Plug>DBOrientationToggle
nmap \sh <Plug>DBHistory
nmap \slv <Plug>DBListView
nmap \slp <Plug>DBListProcedure
nmap \slt <Plug>DBListTable
vmap <silent> \slc :exec 'DBListColumn "'.DB_getVisualBlock().'"'
nmap \slc <Plug>DBListColumn
nmap \sbp <Plug>DBPromptForBufferParameters
nmap \sdpa <Plug>DBDescribeProcedureAskName
vmap <silent> \sdp :exec 'DBDescribeProcedure "'.DB_getVisualBlock().'"'
nmap \sdp <Plug>DBDescribeProcedure
nmap \sdta <Plug>DBDescribeTableAskName
vmap <silent> \sdt :exec 'DBDescribeTable "'.DB_getVisualBlock().'"'
nmap \sdt <Plug>DBDescribeTable
vmap <silent> \sT :exec 'DBSelectFromTableTopX "'.DB_getVisualBlock().'"'
nmap \sT <Plug>DBSelectFromTableTopX
nmap \sta <Plug>DBSelectFromTableAskName
nmap \stw <Plug>DBSelectFromTableWithWhere
vmap <silent> \st :exec 'DBSelectFromTable "'.DB_getVisualBlock().'"'
nmap \st <Plug>DBSelectFromTable
nmap <silent> \sel :.,.DBExecRangeSQL
nmap <silent> \sea :1,$DBExecRangeSQL
nmap \sE <Plug>DBExecSQLUnderCursorTopX
nmap \se <Plug>DBExecSQLUnderCursor
vmap \sE <Plug>DBExecVisualSQLTopX
vmap \se <Plug>DBExecVisualSQL
nmap cs <Plug>Csurround
nmap ds <Plug>Dsurround
nmap gx <Plug>NetrwBrowseX
vnoremap p :let current_reg = @"gvdi=current_reg
xmap s <Plug>Vsurround
nmap ySS <Plug>YSsurround
nmap ySs <Plug>YSsurround
nmap yss <Plug>Yssurround
nmap yS <Plug>YSurround
nmap ys <Plug>Ysurround
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#NetBrowseX(expand("<cWORD>"),0)
map <F6> :%s/Ò/"/ge:%s/Ó/"/ge :%s/Õ/'/ge
map <F7> :let &fileencoding=&encoding
map <F8> :execute RotateEnc()
omap <D-g> <D-g>
vmap <D-g> <D-g>
nnoremap <D-g> n
omap <D-f> <D-f>
vmap <D-f> <D-f>
nnoremap <D-f> /
omap <D-a> <D-a>
vmap <D-a> <D-a>
nnoremap <silent> <D-a> :if &slm != ""|exe ":norm gggHG"| else|exe ":norm ggVG"|endif
omap <D-z> <D-z>
vmap <D-z> <D-z>gv
nnoremap <D-z> u
omap <S-D-s> <D-s>
vmap <S-D-s> <D-s>gv
nnoremap <S-D-s> :browse confirm saveas
omap <D-s> <D-s>
vmap <D-s> <D-s>gv
nnoremap <silent> <D-s> :if expand("%") == ""|browse confirm w| else|confirm w|endif
omap <D-w> <D-w>
vmap <D-w> <D-w>gv
nnoremap <silent> <D-w> :if winheight(2) < 0 | confirm enew | else | confirm close | endif
omap <D-o> <D-o>
vmap <D-o> <D-o>gv
nnoremap <D-o> :browse confirm e
omap <D-n> <D-n>
vmap <D-n> <D-n>gv
nnoremap <D-n> :confirm enew
vmap <BS> "-d
vnoremap <D-x> "+x
vnoremap <D-c> "+y
nnoremap <D-v> "+gP
imap S <Plug>ISurround
imap s <Plug>Isurround
imap  <Plug>Isurround
let &cpo=s:cpo_save
unlet s:cpo_save
set autoindent
set backspace=2
set encoding=koi8-r
set expandtab
set fileencodings=ucs-bom,utf-8,default,latin1
set guifont=Monaco:h18
set helplang=en
set history=50
set hlsearch
set ignorecase
set laststatus=2
set mouse=a
set ruler
set shiftwidth=4
set smartcase
set smartindent
set smarttab
set statusline=%<%f%h%m%r%=%b\ %{&encoding}\ 0x%B\ \ %l,%c%V\ %P
set tabstop=4
set termencoding=koi8-r
set viminfo='20,\"50
set visualbell
set window=51
" vim: set ft=vim :
