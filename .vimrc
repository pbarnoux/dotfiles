" Based on http://stevelosh.com/blog/2010/09/coming-home-to-vim/

" Bash integration
let $BASH_ENV = "~/.bash_profile"
set shell=/bin/bash

" Pathogen handles vim modules
filetype off
call pathogen#infect()
filetype plugin indent on

" Give up on vi compatibility
set nocompatible

" Remap ; to :
nmap ; :

" Turn syntax on
syntax on
" Possible schemes are in ~/.vim/colors
" Use 256 colors for terminal
set t_Co=256
colorscheme molokai
" colorscheme fokus

" Prevents security exploits on modelines (not used anyways)
set modelines=0

" Default behavior of vim
set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
" uncomment to underline the current line
" set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
" display relative line numbers from current line in margin
set nu
set relativenumber
" store undo history inside file named <FILENAME>.un~
" set undofile

" time out on key codes
set notimeout
set ttimeout
set ttimeoutlen=10

" tabs configuration (currently 4 spaces)
" check http://vimcasts.org/episodes/tabs-and-spaces/ for more infos
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" search configuration
" use Perl regex by default, vim regex when using \v
nnoremap / /\v
vnoremap / /\v
" Case sensitive if there is at least an uppercase character given
set ignorecase
set smartcase
" substitution applies globally by default
set gdefault
" incremental search (with highlight)
set incsearch
set showmatch
" highlight results, clear highlighting with \<space>
set hlsearch
nnoremap <leader><space> :noh<cr>
" use <tab> instead of % to match brackets
nnoremap <tab> %
vnoremap <tab> %

" line length management
" for more information
"  * help : :help fo-tabl
"  * soft-wrapping : http://vimcasts.org/episodes/soft-wrapping-text/
"  * hard-wrapping : http://vimcasts.org/episodes/hard-wrapping-text/
set wrap
set textwidth=79
set formatoptions=qrn1

" save when focus is lost on a tab
au FocusLost * :silent! wall

" split screen
" \w opens a new vertical split and switch to it
nnoremap <leader>w <C-w>v<C-w>1
" resize splits when window is resized
au VimResized * :wincmd =

" shows trailing whitespaces when not in insert mode
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Make sure Vim returns to the same line when you reopen a file.
augroup line_return
    au!
    au BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \     execute 'normal! g`"zvzz' |
        \ endif
augroup END

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" Change directory to the current buffer when opening files.
set autochdir

"Whenever i forget to use sudo vim... Now just write with 'w!!'
cmap w!! w !sudo tee >/dev/null %

" Plugin configuration
"
" >> Ack (grep for programmers)
nnoremap <leader>a :Ack!<space>
let g:ackprg = 'ack --smart-case --nogroup --nocolor --column'

" >> Airline status bar
" Handle tabs
let g:airline#extensions#tabline#enabled = 1
" Change terminal font
set guifont=DejaVu\ Sans\ Mono\ 10
" Use power fonts
let g:airline_powerline_fonts = 1
" Use powerlineish theme
let g:airline_theme = 'powerlineish'

" >> Netrw (file explorer)
nnoremap <leader>E :Te \| tabm 0<CR>
" Toggle Vexplore with Ctrl-E
function! ToggleVExplorer()
  if exists("t:expl_buf_num")
      let expl_win_num = bufwinnr(t:expl_buf_num)
      if expl_win_num != -1
          let cur_win_nr = winnr()
          exec expl_win_num . 'wincmd w'
          close
          exec cur_win_nr . 'wincmd w'
          unlet t:expl_buf_num
      else
          unlet t:expl_buf_num
      endif
  else
      exec '1wincmd w'
      Vexplore
      let t:expl_buf_num = bufnr("%")
  endif
endfunction
map <silent> <C-E> :call ToggleVExplorer()<CR>
" tree-view
let g:netrw_liststyle = 3
" sort is affecting only: directories on the top, files below
let g:netrw_sort_sequence = '[\/]$,*'
" Hit enter in the file browser to open the selected
" file with :vsplit to the right of the browser.
let g:netrw_browse_split = 4
let g:netrw_altv = 1

" >> ctrlp (fuzzy finder)
" open ctrlp with <leader>p
let g:ctrlp_map = '<leader>p'
" Open files in new tab
let g:ctrlp_open_new_file = 't'
let g:ctrlp_open_multiple_files = 't'
" Ignore non source files
set wildignore+=*.class,.git,.hg,.svn,target/**

" file specific
"
" java
augroup ft_java
    au!

    " Use tab to indent
    set noexpandtab
    au FileType java setlocal foldmethod=marker
    au FileType java setlocal foldmarker={,}
augroup END

function s:ReadClass(dir, classname)
    execute "cd " . a:dir
    execute "0read !javap -c " . a:classname
    1
    setlocal readonly
    setlocal nomodified
endfunction

autocmd BufReadCmd *.class
    \ call <SID>ReadClass(expand("<afile>:p:h"), expand("<afile>:t:r"))

" scala
augroup ft_scala
    au!

    " Use tab to indent
    set noexpandtab
    au Filetype scala setlocal foldmethod=marker foldmarker={,}
augroup END

" xml
augroup ft_xml
    au!

    " Use tab to indent
    set noexpandtab
    au FileType xml setlocal foldmethod=manual

    " Use <localleader>f to fold the current tag.
    au FileType xml nnoremap <buffer> <localleader>f Vatzf

    " Indent tag
    au FileType xml nnoremap <buffer> <localleader>= Vat=
augroup END

" pom
augroup ft_pom
	au!

	" Use same syntax as xml
	set filetype=xml
augroup END

" gradle
augroup ft_gradle
	au!

	" Use tab to indent
	set noexpandtab
	" Use same syntax as groovy
	set filetype=groovy
augroup END

" ruby
augroup ft_rb
	au!
augroup END

" javascript
augroup ft_js
	au!
augroup END

" css
augroup ft_css
	au!
augroup END

" jade
"augroup fr_jade
	"au!

	" Set tab size to 2 but use tab to indent
	"set tabstop=2
	"set shiftwidth=2
	"set softtabstop=2
	"set noexpandtab
"augroup END

