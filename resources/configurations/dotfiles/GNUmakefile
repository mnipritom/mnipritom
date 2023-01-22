bash = $(shell which bash)
dotfiles = $(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))
entries = $(foreach entry, $(shell ls --directory $(dotfiles)/*/), $(shell basename $(entry)))
handle = $(bash) $(dotfiles)/handler.bash handleDotfiles
deploy = $(handle) "deploy"
retract = $(handle) "retract"
shell:
	@ $(deploy) "bash"
cleanup-shell:
	@ $(retract) "bash"
dotfiles:
	@ $(deploy) "all"
cleanup-dotfiles:
	@ $(retract) "all"
efficient-dotfiles:
	@ $(deploy) "efficient"
cleanup-efficient-dotfiles:
	@ $(retract) "efficient"