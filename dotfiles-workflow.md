# Dotfiles workflow

## What I want

I want a dotfiles setup that gives me:

- one canonical machine
- easy sync to other machines
- Git diff/history/merge advantages
- no need to open my whole home directory in editors
- no long-lived Git/SSH push credentials on untrusted VMs
- a practical way to notice drift and import useful changes back
- minimal wrapper-script confusion

## Machines

### Canonical
- Laptop
- Main place where configs should normally be edited
- Holds the canonical bare repo:
  - `~/.dotfiles`

### Other machines
- Ubuntu VPS
- Kali VM in VirtualBox
- Kali VM / machine reachable mostly over SSH

These are usually consumers, not authorities.

## Repository model

I use a bare Git repo in:

```sh
~/.dotfiles
```

## Usage

# Define a function for the dotfiles command. This is more robust than an alias for scripts.
```sh
dotfiles() {
    /usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}
```

### Use up-to-date files locally
```sh
dotfiles checkout main
```
It may be needed to 
```sh
dotfiles checkout main --force
```
but be careful: it may delete files. Back up, and also commit and push first if those changes are intentional.

If the first command displays this:
```sh
dotfiles checkout main
D       .local/bin/nmap2nxc_spray.py
Already on 'main'
Your branch is up to date with 'origin/main'.
```
Then it means:
The origin/main does not have the file. If you commit the file, it will get removed. In this case, if you do not want to delete it, use
```sh
dotfiles checkout main --force
```

### Add new host

```sh
dotfiles-add-host <machine>
```

### Sync
```sh
dotfiles-sync
```

