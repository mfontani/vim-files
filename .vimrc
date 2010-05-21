"" to be synced with http://darkpan.com/vimrc

set nocompatible  " use vim -- not vi -- defaults
set ls=2          " always show status line

" Tabs v spaces
"set tabstop=2
"set shiftwidth=2
set tabstop=4
"set tabstop=8
set shiftwidth=4
set expandtab
set showmatch     " show matching braces
set nowrap        " don't wrap lines
set number        " show line numbers
set autoindent
set smartindent
set cindent       " maybe?

set backspace=indent,eol,start  " unindent with backspace, allow backspace to previous line and from start of insert mode

:set statusline=%<%f\ \ \ \ [%1*%M%*%n%R%H]\%=[%{&ff}\ %{&fileencoding}]\ [type=%Y]\ [ASCII=%03.3b\ HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [len=%L]

" source $VIMRUNTIME/mswin.vim
behave xterm
" ttymouse=xterm for tmux, xterm2 for screen
set ttymouse=xterm
set mouse=n   " normal mode only: move around with mouse, but can paste in insert mode
" Remap Ctrl+Z to suspend vim
map <C-z> :stop<CR>
set cursorline

"" Bottom stuff
set scrolloff=3   " keep 3 lines when scrolling
set showcmd       " show incomplete commands
set hlsearch      " highlight searchs
set incsearch     " do incremental search
set ruler         " show with cursor position
"set visualbell t_vb=   " turn off the visual bell
set title         " title terminal
set ttyfast       " smoother changes
"set ttyscroll=0   " turn off scrolling -- does *not* work with PuTTY?

set ignorecase    " ignore case when searching
"set infercase     " infer case when searching
set modeline      " modelines may set the doc mode

"" Syntax and highlighting
syntax on

" Highlights before selecting color scheme
:autocmd ColorScheme * highlight Todo ctermbg=red ctermfg=white
":autocmd ColorScheme * highlight Normal ctermbg=NONE
":autocmd ColorScheme * highlight Normal ctermbg=NONE
:autocmd BufWinEnter * match Todo /TODO/
:autocmd BufWinEnter * match Todo /TODO:/
:autocmd BufWinEnter * match Todo /FIXME/
:autocmd BufWinEnter * match Todo /FIXME:/
:autocmd BufWinEnter * match Todo /XXX/
:autocmd BufWinEnter * match Todo /MARCO/

" was grey instead of 242
:highlight NoTabs ctermbg=242
:autocmd BufWinEnter :highlight NoTabs ctermbg=242
:autocmd BufWinEnter * match NoTabs /\t/
:autocmd ColorScheme * highlight NoTabs ctermbg=242

:highlight TabLineFill ctermfg=black
:highlight TabLine ctermfg=grey
:highlight TabLineSel ctermfg=cyan

if has("gui_running")
  set guifont=-b&h-lucidatypewriter-medium-r-normal-*-*-120-*-*-m-*-iso10646-1
  "set guifont=Monospace\ 10    " this font
  colorscheme zenburn
else
  " terminal supports 256 colors:
  set t_Co=256
  "let g:zenburn_force_dark_Background = 1
  "let g:zenburn_high_Contrast=1
  colorscheme zenburn
  "colorscheme elflord          " the Elf preservation society
  "highlight Normal ctermbg=NONE
  "highlight Normal ctermbg=NONE
endif
":highlight MatchParen ctermbg=grey ctermfg=red
" a( () 123 ) test( 123 )
" show trailing whitespace
:autocmd BufWinEnter * highlight ExtraWhitespace ctermbg=darkred guibg=lightgreen
:autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/

if has("autocmd")
  filetype plugin indent on
  " Various for helpfiles
  au BufnewFile,BufRead *.t set filetype=perl
  au BufnewFile,BufRead *.p[lm] set filetype=perl
  au BufnewFile,BufRead *.tt set filetype=html
  au BufnewFile,BufRead *.tmpl set filetype=html
  au FileType helpfile set nonumber                   " no line numbers on help files
  au FileType helpfile nnoremap <buffer><cr> <c-]>    " enter jumps to subject
  au FileType helpfile nnoremap <buffer><bs> <c-T>    " backspace jumps back
  " Perl stuff
  au FileType t,pl,pm set syntax=perl
  "au FileType perl set makeprg=perl\ -c\ %\ $*
  "au FileType perl set autowrite
  "au FileType perl set makeprg=perl\ $VIMRUNTIME/tools/efm_perl.pl\ -c\ %\ $*
  au FileType perl set makeprg=perl\ $VIMRUNTIME/tools/efm_perl.pl\ -c\ %
  au FileType perl set errorformat=%f:%l:%m       " may work with efm_perl.pl
  au FileType perl set cinkeys-=0#      " remove forced outdending of perl comments
  au FileType dot set makeprg=dot\ -T$*\ \"%:p\"\ -o\ \"%:p:r.$*\"
  " XML folding
  let g:xml_syntax_folding=1
  au FileType xml setlocal foldmethod=syntax
