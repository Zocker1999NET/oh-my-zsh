# dot-config zsh plugin

dot-config is a plugin for oh-my-zsh
helping you to store your dot-files inside a git repository.

## How it works

- In the directory `~/.cfg` the repository with your dot-files will be handled
- With the command `config` you can control this repository
- Except some special commands, `config` is an alias for a `git` command

## Usage

### Initialize repository

Run `config init`, the work tree directory will be created and configured.
With `config add FILE` you can add configuration files to the repository.
With git commands like `remote`/`pull`/`push` you can work with a remote repository.
