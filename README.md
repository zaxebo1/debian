# Playbook

Configuration and maintenance of a host running Debian 11.


## Example usage

```sh
$ ansible-playbook playbook_local.yml --ask-become-pass --tags "role_base,role_software"
```


## Roles

### [base](/roles/base/)
Basic preparation of the target host. Unequivocally opinionated, make sure it is in line with your preferences.

### [software](/roles/software/)
Installation and configuration of various userland packages.

### [dotfiles](/roles/dotfiles/)
Distributes dotfiles to the target host.

### [transfer_agent](/roles/transfer_agent/)
Creates jailed user with rather limited `chroot`. Supports automatic propagation of SSH keys.

### [wireguard](/roles/wireguard/)
Provisions Wireguard in any mode imaginable.

### [nginx](/roles/nginx/)
Configures web-server and enrolls an arbitrary number of domains on a remote `nginx` instance.

### [etesync](/roles/etesync/)
EteBase server running on `uvicorn` and `nginx`, includes automatic HTTPs via `certbot`.
