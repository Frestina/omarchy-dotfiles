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

## Commands

```bash
stow */              # deploy all packages
stow name            # deploy one
stow -D name         # remove symlinks (files stay in the repo)
stow -R name         # restow — re-link after adding files
stow -n -v name      # dry run, show what would happen
stow --adopt name    # pull existing ~ files into the repo
stow -d ~/dotfiles -t ~ name   # explicit source and target
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

## Notes

- Stow refuses to overwrite real files. On a conflict, move the existing file aside or use
  `--adopt`.
- When a target directory doesn't exist, Stow links the whole directory at once. Anything a
  program writes into it lands in the repo, so gitignore generated files and backups.
- Never commit private keys or tokens.
