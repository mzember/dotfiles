" First step:  Remove ALL auto-commands.  This avoids having the
" " autocommands twice when the vimrc file is sourced again.
"
autocmd!


"" 8 colors
" if has("terminfo")
" set t_Co=8
" set t_Sf=[3%p1%dm
" set t_Sb=[4%p1%dm
" else
" set t_Co=8
" set t_Sf=[3%dm
" set t_Sb=[4%dm
" endif
" 


" 256 colors
"set t_AB=[48;5;%dm
"set t_AF=[38;5;%dm
      

" last-position-jump after opening
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif



" Macros

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" Comment /* */ for C, C++, CSS
function Comment()
    if getline(line(".")) =~ '\/\*.*\*\/'
        "     backup the search register
        " let @T = getreg("/")
        "
        "     doesn't work, don't know why (example from help):
        " let backup_reg = getreg("/")
        " let backup_reg_mode = getregtype("/")
        " setreg( '/', backup_reg, backup_reg_mode)
        "
        "     also doesn't work:
        " return "\<esc>:let @T = @/\<cr>:s:/\\*:: || s:\*/::\<cr>:let @/ = @T\<cr>"
        " return "\<esc>:let backup_reg = getreg("/")\<cr>:let backup_reg_mode = getregtype("/")\<cr>:s:/\\*:: || s:\*/::\<cr>:call setreg( '/', backup_reg, backup_reg_mode)\<cr>"
        return "\<esc>:s:/\\* \\?:: || s: \\?\\*/::\<cr>"
    else
        return "\<esc>I/* \<esc>A */\<esc>"
    endif
endfunction
noremap <f3> :let backup_reg = @/<cr>i<c-r>=Comment()<cr>:let @/ = backup_reg<cr>

" mapping , as <Leader>
let mapleader = ","
" but ',' alone serves for searching again after f, t, ...
" thus we map it as <leader><leader>
noremap <Leader><Leader> ,<Esc>


" ----------------------------------------------------
" erase trailing blanks
nmap <Leader>$ g_lD

" ----------------------------------------------------
" root.cz:
"map <C-Tab> :bn<CR>
"map <S-C-Tab> :bp<CR>
"imap <C-Tab> <Esc>:bn<CR>
"imap <S-C-Tab> <Esc>:bp<CR>
nmap ,b :bn<CR>
nmap ,m :bp<CR>


" ----------------------------------------------------
" set spellcheck on, language cs
nmap <Leader>s :setlocal spell spelllang=cs
" set spellcheck off
nmap <Leader>S :setlocal nospell<CR>

" ----------------------------------------------------
" todo file macros - mark as done, move to DONE section
vmap <Leader>d :<CR>:let backup_reg = @/<cr>:'<,'>m /HOTOVO/<CR>:let @/ = backup_reg<cr>
nmap <Leader>d :let backup_reg = @/<cr>:m /HOTOVO/<CR>:let @/ = backup_reg<cr>
nmap <Leader>D :let backup_reg = @/<cr>:m /NIE/<CR>:let @/ = backup_reg<cr>
nmap <a-r> :r!date<CR>
nmap <f4> :r!date<CR>
imap <f4> <Esc>:r!date<CR>o


" ----------------------------------------------------
" vimspell is gone
" vimspell was possible to turn on by <Leader>sA

" uplne vypnut:
"let loaded_vimspell = 1
" on-the-fly vypnut:
"let spell_auto_type = ""
" so that there is a menu:
set mousemodel=popup
"set mousemodel=popup_setpos

set runtimepath+=~/.vim/spell

" ----------------------------------------------------
" TeX
" /usr/share/vim/addons/plugin/imaps.vim will look and not map <c-j>
imap <C-b> <Plug>IMAP_JumpForward
nmap <C-b> <Plug>IMAP_JumpForward
" let g:Tex_CompileRule_dvi='cslatex --interaction=nonstopmode $*'
let g:Tex_CompileRule_dvi='make'


" OPTIONAL: Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'
" ----------------------------------------------------
" search similar to Opera browser
set incsearch

" search for local .vimrc in directories (see help trojan-horse)
set exrc

