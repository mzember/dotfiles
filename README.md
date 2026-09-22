# Dotfiles

A bare-repo dotfiles setup: one canonical machine (the laptop) publishes config
to other machines (cloud VMs, VirtualBox VMs).

Properties:

- no long-lived Git/SSH push credentials on untrusted VMs
- Git diff/history/merge advantages
- a practical way to notice drift and import useful changes back

See `AGENTS.md` for the rules/policies behind these choices.

## Mental model

- **Bare repo:** `~/.dotfiles/` (the Git database; work-tree is `$HOME`).
- **Editor worktree:** `~/vs/dotfiles/` — a linked worktree of the same repo, so
  VS Code opens just the dotfiles, not all of `$HOME`. Commit here; the bare
  repo's `main` advances, then apply it to `$HOME` with `dotfiles sync local`.
- **Consumers** (VMs) hold a bare clone with `origin -> GitHub` and self-heal on
  login. They never get push credentials.

## Commands

Everything for **management** is under one umbrella so it's rediscoverable:

```
dotfiles help              # re-teaches all of this
dotfiles git <args>        # raw git on the bare repo (e.g. dotfiles git status)
dot <args>                 # short alias for `dotfiles git`
dotfiles sync <args>       # push/pull between machines (see below)
dotfiles add-host user@host
dotfiles selfupdate        # consumer pull-from-origin
dotfiles edit              # open the worktree in $EDITOR
```

Pentest/OSCP/CTF tools: `myip`,
`target`, `newtarget`, `ffuf-vhosts`, `digq`, `octet`, `splitnmapxml`, ...

## Everyday workflow

Edit in the worktree (`~/vs/dotfiles`), commit, then:

```sh
dotfiles sync local        # apply committed main to THIS machine ($HOME),
                           #   keeps your unstaged local edits, never deletes
dotfiles sync push         # push to all ENABLED hosts + GitHub
dotfiles sync push github  # just publish to GitHub
dotfiles sync push kalivm  # just one host
```

`push` skips offline hosts instead of failing, and preserves each host's local
edits unless you pass `--force`.

## Choosing which hosts sync

The host list is **untracked** (never published) at `~/.config/dotfiles/hosts`,
one ssh-alias per line; a leading `#` disables a line.

```sh
dotfiles sync list         # show enabled/disabled
dotfiles sync on  <host>   # enable (add / uncomment)
dotfiles sync off <host>   # disable (comment out, keep it)
```

## Importing a change made on a VM

```sh
# on the VM: commit the change to its bare repo
dotfiles git add <file> && dotfiles git commit -m "..."
# on the laptop:
dotfiles sync fetch <host>
dotfiles sync diff  <host>          # review
dotfiles git cherry-pick <host>/main
dotfiles sync push github           # publish; then reconcile the VM to origin
```

## Add a new machine

```sh
dotfiles add-host user@new-host     # bundles the repo, sets it up, enables sync
```

## Per-machine config

`.zshrc` sources `~/.zshrc.$HOST` (the machine's **full** hostname). Set a
descriptive hostname and create a matching file:

```sh
sudo hostnamectl set-hostname kalivm.virtualbox
# then: ~/.zshrc.kalivm.virtualbox   (PATH extras, self-heal hook, etc.)
```

## Consumer self-heal

On machines with an `origin` remote, `dotfiles selfupdate` (wired into the
per-host `.zshrc.<hostname>`, backgrounded on login) pulls the latest from
GitHub and applies only non-clobbering changes — so a VM that was offline
catches up next login without the laptop pushing.
