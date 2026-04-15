# Dotfiles repo rules

## Goal
Keep one canonical dotfiles repo on the laptop and distribute changes to other machines with minimal manual steps.

## Source of truth
- Canonical machine: laptop
- Other machines using dotfiles: kali VMs in Virtualbox, as dropboxes at networks
- Canonical repo metadata path: `~/.dotfiles`
- Helper scripts live in `~/.local/bin`
- Non-canonical machines are consumers by default

## Unsolved
- Scripts will eventually clobber and would be good to split into categories: for oscp/ctf/hacking, for dotfiles management, ...
- Allow sync for only a small subset of hosts temporarily and turning back sync for all hosts again (or specify on commmand line to sync all)

## Sync policy
- Prefer direct Git-over-SSH between laptop and machines
- GitHub is optional backup/mirror, not required for every sync
- Keep the main publishing flow short, ideally one wrapper command
- Avoid ad-hoc file copying when Git can carry history and diffs


## Safety policy
- Do not put long-lived Git push credentials on untrusted Kali VMs (no SSH keys stored on untrusted VMs)
- Untrusted VMs may be used for testing and temporary edits
- If importing changes from a VM, do it from the laptop after review
- Tracked files on non-canonical machines should be read-only by default
- Do not overwrite local tracked changes silently on non-canonical machines

## Editing model
- Preferred editing location: canonical laptop
- Non-canonical machines may be used for testing configs in place
- If a useful change is created on a VM, import it back to the laptop
- Keep the workflow understandable; avoid too many wrappers with unclear roles

## Current practical constraints
- `.local/bin` must stay a real directory on machines where Git-managed files live under it
- list of hosts will be in `hosts` file in this repo but not published to github
- Machine-specific additions should be handled conditionally e.g. as `.zshrc.hostname` and included from the main config file

## Machine-specific behavior
- VBox Kali VM may need:
  - `/media/kali-Shared/tools` added to `PATH`
~~  - host-only SSH or equivalent non-exposed management path~~

## VS Code / IDE use
- Use a dedicated Git worktree folder for editor/IDE work
- Keep durable workflow notes in repo files, not only in chat history

## Preferences for changes
- Avoid hardcoded tracked-file lists when Git can derive the file list
- Avoid regressions to manual symlink management
- Keep wrappers few, predictable, and named clearly