" map save to f2
noremap <F2> :w<cr>
inoremap <F2> <Esc>:w<cr>

""noremap <f10> :w<cr>
noremap <f10> :wq
inoremap <f10> <Esc>:wq
noremap <f8> :q<cr>
noremap <f5> :q!

" We use a vim
set nocompatible

" mouse
set mouse=a

" mouse in screen
if !has('nvim')
  set ttymouse=xterm2
endif

"
" Colo(u)red or not colo(u)red
" If you want color you should set this to true
"
let color = "true"

"colorscheme elflord
"colorscheme nuvola
"colorscheme golden-greenhorn
"colorscheme candy
"colorscheme dante
colorscheme blue

" :COLORSCHEME will help u
nmap <C-c> :%s#\<<c-r>=expand("<cword>")<cr>\>#

" look for lines preceeded starting with "***" (headings)
function! FindTopicInDone()
    "let saveb =@b
    let word = input("What to search for? ")
    let tosearch = "^\\(\\*\\**\\)\\*.*" . word . ".*\\1/"
    "exec "normal ".tosearch
    return tosearch
endfunction
"noremap <leader>/ :let backup_reg = @/<cr>/^\(\**\)\*.*<c-r>=FindTopicInDone()<cr>:let @/ = backup_reg<cr>
noremap <leader>/ /<c-r>=FindTopicInDone()<cr>
"noremap <leader>/ /^\(\**\)\*.*<c-r>=FindTopicInDone()<cr>:let @/ = backup_reg<cr>


"
if has("syntax")
    if color == "true"
	" This will switch colors ON
	so ${VIMRUNTIME}/syntax/syntax.vim
    else
	" this switches colors OFF
	syntax off
	set t_Co=0
    endif
endif


" ----------------------------------------------------
map <F12> :set paste<CR>
"map <F11> :set nopaste<CR>                 
imap <F12> <C-O>:set paste<CR>
imap <F11> <nop>
set pastetoggle=<F11>

" paste from clipboard or cut buffer
map zp "*p
map zP "*P
" ----------------------------------------------------
" downloaded from Ivo Danihelka
set modelines=5
set nobackup
set bs=indent,eol,start
" lepsi podpora copy/paste v xtermu
set ttyfast

" ignorovani velikosti pri hledani, ale ponechani u i_C-N, i_C-P
" smartcase zapne casesensitive pro vyraz s velkymi pismenky
set ignorecase
set smartcase

" nastaveni gvimu (musi byt zde, aby se predeslo nacteni menu)
set guioptions=aiMr

" obarvovat nalezene
set hlsearch

" zobrazovani prikazu
set showcmd

" inteligenti odsazovani
set ai
set nocindent
"set cindent

" velikost odsazeni
set shiftwidth=4
set softtabstop=4
set tabstop=8
set expandtab

" automaticke ukladani pri opousteni buffru (napr:. pri :make)
set autowrite
set hidden

" doplnovani jako na command line
set wildmenu
" nastaveni doplnovani tabulatorem ve stylu command line
set wildmode=list:longest
set wildignore=*.o,*.class,*.dvi,*.d,*.pyc

set textwidth=0
"set encoding=iso-8859-2
set fileencodings=ucs-bom,utf-8,iso-8859-2

" cerne pozadi
set background=dark

set formatoptions=crql1

" vypnuti bell
set vb
set t_vb=""

" normal modu nepestuji cestinu
set langmap=ì2,¹3,è4,ø5,¾6,ý7,á8,í9,é0
" zobrazovat alespon kus strasne dlouheho odstavce
set display=lastline

" rekurzivni grep mimo tags, .*, *.html, sign, *.cpp.app
set grepprg=find\ .\ !\ \\(\ -name\ tags\ -o\ -path\ '*/.svn/*'\ -o\ -name\ '*.cpp.aap'\ -o\ -name\ 'sign'\ -o\ -name\ '.\\*'\ -o\ -name\ '*.html'\ \\)\ -exec\ grep\ -IHn\ $*\ {}\ \\;
" ----------------------------------------------------

