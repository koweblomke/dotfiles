set nocompatible              " be iMproved, required
syntax on
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'

Plugin 'tpope/vim-rake'

Plugin 'rodjek/vim-puppet'

Plugin 'godlygeek/tabular'

" Plugin 'scrooloose/syntastic'

Plugin 'scrooloose/nerdtree'

Plugin 'jistr/vim-nerdtree-tabs'

Plugin 'Xuyuanp/nerdtree-git-plugin'

Plugin 'tomtom/tlib_vim'

Plugin 'MarcWeber/vim-addon-mw-utils'

Plugin 'garbas/vim-snipmate'

Plugin 'honza/vim-snippets'

Plugin 'vim-airline/vim-airline'

Plugin 'vim-airline/vim-airline-themes'

Plugin 'Yggdroot/indentLine'

Plugin 'flazz/vim-colorschemes'

Plugin 'thoughtbot/vim-rspec'

Plugin 'fatih/vim-go'

Plugin 'ryanoasis/vim-devicons'

Plugin 'ntpeters/vim-better-whitespace'

Plugin 'wincent/command-t'

Plugin 'w0rp/ale'

Plugin 'valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
let mapleader = " "

nnoremap rv :source $MYVIMRC<CR>
nnoremap <leader>ov :tabnew $MYVIMRC<CR>

nmap <F2> :NERDTreeTabsToggle<CR>
nmap <F3> :set number!<CR>
nmap <F4> :IndentLinesToggle<CR>
nmap <F5> :LeadingSpaceToggle<CR>

nnoremap <Leader>f :NERDTreeFind<CR>

let $RSPEC_emma = 'no'
let g:rspec_command = "!bundle exec rspec {spec}"
" go mappings
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)

" vim-rspec mappings
nnoremap <Leader>st :! clear<CR>:call RunCurrentSpecFile()<CR>
nnoremap <Leader>s :call RunNearestSpec()<CR>
nnoremap <Leader>l :call RunLastSpec()<CR>
nnoremap <Leader>a :call RunAllSpecs()<CR>
nnoremap <Leader>sp :!bundle exec rake spec_prep<CR>

"" open spec 
nmap <Leader>os :below split<CR>:e %:p:h:s?/manifests?/spec/classes?/%:t:r_spec.rb<CR>
"" open manifest
nmap <Leader>om :above split<CR>:e %:p:h:s?/spec/classes?/manifests?/%:t:r:s?_spec??.pp<CR>
"" open spec_acceptance 
nmap <Leader>ob :below split<CR>:e %:p:h:s?/manifests?/spec/acceptance?/%:t:r_spec.rb<CR>

" vim-beaker mapping
nnoremap <Leader>bn :! BEAKER_update_master=no BEAKER_debug=yes BEAKER_destroy=no BEAKER_set=rene bundle exec rspec %:p<CR>
nnoremap <Leader>bm :! BEAKER_update_master=yes BEAKER_debug=yes BEAKER_destroy=no BEAKER_set=rene bundle exec rspec %:p<CR>
nnoremap <Leader>bl :! BEAKER_update_master=no BEAKER_local_modules=~/work/vagrant/modules BEAKER_debug=yes BEAKER_destroy=no BEAKER_set=rene bundle exec rspec %:p<CR>
nnoremap <Leader>ba :! BEAKER_update_master=yes BEAKER_local_modules=~/work/vagrant/modules BEAKER_debug=yes BEAKER_destroy=no BEAKER_set=rene bundle exec rspec %:p<CR>
nnoremap <Leader>bu :! BEAKER_update_master=yes BEAKER_old_puppetfile=./spec/fixtures/old/Puppetfile BEAKER_new_puppetfile=./spec/fixtures/new/Puppetfile BEAKER_debug=yes BEAKER_destroy=no BEAKER_set=rene bundle exec rspec %:p<CR>

" Reveal the demo
nnoremap <Leader>rd :! reveal-md %:p --host $(hostname)<CR>

" Git fugitive mappings
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gd :Gdiff<CR>
nnoremap <Leader>gc :Gcommit -an<CR>i
nnoremap <Leader>gp :Gpush<CR>

" Tab navigations
nmap <silent> < gT
nmap <silent> > gt
nmap <silent> <C-t> :tabnew<CR>

" window navigations
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>
nmap <silent> <Leader>q :q<CR>
nmap <silent> <Leader>w :wq<CR>

" remove trailing whitespaces
nmap <Leader>rt :%s/\s\+$//e<CR>

set tabstop=2
set shiftwidth=2

set autoindent
set expandtab
set smarttab

set number

set statusline=%F
set statusline+=%m

set statusline+=%=%1*%y%*%*\              " file type
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%{fugitive#statusline()}
set statusline+=%10((%l,%c)%)\            " line and column
set statusline+=%P

set laststatus=2

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:solarized_termcolors=256
colorscheme solarized
set background=dark

let g:indentLine_char = '¦'
let g:indentLine_enabled = 0
let g:indentLine_leadingSpaceChar = '·'
let g:indentLine_leadingSpaceEnabled = 0

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

let g:ale_puppet_puppetlint_options='--no-140chars-check --no-documentation-check'
"let g:syntastic_puppet_puppetlint_args='--no-140chars-check --no-documentation-check' " --no_class_parameter_defaults-check' --no-class_inherits_from_params_class-check'
"let g:syntastic_yaml_checkers = ['yamllint']
"let g:syntastic_yaml_yamllint_exec = 'yaml-lint'
"let g:syntastic_debug = 1

au BufNewFile,BufRead Vagrantfile set ft=ruby
au BufNewFile,BufFilePre,BufRead *.md set ft=markdown
