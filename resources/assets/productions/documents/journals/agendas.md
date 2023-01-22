- bash:
  - [ ] implement `tmpfs` in `/etc/fstab`
    - [ ] fix `fstab` false reporting
  - [ ] implement checks for `init` system
    - [ ] implement `runnit` `init` system service handler
    - [ ] implement `systemd` specific `systemd-firstboot` usage to configure system
- dex:
  - [ ] generate `.desktop` files from `.xinitrc` entries with `dex`
- fzf:
  - [ ] a fun problem with `fzf-tab-completion` and `echo` `mattduck.com`
- resources:
  - [ ] explore audio format `webm`
- `sudoers`:
  - entry in the /etc/sudoers as
    ```
    `currentUser` ALL=(ALL:ALL) ALL
    ```
- `dab`: Distribution Agnostic and/or Assisted Bootstrapper
  - `void` can cross bootstrap as long as the architectures are compatible
    - example: `x86_64` can bootstrap `aarch64`
  - `debian` derivatives can "partially" cross bootstrap
    - `/debootstrap/debootstrap` is created at target where `debootstrap --second-stage` is needed to be run to complete bootstrap
    - `x86_64` is referred to as `amd64` in `debootstrap`
  - `fedora` can not cross bootstrap, needs emulation to target foreign architecture
  - information regarding `arch`, `opensuse` `nix` derivatives are unavailable
