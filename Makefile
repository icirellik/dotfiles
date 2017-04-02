.PHONY: all bin dotfiles etc test tools shellcheck

all: bin dotfiles etc tools

bin:
	# add aliases for things in bin
	for file in $(shell find $(CURDIR)/bin -type f -not -name "todo" -not -name ".*.swp"); do \
		f=$$(basename $$file); \
		sudo ln -sf $$file /usr/local/bin/$$f; \
	done;

dotfiles:
	# add aliases for dotfiles
	for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".travis.yml" -not -name ".git" -not -name ".*.swp"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done;

etc:
	echo "etc"
#   for file in $(shell find $(CURDIR)/etc -type f -not -name ".*.swp"); do \
#     f=$$(echo $$file | sed -e 's|$(CURDIR)||'); \
#     sudo ln -f $$file $$f; \
#   done
	systemctl --user daemon-reload
	sudo systemctl daemon-reload

test: shellcheck

tools:
	if [ ! -d "$(HOME)/tools" ]; then \
		mkdir $(HOME)/tools; \
	fi;
	# Install Google Cloud SDK
	if [ ! -d "$(HOME)/tools/google-cloud-sdk" ]; then \
		curl https://sdk.cloud.google.com | bash -s -- --disable-prompts --install-dir=$(HOME)/tools; \
	fi;
	# Install node
	if [ ! -d "$(HOME)/tools/node" ]; then \
		curl -s -o /tmp/node-v7.8.0-linux-x64.tar.xz https://nodejs.org/dist/v7.8.0/node-v7.8.0-linux-x64.tar.xz; \
		tar xf /tmp/node-v7.8.0-linux-x64.tar.xz -C $(HOME)/tools; \
		ln -sf $(HOME)/tools/node-v7.8.0-linux-x64 $(HOME)/tools/node; \
		rm -f /tmp/node-v7.8.0-linux-x64.tar.xz; \
	fi;

# if this session isn't interactive, then we don't want to allocate a
# TTY, which would fail, but if it is interactive, we do want to attach
# so that the user can send e.g. ^C through.
INTERACTIVE := $(shell [ -t 0 ] && echo 1 || echo 0)
ifeq ($(INTERACTIVE), 1)
	DOCKER_FLAGS += -t
endif

shellcheck:
	docker run --rm -i $(DOCKER_FLAGS) \
		--name df-shellcheck \
		-v $(CURDIR):/usr/src:ro \
		--workdir /usr/src \
		r.j3ss.co/shellcheck ./test.sh
