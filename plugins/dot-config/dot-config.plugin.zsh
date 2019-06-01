#!/bin/zsh

# Check if git installed
if ! (( $+commands[git] )); then
    print "zsh dotfiles-git plugin: git not found. Please install git before using this plugin." >&2
    return 1
fi

# Configuration

# Location of git bare repository
: ${DOTFILES_CONFIG_DIRECTORY="$HOME/.cfg"};

# Configure helper alias

config-git() {
  git --git-dir="$DOTFILES_CONFIG_DIRECTORY/" --work-tree="$HOME" "$@";
}

# Configure alias command

_zsh_dot-config_configuration() {
  config-git config --local status.showUntrackedFiles no;
}

config() {
  if [[ "$1" == "init" ]]; then
    if [[ -d "$DOTFILES_CONFIG_DIRECTORY" ]]; then
      echo "Configuration directory $DOTFILES_CONFIG_DIRECTORY already initialized";
      echo "Destroy repository with \"config destroy\"";
      return 1;
    else
      git init --quiet --bare "$DOTFILES_CONFIG_DIRECTORY";
      _zsh_dot-config_configuration;
    fi
  elif [[ "$1" == "clone" ]]; then
    if [[ -d "$DOTFILES_CONFIG_DIRECTORY" ]]; then
      echo "Configuration directory $DOTFILES_CONFIG_DIRECTORY already initialized";
      echo "Destroy repository with \"config destroy\"";
      return 1;
    else
      config-git clone --quiet --bare "$DOTFILES_CONFIG_DIRECTORY";
      _zsh_dot-config_configuration;
      if ! config-git checkout; then
        echo "Backing up pre-existing dot files";
        mkdir -p .config-backup;
        config-git checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{};
        config-git checkout;
      fi
    fi
  elif [[ "$1" == "destroy" ]]; then
    if [[ -d "$DOTFILES_CONFIG_DIRECTORY" ]]; then
      rm -r "$DOTFILES_CONFIG_DIRECTORY";
    else
      echo "Configuration directory $DOTFILES_CONFIG_DIRECTORY not initialized yet";
      echo "Intialize repository with \"config init\"";
      return 1;
    fi
  elif [[ "$1" == "help" ]]; then
    echo "You can use following commands:";
    echo "\thelp: Shows this message";
    echo "\tinit: Initializes the dot-config git repository";
    echo "\tclone: Clones the dot-config git repository, applies remote config while backuping current different config files";
    echo "\tdestroy: Removes the dot-config git repository";
    echo "See more commands from git: \"git help\"";
  else
    if [[ -d "$DOTFILES_CONFIG_DIRECTORY" ]]; then
      config-git "$@"
    else
      echo "Configuration directory $DOTFILES_CONFIG_DIRECTORY not initialized yet";
      echo "Intialize repository with \"config init\"";
      return 1;
    fi
  fi
}
