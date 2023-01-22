bash = $(shell which bash)
git = $(shell which git)
worktree-path = $(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))
worktree-identifier = $(shell basename $(worktree-path))
worktree-remotes = $(shell $(git) remote show)
worktree-working-branch = $(shell $(git) branch --show-current)
commit-message = $(shell $(bash) -c 'read -p "Enter commit message: " message; echo $$message')
checkpoint:
	@ eval git commit --message \"$(commit-message)\"
milestone:
	$(foreach remote,$(worktree-remotes),$(shell git push $(remote) $(worktree-working-branch)))
