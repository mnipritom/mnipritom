bash = $(shell which bash)
utilities-directory = $(strip $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))
handle = $(bash) $(utilities-directory)/handler.bash handleUtilities
utilize = $(handle) "utilize"
parse = $(handle) "parse"
prompt:
	@ $(utilize) "links" "executables" "starship"
brew:
	@ $(utilize) "links" "executables" "brew"
brew-packages:
	@ $(utilize) "packages" "brew"
list-brew-packages:
	@ $(parse) "packages" "brew"
nix:
	@ $(utilize) "links" "executables" "nix"
nix-packages:
	@ $(utilize) "packages" "nix"
list-nix-packages:
	@ $(parse) "packages" "nix"
distribution-packages:
	@ $(utilize) "packages"
list-distribution-packages:
	@ $(parse) "packages"
list-packages: list-distribution-packages list-brew-packages list-nix-packages
executables:
	@ $(utilize) "links" "executables"
utilities: distribution-packages executables
