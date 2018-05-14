.PHONY: all all-osx bin check-install-tools check-test-tools check-osx check-linux dotfiles etc test tools shellcheck usr

PLATFORM := $(shell uname)

all: check-linux check-install-tools bin dotfiles etc usr tools

all-osx: check-osx check-install-tools bin dotfiles tools

check-osx:
	if [ "$(PLATFORM)" != "Darwin" ]; then \
		echo Must be run on macOS; \
		exit 1; \
	fi

check-linux:
	if [ "$(PLATFORM)" != "Linux" ]; then \
		echo Must be run on Linux; \
		exit 1; \
	fi

bin:
	# add aliases for things in bin
	for file in $(shell find $(CURDIR)/bin -type f -not -name "todo" -not -name ".*.swp"); do \
		f=$$(basename $$file); \
		sudo ln -svfn $$file /usr/local/bin/$$f; \
	done;

# Tools require to execute the make file.
check-install-tools:
	command -v curl;
	command -v python;
	command -v jq;

# Tool required to run the make test command.
check-test-tools:
	command -v docker;

dotfiles:
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".travis.yml" -not -name ".git" -not -name ".*.swp"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done;
	ln -sfn $(CURDIR)/.gnupg/gpg.conf $(HOME)/.gnupg/gpg.conf;
	ln -sfn $(CURDIR)/.gnupg/gpg-agent.conf $(HOME)/.gnupg/gpg-agent.conf;
	mkdir -p $(HOME)/.config/Code/User
	ln -sfn $(CURDIR)/.config/Code/User/settings.json $(HOME)/.config/Code/User/settings.json

etc:
	echo "etc";
	for file in $(shell find $(CURDIR)/etc -type f -not -name ".*.swp"); do \
		f=$$(echo $$file | sed -e 's|$(CURDIR)||'); \
		sudo ln -sf $$file $$f; \
	done; \
	systemctl --user daemon-reload;
	sudo systemctl daemon-reload;

usr:
	for file in $(shell find $(CURDIR)/usr -type f -not -name ".*.swp"); do \
		f=$$(echo $$file | sed -e 's|$(CURDIR)||'); \
		sudo ln -sf $$file $$f; \
	done; \
	systemctl --user daemon-reload;
	sudo systemctl daemon-reload;

test: check-test-tools shellcheck

tools:
	# Install git
	./bin/git.sh
	# Install vim plugins
	if [ ! -d "$(HOME)/.vim/bundle" ]; then \
		git clone https://github.com/VundleVim/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim; \
		vim +PluginInstall +qall; \
	fi;
	# Install tmux plugin manager
	if [ ! -d "$(HOME)/.tmux/plugins/tpm" ]; then \
		git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm; \
	fi
	# Make the tools directory
	if [ ! -d "$(HOME)/tools" ]; then \
		mkdir $(HOME)/tools; \
	fi;
	# Install Google Cloud SDK
	./bin/google-cloud-sdk.sh
	# Install node
	./bin/node.sh
	# Install flyway
	if [ ! -d "$(HOME)/tools/flyway" ]; then \
		curl -s -o /tmp/flyway-commandline-4.1.2-linux-x64.tar.gz https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/4.1.2/flyway-commandline-4.1.2-linux-x64.tar.gz; \
		tar xf /tmp/flyway-commandline-4.1.2-linux-x64.tar.gz -C $(HOME)/tools; \
		ln -sf $(HOME)/tools/flyway-4.1.2 $(HOME)/tools/flyway; \
		rm -f /tmp/flyway-commandline-4.1.2-linux-x64.tar.gz; \
	fi;
	# Install syncthing
	if [ ! -d "$(HOME)/tools/syncthing" ]; then \
		curl -L -s -o /tmp/syncthing-linux-amd64-v0.14.31.tar.gz https://github.com/syncthing/syncthing/releases/download/v0.14.31/syncthing-linux-amd64-v0.14.31.tar.gz; \
		tar xf /tmp/syncthing-linux-amd64-v0.14.31.tar.gz -C $(HOME)/tools; \
		ln -sf $(HOME)/tools/syncthing-linux-amd64-v0.14.31 $(HOME)/tools/syncthing; \
		rm -f /tmp/syncthing-linux-amd64-v0.14.31.tar.gz; \
		sudo ln -sf $(HOME)/tools/syncthing/syncthing /usr/local/bin/syncthing; \
		sudo cp -f --remove-destination etc/systemd/system/syncthing@.service /etc/systemd/system/; \
		sudo systemctl daemon-reload; \
		sudo systemctl enable "syncthing@$$USER"; \
		sudo systemctl start "syncthing@$$USER"; \
	fi;

# if this session isn't interactive, then we don't want to allocate a
# TTY, which would fail, but if it is interactive, we do want to attach
# so that the user can send e.g. ^C through.
INTERACTIVE := $(shell [ -t 0 ] && echo 1 || echo 0)
ifeq ($(INTERACTIVE), 1)
	DOCKER_FLAGS += -t
endif

shellcheck:
	docker pull r.j3ss.co/shellcheck; \
	docker run --rm -i $(DOCKER_FLAGS) \
		--name df-shellcheck \
		-v $(CURDIR):/usr/src:ro \
		--workdir /usr/src \
		r.j3ss.co/shellcheck ./test.sh