" automaticke foldovani
"noremap <Leader>syn :syn region myFold start="^{" end="^}" transparent fold<cr><cr>:syn sync fromstart<cr><cr>:set foldmethod=syntax<cr><cr>


"pohyb i do wrap textu
noremap k gk
noremap j gj
noremap  <up>    g<up>
noremap  <down>  g<down>
inoremap <up>    <c-o>gk
inoremap <down>  <c-o>gj

" pohyb mezi chybami
noremap <CR>  :cc<CR>
noremap <C-p> :cp<CR>
noremap <C-n> :cn<CR>

" rychle rolovani pomoci ctrl-j, ctrl-k
noremap <C-k> 2<c-y>
noremap <C-j> 2<c-e>
inoremap <C-k> <c-x><c-y><c-y>
inoremap <C-j> <c-x><c-e><c-e>

" <Leader> mi slouzi jako uvadec do mych maker,
" kopirovani a vkladani (do registru z)
noremap <Leader>y "zy
noremap <Leader>p "zp
noremap <Leader>P "zP
" prerovnani celeho zdrojaku
noremap <Leader>= mzgg=G`z

" ctrl-f prevede slovo na upercase
inoremap <C-F> <Esc>gUiw`]a
noremap <C-F> gUiw`]

noremap gf :e <cfile><cr>

" prepinani alternativ
"noremap <f4> :A<cr>
" make na f9
noremap <S-f9> :make<cr>
inoremap <S-F9> <Esc>:make<cr>

" vygenerovani aktualnich ctagu
noremap <f7> :!ctags -R .<cr><cr>

" vypnout zvyrazneni nalezu
noremap <Leader>h :noh<CR>

" prochazeni mezi taby v MiniBufExplorer
" alt <a-, ctrl...
noremap <C-l> :MBEbn<cr>
noremap <C-h> :MBEbp<cr>
" pùvodní <C-l> na refresh obrazovky 
noremap <Leader><C-l> <C-l>

" Edit a file in the same directory as the current file
noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
" Insert a file in the same directory as the current file
noremap <Leader>r :r <C-R>=expand("%:p:h") . "/" <CR>

" manualove stranky
noremap K :Man <C-R><C-W><CR>

"--------------------------------------------------
" TAB smart completion
" changed: disabled the noignorecase
"--------------------------------------------------
"FIXME: predpoklad, ze chci jinde pouzivat ic
function InsertTabWrapper()
    "setlocal noic
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
function SetIC()
    "setlocal ic
    return ""
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr><c-r>=SetIC()<cr>

"//-----------------------------------------------------------------
" vlozeni ---- linky
noremap <Leader>- mzo<Esc>I-------------------------------------------------------------------<Esc>`zjj
noremap <Leader># mzo<Esc>I###################################################################<Esc>`zjj
noremap <Leader>% mzo<Esc>I% =================================================================<Esc>`zjj

"//-----------------------------------------------------------------
" MAN
au FileType man setlocal nonu

"//-----------------------------------------------------------------
" MAKEFILE
au FileType make setlocal noexpandtab softtabstop=0

au BufRead,BufEnter *.nse setlocal syntax=lua
au BufRead,BufEnter *.nse setlocal noexpandtab

" pokus pre xml....
filetype on
" zapnuti podpory FileTypePluginu
filetype plugin on
" odsazovani dle typu
filetype indent on

" nakonec zapnout zvyrazneni syntaxe
syntax on

" ===================================================================
" VIM - Editing and updating the vimrc:
" As I often make changes to this file I use these commands
" to start editing it and also update it:
  if has("unix")
    let vimrc='~/.vimrc'
  else
" ie:  if has("dos16") || has("dos32") || has("win32")
    let vimrc='$VIM\_vimrc'
  endif

" update
nn  <a-u> :source <C-R>=vimrc<CR><CR>
" edit .vimrc
nmap <a-v> :e ~/.vimrc<CR>

" kleopatra way:
nmap <leader>v :e ~/.vimrc<CR>
nn  <leader>u :source <C-R>=vimrc<CR><CR>

" edit ~/.vim/ftplugin/html/mapping.vim
"nmap <a-h> :e ~/.vim/ftplugin/html/mapping.vim<CR>


" nn  ,v :edit   <C-R>=vimrc<CR><CR>
"     ,v = vimrc editing (edit this file)
" map ,v :e ~/.vimrc<CR>
"     ,u = "update" by reading this file
" map ,u :source ~/.vimrc<CR>
" ===================================================================



" XML:

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Installed

" www.vim.org/scripts/script.php?script_id=301
" $ADDED/xml.vim

" www.vim.org/scripts/script.php?script_id=39
" copied macros/matchit.vim to plugin/

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" XML


let $ADDED = '~/.vim/added/'
if has("win32")
      let $ADDED = $VIM.'/added/'
endif

noremap <Leader>X :source $ADDED/xml.vim<CR>
  \:inoremap \> ><CR>
  \:echo "XML mode is on"<CR>
  \
  ":set filetype=xml<CR>
  "\:source $VIMRUNTIME/syntax/syntax.vim<CR>
  "\:set foldmethod=syntax<CR>
  "\:source $VIMRUNTIME/syntax/xml.vim<CR>
  "\:colors peachpuff<CR>
  "\:iunmap <buffer> <Leader>.<CR>
  "\:iunmap <buffer> <Leader>><CR>
  " no imaps for <Leader>
  "\:inoremap \. ><CR>

" catalog should be set up
"nmap <Leader>l <Leader>cd:%w !xmllint --valid --noout -<CR>
"nmap <Leader>r <Leader>cd:%w !rxp -V -N -s -x<CR>
"nmap <Leader>d4 :%w !xmllint --dtdvalid 
" \ "http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd"
" \ --noout -<CR>
"
"vmap <Leader>px !xmllint --format -<CR>
"nmap <Leader>px !!xmllint --format -<CR>
"nmap <Leader>pxa :%!xmllint --format -<CR>
"
"nmap <Leader>i :%!xsltlint<CR>
"
"" todo:
"" check
"" http://mugca.its.monash.edu.au/~djkea2/vim/compiler/xmllint.vim

" Transparent editing of gpg encrypted files.
augroup encrypted
au!
" First make sure nothing is written to ~/.viminfo while editing
" an encrypted file.
autocmd BufReadPre,FileReadPre      *.gpg set viminfo=
" We don't want a swap file, as it writes unencrypted data to disk
autocmd BufReadPre,FileReadPre      *.gpg set noswapfile
" Switch to binary mode to read the encrypted file
autocmd BufReadPre,FileReadPre      *.gpg set bin
autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
autocmd BufReadPre,FileReadPre      *.gpg let shsave=&sh
autocmd BufReadPre,FileReadPre      *.gpg let &sh='sh'
autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
autocmd BufReadPost,FileReadPost    *.gpg '[,']!gpg --decrypt --default-recipient-self 2> /dev/null
autocmd BufReadPost,FileReadPost    *.gpg let &sh=shsave
" Switch to normal mode for editing
autocmd BufReadPost,FileReadPost    *.gpg set nobin
autocmd BufReadPost,FileReadPost    *.gpg let &ch = ch_save|unlet ch_save
autocmd BufReadPost,FileReadPost    *.gpg execute ":doautocmd BufReadPost " . expand("%:r")
" Convert all text to encrypted text before writing
autocmd BufWritePre,FileWritePre    *.gpg set bin
autocmd BufWritePre,FileWritePre    *.gpg let shsave=&sh
autocmd BufWritePre,FileWritePre    *.gpg let &sh='sh'
autocmd BufWritePre,FileWritePre    *.gpg '[,']!gpg --encrypt --default-recipient-self 2>/dev/null
autocmd BufWritePre,FileWritePre    *.gpg let &sh=shsave
" Undo the encryption so we are back in the normal text, directly
" after the file has been written.
autocmd BufWritePost,FileWritePost  *.gpg silent u
autocmd BufWritePost,FileWritePost  *.gpg set nobin
augroup END  



"  ----------------------------------------------------
" ~/.vimrc ends here
"
