#!/bin/bash

# Don't continue on error
set -e

# Existing files won't be replaced
REPLACE_FILES=false

#-----------------------------------------------------
# Functions and variables
#-----------------------------------------------------

current_path=$(pwd)

command_exists() {
  type "$1" &>/dev/null
}

install_oh_my_zsh() {
  curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
  echo "    Change your default shell to zsh"
  sudo chsh
}

#-----------------------------------------------------
# Basic requirements check
#-----------------------------------------------------

if ! command_exists apt-get; then
  echo "This istaller is only comaptible with debian/ubuntu based Linux distributrions."
  echo "Please install configuration files manually."
  exit
fi

if ! command_exists curl; then
  sudo apt-get install -y curl
fi

if ! command_exists yarn; then
  sudo apt-get install -y yarn
fi

#-----------------------------------------------------
# ZSH installation
#-----------------------------------------------------
echo -n "[ zshrc ]"

if [ ! -f ~/.zshrc ]; then
  echo "    Creating zshrc!"
  ln -sf $current_path/shell/zshrc ~/.zshrc
elif $REPLACE_FILES; then
  echo "    Deleting old zshrc!"
  rm ~/.zshrc
  ln -sf $current_path/shell/zshrc ~/.zshrc
else
  echo "    Keeping existing zshrc!"
fi

echo -n "[ oh-my-zsh ]"

if command_exists zsh; then
  if [ ! -d ~/.oh-my-zsh ]; then
    echo "    Installing Oh my zsh"
    install_oh_my_zsh
  fi
else
  echo "    Installing ZSH."
  sudo apt-get install zsh -y
  install_oh_my_zsh
fi

#-----------------------------------------------------
# Git (config, ignore)
#-----------------------------------------------------
echo -n "[ gitconfig ]"

if [ ! -f ~/.gitconfig ]; then
  echo "    Creating gitconfig!"
  ln -sf $current_path/git/gitconfig ~/.gitconfig
elif $REPLACE_FILES; then
  echo "    Deleting old gitconfig!"
  rm ~/.gitconfig
  ln -sf $current_path/git/gitconfig ~/.gitconfig
else
  echo "    Keeping existing gitconfig!"
fi

echo -n "[ gitignore ]"

if [ ! -f ~/.gitignore ]; then
  echo "    Creating gitignore!"
  ln -sf $current_path/git/gitignore ~/.gitignore
elif $REPLACE_FILES; then
  echo "    Deleting old gitignore!"
  rm ~/.gitignore
  ln -sf $current_path/git/gitignore ~/.gitignore
else
  echo "    Keeping existing gitignore!"
fi

#-----------------------------------------------------
# Installing PostgreSQL Client
#-----------------------------------------------------

sudo apt-get install postgresql-client-common postgresql-client libpq-dev

#-----------------------------------------------------
# Installing Ruby utilities
#-----------------------------------------------------
echo -n "[ Ruby - rbenv ]"

sudo apt-get install -y git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev

if command_exists rbenv; then
  if [ ! -f ~/.gemrc ]; then
    echo "   Creating gemrc, irbrc, rdebugrc!"
    ln -sf $current_path/ruby/gemrc ~/.gemrc
  else
    echo "   Keeping existing gemrc, irbrc, rdebugrc!"
  fi
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash
else
  echo "    Installing, rbenv and rubybuild."
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
  echo 'eval "$(rbenv init -)"' >> ~/.zshrc
  exec $SHELL
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash
  echo "    Restart your shell and install ruby by rbenv install ruby-version"
  echo "    Then run this script again."
  echo "Set ZSH your default SHELL"
  echo "vim ~/.bashrc and put these lines before first case condition"
  echo "######################"
  echo "# if test -t 1; then #"
  echo "#   exec zsh         #" 
  echo "# fi                 #"
  echo "######################"
  return
fi

#-----------------------------------------------------
# Installing Ruby utilities
#-----------------------------------------------------
echo -n "[ NodeJS x10 ]"

if ! command_exists node; then
  curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
  sudo apt-get install -y nodejs
fi


if command_exists ruby; then
  echo -n "[ Ruby -> Bundler - Solargraph ]"
  gem install bundler
  gem install solargraph
else
  rbenv install 2.6.6
  rbenv global 2.6.6
fi
