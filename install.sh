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
  # ln -sf $current_path/shell/zshrc ~/.zshrc
elif $REPLACE_FILES; then
  echo "    Deleting old zshrc!"
  # rm ~/.zshrc
  # ln -sf $current_path/shell/zshrc ~/.zshrc
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
# Installing Ruby utilities
#-----------------------------------------------------
echo -n "[ Ruby - rbenv ]"

if command_exists rbenv; then
  if [ ! -f ~/.gemrc ]; then
    echo "   Creating gemrc, irbrc, rdebugrc!"
    ln -sf $current_path/ruby/gemrc ~/.gemrc
  else
    echo "   Keeping existing gemrc, irbrc, rdebugrc!"
  fi
else
  echo "    Installing, rbenv and rubybuild."
  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  echo "    Restart your shell and install ruby by rbenv install ruby-version"
  echo "    Then run this script again."
  exit
fi

echo -n "[ Ruby -> Bundler - Solargraph ]"
gem install bundler
gem install solargraph
