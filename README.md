# dotfiles

Personal config files managed with [GNU Stow](https://www.gnu.org/software/stow/) and backed up
to GitHub.

## How it works

The real config files live in this repo. Stow creates **symlinks** from their normal locations
back into it, so programs read their configs from the usual paths while everything stays inside
a git repo.

```
~/.config/nvim  ->  ~/dotfiles/nvim/.config/nvim
~/.bashrc       ->  ~/dotfiles/bash/.bashrc
```

## Layout

Each top-level folder is a **package**. Inside a package, recreate the path exactly as it appears
under `~`:

```
~/dotfiles/
├── bash/
│   └── .bashrc                 -> ~/.bashrc
└── nvim/
    └── .config/nvim/           -> ~/.config/nvim/
```

The package name itself never appears in the symlink path — it only exists so packages can be
stowed and unstowed independently.

A package doesn't have to own a whole directory. Include just the files you want and Stow
links only those, leaving everything else in the target directory alone:

```
~/dotfiles/
└── omarchy/
    └── .config/omarchy/
        ├── shell.json          -> ~/.config/omarchy/shell.json
        └── shell.toml          -> ~/.config/omarchy/shell.toml
```

This works because `~/.config/omarchy/` already exists as a real directory. Stow only
swallows a directory whole when the target **doesn't** exist yet (see the folding note
below), so here it descends and links the two files individually. Check with
`stow -n -v <name>` if unsure — it prints one `LINK:` line per symlink it would create.

## Setup on a new machine

```bash
sudo pacman -S stow git

# 1. clone into ~/dotfiles
cd ~
git clone <repo-url> dotfiles
cd ~/dotfiles

# 2. move any existing configs aside — stow won't overwrite real files
mv ~/.bashrc ~/.bashrc.orig

# 3. deploy
stow */              # everything
stow bash nvim       # or specific packages
```

Always run stow from inside `~/dotfiles` — it targets the parent directory by default.

Verify with `ls -l ~/.bashrc`; it should point into `dotfiles/`.

## Daily use

Edit configs at their normal paths — through the symlink, that *is* the repo file.

```bash
cd ~/dotfiles
git status
git add -A
git commit -m "Describe the change"
git push
```

On another machine:

```bash
git pull
stow -R */           # restow, needed when new files or directories arrive
```

## Adding a package

```bash
cd ~/dotfiles
mkdir -p mako/.config
mv ~/.config/mako mako/.config/mako     # move the real config in
stow mako                               # link it back out

git add mako
git commit -m "Add mako config"
git push
```

Alternatively `stow --adopt mako` pulls existing files from `~` into the repo automatically.
It overwrites the repo copy with the version from `~`, so check `git diff` afterwards.

## Removing configs you no longer need

Because the files live in the repo, deleting them from the computer and staging
the deletion is one step. `git rm` does both:

```bash
cd ~/dotfiles
git rm path/to/file                    # one file
git rm -r package/                     # a whole package

git commit -m "Remove unused config"
git push
```

If a package is currently stowed, unstow it **before** deleting the folder:

```bash
stow -D name        # 1. remove the symlinks first
git rm -r name      # 2. then delete
```

`stow -D` works out which symlinks to remove by reading what's inside the
package folder. Delete the folder first and it can't identify them anymore,
leaving a broken symlink to clean up by hand.

## Recovering deleted files

Nothing committed is ever really gone — deleting a file removes it from the
working tree, not from history. As long as the deletion was committed *after*
the file was, the old version is still on GitHub.

```bash
# find the commit that removed it, and the one before
git log --oneline -- path/to/file

# look at the old version without restoring it
git show <commit>:path/to/file

# restore a single file
git checkout <commit> -- path/to/file

# restore a whole directory as it was at that commit
git checkout <commit> -- package/
```

Use any commit where the file still existed — usually the one just before the
deletion. After restoring, run `stow -R name` if the file is new to the target
directory.

Because of this, it's worth committing and pushing everything *before* a big
cleanup: that commit becomes the snapshot you can always come back to.

## Commands

