all: nvim-install dotfiles-install

TAGS := all

macos-update: macos-prepare deps
	nvim --headless +PlugUpdate +qall
	nvim --headless +CocUpdate +qall

ubuntu-update: ubuntu-prepare deps
	nvim --headless +PlugUpdate +qall
	nvim --headless +CocUpdate +qall

dotfiles-install:
	 docker run --rm -e RUNNER_PLAYBOOK=dotfiles.yml -v $(HOME):/host/home -v $(CURDIR):/runner/project ansible/ansible-runner

nvim-install:
	mkdir -p ~/.config/nvim
	ln -sf $(PWD)/files/vimrc ~/.config/nvim/init.vim
	ln -sf $(PWD)/files/coc-settings.json ~/.config/nvim/coc-settings.json
	ln -snf $(PWD)/files/vim-ftplugins ~/.config/nvim/ftplugin

macos-prepare:
	brew upgrade neovim git the_silver_searcher fzf bat htop fd ncdu tldr httpie git-delta ripgrep
	brew install --HEAD universal-ctags/universal-ctags/universal-ctags
	curl -o /usr/local/bin/xkbswitch https://raw.githubusercontent.com/myshov/xkbswitch-macosx/master/bin/xkbswitch

deps: deps-gem deps-npm

deps-gem:
	gem install solargraph rubocop neovim
	gem install rubocop-rspec rubocop-rails rubocop-performance rubocop-rake
	gem install sorbet sorbet-runtime
	gem install haml_lint slim_lint
	gem install brakeman reek

deps-npm:
	npm install -g neovim
	npm install -g prettier eslint @babel/eslint-parser eslint-plugin-import eslint-plugin-node
	npx install-peerdeps -g eslint-config-airbnb
	npm install -g stylelint stylelint-config-recommended stylelint-config-standard
	npm install -g yaml-language-server markdownlint bash-language-server
	npm install -g dockerfile-language-server-nodejs
