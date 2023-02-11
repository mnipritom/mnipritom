SHELL := $(shell which bash)
worktree-path := $(strip $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))
worktree-remotes := $(shell git remote show)
worktree-working-branch := $(shell git branch --show-current)
git-push = $(shell git push $(1) $(2))
milestone:
	@ $(foreach remote, $(worktree-remotes), $(call git-push, $(remote), $(worktree-working-branch)))
progress:
	@ $(shell git fetch --all)
	@ $(shell git pull --rebase=true $(firstword $(worktree-remotes)) $(worktree-working-branch))