endif

"" Keymaps
map <F2> :previous<CR>          " F2: previous buffer
map <F3> :next<CR>              " F3: next buffer
map ,v :sp ~/.vimrc<CR>         " ,v: edit ~/.vimrc in a split
map ,e :e ~/.vimrc<CR>          " ,e: edit ~/.vimrc in current buffer
map ,u :source ~/.vimrc<CR>     " ,u: update vimrc

"" Sets how to auto-complete with CTRL+P
" :set complete=key,key,key
" . Current file
" b Files in loaded buffers, not in a window
" d Definitions in the current file and in files included by a #include directive
" i Files included by the current file through the use of a #include directive
" k The file defined by the "dictionary" option (discussed later in this chapter)
" kfile The file named {file}
" t The "tags" file. (The ] character can be used as well.)
" u Unloaded buffers
" w Files in other windows
" In my case, .,b,k should suffice (still testing!)
set complete=.,b,d,t,k

" perl -cw buffer, using a temp file, into a new window
function! PerlCW()
  let l:tmpfile1 = tempname()
  let l:tmpfile2 = tempname()
  execute "normal:w!" . l:tmpfile1 . "\<CR>"
  execute "normal:! perl -cw ".l:tmpfile1." \> ".l:tmpfile2." 2\>\&1 \<CR>"
  execute "normal:new\<CR>"
  execute "normal:edit " . l:tmpfile2 . "\<CR>"
endfunction

" map <F4> to close the current buffer
map <silent> <F4> :close<CR>
map <silent> <xF4> :close<CR>

" NERDTree toggling
map <silent> <F8> :NERDTreeToggle<CR>
map <silent> <xF8> :NERDTreeToggle<CR>

map <silent> ,t :!prove -I. --color --verbose % 2<&1<CR>
map <silent> ,T :!prove -I. --color --verbose % 2<&1 \| less<CR>

" use ,cd to LCD to the currently edited file's path
map ,cd :lcd %:p:h<CR>

" 'perl -cw' current buffer into a new window
"function! BufferPerlCW()
"    let l:tmpfile1 = tempname()
"    let l:tmpfile2 = tempname()
"    execute "normal:w!" . l:tmpfile1 . "\<cr>"
"    execute "normal:!perl -I. -cw " . l:tmpfile1 . " \> " . l:tmpfile2 . " 2\>\&1 \<cr>"
"    execute "normal:tabnew\<cr>"
"    execute "normal:edit " . l:tmpfile2 . "\<cr>"
"endfunction
"map <F6> :call BufferPerlCW()<CR>
"imap <F6> <Esc>:call BufferPerlCW()<CR>
map <silent> <F5> :make<CR>
imap <silent> <F5> <Esc>:make<CR>

" toggle/untoggle autocomplpop
map <F7> :AcpLock<CR>
imap <F7> <Esc>:AcpLock<CR>
map <S-F7> :AcpUnlock<CR>
imap <S-F7> <Esc>:AcpUnlock<CR>

map <F9> :!./%<CR>
imap <F9> <Esc>:!./%<CR>

" Open explorer with F12
map <F12> :E<CR>
imap <F12> <Esc>:E<CR>

" Tab in visual mode indents
nmap <tab> I<tab><esc>
nmap <s-tab> ^i<bs><esc>