```bash
stow */              # deploy all packages
stow name            # deploy one
stow -D name         # remove symlinks (files stay in the repo)
stow -R name         # restow — re-link after adding files
stow -n -v name      # dry run, show what would happen
stow --adopt name    # pull existing ~ files into the repo
stow -d ~/dotfiles -t ~ name   # explicit source and target

git rm path/to/file            # delete from disk and stage the removal
git log --oneline -- path      # find the commit that deleted something
git show <commit>:path         # view an old version
git checkout <commit> -- path  # restore it
```

## Publishing to GitHub

```bash
cd ~/dotfiles
git init -b main
git add -A
git commit -m "Initial dotfiles"

git remote add origin <repo-url>
git push -u origin main
```

`-u` sets the upstream so later syncs are just `git push` / `git pull`.

## Related repos

Not everything belongs in a Stow package. Some configs are self-contained enough to be
their own repo, cloned straight into place rather than symlinked:

| Repo | Lives at | What it is |
|------|----------|------------|
| `lj.workspaces` (private) | `~/.config/omarchy/plugins/lj.workspaces` | Omarchy shell bar widget showing per-monitor workspace indicators. A git repo in place — commit and push from that directory, no stow involved. |
| `lj.lock` (private) | `~/.config/omarchy/plugins/lj.lock` | Omarchy session lock screen, cloned from `omarchy.lock`. Keeps the displays powered while locked (DPMS-off crashes Quickshell on this machine's NEC monitors) and suspends after an hour of inactivity at the lock screen. Same arrangement — a git repo in place, no stow. |

The two are linked: the widget filters workspaces by monitor, but the actual per-monitor
pinning comes from the `hl.workspace_rule` entries in `hypr/.config/hypr/workspaces.lua`
**in this repo**. Restoring one without the other gives a widget with nothing to filter.
The bar also has to reference the plugin via `{ "id": "lj.workspaces" }` in
`~/.config/omarchy/shell.json`.

`lj.lock` is linked to this repo the same way: the plugin is inert until `shell.json`
enables it (`plugins`, `disabledPlugins`, `cloneSourceRestores`) and sets
`idle.suspendAfterLock`. That key is read by the clone alone — on the stock lock plugin
it does nothing at all.

The `omarchy` package covers `~/.config/omarchy/shell.json` (bar layout, widget order,
idle/lock timeouts, and which shell plugins are enabled) and `shell.toml` (font size).
Those two files are linked individually — see below — so the rest of
`~/.config/omarchy/`, including both plugin repos, stays local.

### Guarding against broken symlinks

The Omarchy shell writes `shell.json` **atomically** — it writes a temp file and renames it
over the target. A rename replaces a symlink rather than following it, so a settings change,
an `omarchy refresh shell`, or an update migration turns the file back into a real one and
this repo silently stops tracking it.

`omarchy/.config/omarchy/hooks/{post-boot,post-update}.d/relink-omarchy-dotfiles` repairs
that. It copies the live file **into** the repo first (the live file holds the newest
settings), then re-stows, and sends a desktop notification. It never commits, so review with
`git diff` afterwards — and if the change was an accident, `git checkout -- <file>` undoes it.

Those two events are the only relevant ones Omarchy offers — nothing fires when the shell
writes its config — so a systemd user path unit covers the gap and repairs breakage within
seconds, without waiting for a reboot:

```
omarchy/.config/systemd/user/relink-omarchy-dotfiles.path      # watches the two files
omarchy/.config/systemd/user/relink-omarchy-dotfiles.service   # runs the same script
```

It can't loop: once the script re-stows, the watched path is a symlink again and the next
trigger does nothing. Enable it on a new machine with:

```bash
systemctl --user daemon-reload
systemctl --user enable --now relink-omarchy-dotfiles.path
```

To check or repair by hand at any time:

```bash
ls -l ~/.config/omarchy/shell.json     # should show '->' into dotfiles
cd ~/dotfiles && stow -R omarchy       # repair
systemctl --user status relink-omarchy-dotfiles.path
```

## Notes

- Stow refuses to overwrite real files. On a conflict, move the existing file aside or use
  `--adopt`.
- When a target directory doesn't exist, Stow links the whole directory at once. Anything a
  program writes into it lands in the repo, so gitignore generated files and backups.
- Never commit private keys or tokens.
