#!/bin/ruby -w

def pull url, dest
	Dir.chdir(ENV['HOME'])
	Dir.chdir('.vim/bundles')
	system('git clone', url, dest)
end

def download url, dest
	Dir.chdir(ENV['HOME'])
	Dir.chdir('.vim/colors/')
	system('wget', url)
end

bundles = {
	'https://github.com/vim-scripts/groovy.vim' => 'groovy.vim',
	'https://github.com/mileszs/ack.vim' => 'ack.vim',
	'https://github.com/tpope/vim-fugitive' => 'vim-fugitive',
	'https://github.com/derekwyatt/vim-scala' => 'vim-scala',
	'https://github.com/bling/vim-airline' => 'vim-airline',
	'http://github.com/digitaltoad/vim-jade.git' => 'vim-jade',
	'https://github.com/tfnico/vim-gradle' => 'vim-gradle',
	'https://github.com/tpope/vim-rvm' => 'vim-rvm',
	'https://github.com/scrooloose/nerdcommenter.git' => 'nerdcommenter',
	'https://github.com/tpope/vim-markdown' => 'vim-markdown',
	'https://github.com/altercation/vim-colors-solarized.git' => 'vim-colors-solarized',
	'https://github.com/othree/html5.vim' => 'html5.vim',
	'https://github.com/pangloss/vim-javascript.git' => 'vim-javascript',
	'http://github.com/wavded/vim-stylus.git' => 'vim-stylus',
	'https://github.com/vim-scripts/groovyindent' => 'groovyindent',
	'https://github.com/tpope/vim-vinegar' => 'vim-vinegar',
	'https://github.com/jistr/vim-nerdtree-tabs.git' => 'vim-nerdtree-tabs',
	'https://github.com/kien/ctrlp.vim.git' => 'ctrlp.vim',
	'https://github.com/sukima/xmledit.git' => 'xmledit',
	'https://github.com/vim-ruby/vim-ruby.git' => 'vim-ruby'
}

colors = {
	'https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim' => 'molokai.vim'
}

bundles.each_pair(&:pull)
colors.each_pair(&:download)

