
" NeoBundle ----------------------------------------
    if has('vim_starting')
      if &compatible
        set nocompatible               " Be iMproved
      endif

      " Required:
      set runtimepath+=~/.vim/bundle/neobundle.vim/
    endif

  " Required:
  call neobundle#begin(expand('~/.vim/bundle/'))

  " Let NeoBundle manage NeoBundle
  " Required:
  NeoBundleFetch 'Shougo/neobundle.vim'

  " ColorSheme
  NeoBundle 'ciaranm/inkpot'
  " Comment toggle
  NeoBundle 'tyru/caw.vim'
  " Bufferline
  NeoBundle 'ap/vim-buftabline'
  " Coffee script Plugin
  NeoBundle 'kchmck/vim-coffee-script'
  " MemoList
  NeoBundle 'glidenote/memolist.vim'
  " Markdown
  NeoBundle 'joker1007/vim-markdown-quote-syntax'
  NeoBundle 'godlygeek/tabular'
  NeoBundle 'kannokanno/previm'
  NeoBundle 'rcmdnk/vim-markdown'
  " Unite.vim & Filer
  NeoBundle 'Shougo/unite.vim'
  NeoBundle 'Shougo/vimfiler.vim'
  " Completion
  NeoBundle 'Shougo/neocomplete.vim'
  " Refer to |:NeoBundle-examples|.
  " Note: You don't set neobundle setting in .gvimrc!

  call neobundle#end()

  " Required:
  filetype plugin indent on

  " If there are uninstalled bundles found on startup,
  " this will conveniently prompt you to install them.
  NeoBundleCheck

" ColorSheme ---------------------------------------
  colorscheme inkpot
  syntax enable

" general ------------------------------------------
  set showmatch
  set mouse=a
  set nf=alpha
  set backspace=indent,eol,start
  set noswapfile
  set confirm
  set hidden
  set cindent
  set expandtab
  set shiftwidth=2
  set tabstop=2
  set wildmode=longest,list
  set number
  set title
  set list
  set listchars=tab:..,trail:_,eol:§,extends:>,precedes:<,nbsp:%
  set cursorline
  set showcmd
  set cmdheight=1
  set laststatus=2
  set t_Co=256
  set foldmethod=indent
  set encoding=utf-8
  set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp
  set clipboard+=autoselect
  set clipboard+=unnamed
  set incsearch
  set ignorecase
  set smartcase
  set magic
  set pastetoggle=<F4>
  set ruler " show line and column

" map ----------------------------------------------
  let mapleader=','
  nmap <F1> <Nop>
  nnoremap ; :
  vnoremap ; :
  nnoremap <silent> <C-n> :bn<CR>
  nnoremap <silent> <C-p> :bp<CR>
  inoremap <C-s> <Esc>:w<CR>
  inoremap <C-q> <Esc>:q<CR>
  nnoremap <C-s> <Esc>:w<CR>
  nnoremap <C-q> <Esc>:q<CR>

" autocmd ------------------------------------------
  autocmd BufEnter * :hi CursorLine ctermbg=235 guibg=DarkRed cterm=bold
  autocmd BufEnter * if &filetype == '' | setlocal filetype=markdown | endif
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.coffee set ft=coffee
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.conf set ft=configuration
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.{mkd,mk,markdown} set filetype=markdown 

" Revise Indent(CorrectCode) -----------------------
  inoremap <C-K> <Esc>:call CorrectCode()<CR>a
  nnoremap <C-K> :call CorrectCode()<CR>
  function! CorrectCode()
    execute ":mkview"
    execute ":normal gg=G"
    execute ":loadview"
  endfunction

" Count Charactor ----------------------------------
  command! Count %s/./&/g

" NeoComplete --------------------------------------
  "Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
  " Disable AutoComplPop.
  let g:acp_enableAtStartup = 0
  " Use neocomplete.
  let g:neocomplete#enable_at_startup = 1
  " Use smartcase.
  let g:neocomplete#enable_smart_case = 1
  " Set minimum syntax keyword length.
  let g:neocomplete#sources#syntax#min_keyword_length = 3
  let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

  " Define dictionary.
  let g:neocomplete#sources#dictionary#dictionaries = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.vimshell_hist',
        \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

  " Define keyword.
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns['default'] = '\h\w*'

  " Plugin key-mappings.
  inoremap <expr><C-g>     neocomplete#undo_completion()
  inoremap <expr><C-l>     neocomplete#complete_common_string()

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    " return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
    " For no inserting <CR> key.
    return pumvisible() ? "\<C-y>" : "\<CR>"
  endfunction
  " <TAB>: completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
  " Close popup by <Space>.
  "inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

  " AutoComplPop like behavior.
  "let g:neocomplete#enable_auto_select = 1

  " Shell like behavior(not recommended).
  "set completeopt+=longest
  "let g:neocomplete#enable_auto_select = 1
  "let g:neocomplete#disable_auto_complete = 1
  "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

  " Enable omni completion.
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

  " Enable heavy omni completion.
  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif
  "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
  "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
  "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

  " For perlomni.vim setting.
  " https://github.com/c9s/perlomni.vim
  let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" Previm -------------------------------------------
  let g:previm_open_cmd = 'open -a "/Applications/Google Chrome.app/"'

" MemoList -----------------------------------------
  let g:memolist_path = "~/tmp/MemoList"
  nnoremap <Leader>mn  :MemoNew<CR>
  nnoremap <Leader>ml  :MemoList<CR>
  nnoremap <Leader>mg  :MemoGrep<CR>

" Unite.vim & Vimfiler -----------------------------
  " Unite.vim
  let g:unite_enable_start_insert = 1
  let g:unite_source_history_yank_enable = 1
  nnoremap <silent> <Leader>ua :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
  nnoremap <silent> <Leader>ub :<C-u>Unite<Space>buffer<CR>
  nnoremap <silent> <Leader>ur :<C-u>Unite<Space>register<CR>
  autocmd FileType unite call s:unite_my_settings()
  function! s:unite_my_settings()
    nmap <buffer> <ESC> <Plug>(unite_exit)
    nnoremap <silent><buffer><expr> f unite#smart_map('f', unite#do_action('vimfiler'))
    inoremap <silent><buffer><expr> f unite#smart_map('f', unite#do_action('vimfiler'))
  endfunction
  " Vimfiler
  let g:vimfiler_as_default_explorer = 1
  nnoremap <silent> <Leader>f :VimFiler<CR>

" Caw(comment toggle) ------------------------------
  imap  <Esc><Plug>(caw:i:toggle)a
  nmap  <Plug>(caw:i:toggle)
  vmap  <Plug>(caw:i:toggle)

" IndentGuide --------------------------------------
  nnoremap <silent> <Fj> :IndentGuidesToggle<CR>
  nnoremap <silent> <F2> :set hlsearch! hlsearch?<CR>