" show tabs as a « followed by spaces, extends as dots, eol as paragraph
set list
set listchars=tab:«-,trail:.,extends:·,eol:¶

" set/unset paste with F11
set pastetoggle=<F11>

" Perl does include pod stuff in the code
let perl_include_pod=1
" And complex stuff may be found in code like @{${"foo"}}
let perl_extended_vars=1

" Folding perl code
let perl_fold=1
"let perl_fold_blocks=1
"unlet perl_fold_packages
set foldmethod=syntax
set foldcolumn=3
set foldlevel=1

" Deparse code
nnoremap <silent> ,d :.!perl -MO=Deparse 2>/dev/null<CR>
vnoremap <silent> ,d :!perl -MO=Deparse 2>/dev/null<CR>

" Tidy selected lines (or entire file) with _t:
if ( match(hostname(), 'dev') >= 0 )
    " refactor perl code in a sub
    vmap <silent> \pr :!perl $HOME/bin/prefactor-extract-sub XXX
endif
" uses /usr/local/etc/perltidyrc
nnoremap <silent> \t :%!perltidy -q<Enter>
vnoremap <silent> \t :!perltidy -q<Enter>

""""" http://search.cpan.org/dist/Perl-Tags/lib/Perl/Tags.pm
setlocal iskeyword+=:  " make tags with :: in them useful

"if ! exists("s:defined_functions")
"  function s:init_tags()
"    perl <<EOF
"    use Perl::Tags;
"    $naive_tagger = Perl::Tags::Naive->new( max_level=>2 );
"    # only go one level down by default
"EOF
"  endfunction
"
"  " let vim do the tempfile cleanup and protection
"  let s:tagsfile = tempname()
"
"  function s:do_tags(filename)
"    perl <<EOF
"      my $filename = VIM::Eval('a:filename');
"      $naive_tagger->process(files => $filename, refresh=>1 );
"      my $tagsfile=VIM::Eval('s:tagsfile');
"      VIM::SetOption("tags+=$tagsfile");
"      # of course, it may not even output, for example, if there's nothing new to process
"      $naive_tagger->output( outfile => $tagsfile );
"EOF
"  endfunction
"
"  call s:init_tags() " only the first time
"
"  let s:defined_functions = 1
"endif
"
"call s:do_tags(expand('%'))
"augroup perltags
"  au!
"  autocmd BufRead,BufWritePost *.cgi,*.pm,*.pl call s:do_tags(expand('%'))
"augroup END
"""""" http://search.cpan.org/dist/Perl-Tags/lib/Perl/Tags.pm

"" update screen term
"autocmd BufEnter * let &titlestring = hostname() . "[vim(" . expand("%:t") . ")]"
"autocmd BufEnter * let &titlestring = "vim(" . expand("%:t") . ")"
"set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)
set titlestring=vim\ %t\ %M
if &term == "screen"
    set t_ts=
    set t_fs=
endif
if &term == "screen" || &term == "xterm"
    set title
endif

" enable autocomplpop for perlomni. -- done automatically!!
"set g:acp_behaviorPerlOmniLength=2

" Find file in current (Git repos) directory, to edit it.
function! Find(...)
    let l:gitrevparse=system("git rev-parse 2>&1")
    if strlen(l:gitrevparse)
        let tmpfile = tempname()
        exe "redir! > " . tmpfile
        silent echon ""
        redir END
        echo "Find: FATAL: not in a git repos"
        return
    endif
    let path="."
    if a:0==2
        let path=a:2
    endif
    let l:list=system("git ls-files '*" . a:1 . "*'")
    let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))
    if l:num < 1
        echo "Find: WARNING: '*".a:1."*' not found"
        return
    endif
    let tmpfile = tempname()
    exe "redir! > " . tmpfile
    silent echon l:list
    redir END
    let old_efm = &efm
    set efm=%f
    if exists(":cgetfile")
        execute "silent! cgetfile " . tmpfile
    else
        execute "silent! cfile " . tmpfile
    endif
    let &efm = old_efm
    "Open  the  quickfix  window  below  the  current  window
    botright copen
    call delete(tmpfile)
endfunction
command! -nargs=* Find :call Find(<f-args>)

