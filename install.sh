#!/bin/bash

# Don't continue on error
set -e

# Existing files won't be replaced
REPLACE_FILES=true

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
  sudo apt-get -o Dpkg::Options::="--force-overwrite" install yarn
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt update && sudo apt install -y yarn
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
# Installing Powerline Fonts
#-----------------------------------------------------
sudo apt-get install fonts-powerline

#-----------------------------------------------------
# Installing PostgreSQL
#-----------------------------------------------------
sudo apt-get install postgresql libpq-dev

#-----------------------------------------------------
# Installing Redis
#-----------------------------------------------------
sudo apt-get install redis-server

#-----------------------------------------------------
# Installing Direnv
#-----------------------------------------------------
sudo apt-get install direnv

#-----------------------------------------------------
# Installing Google Chrome
#-----------------------------------------------------
sudo apt install gdebi-core wget
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo gdebi google-chrome-stable_current_amd64.deb

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
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-doctor | bash
else
  echo "    Installing, rbenv and rubybuild."
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-installer | bash
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
  echo 'eval "$(rbenv init -)"' >> ~/.zshrc
  exec $SHELL
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-doctor | bash
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
echo -n "[ NodeJS x16 ]"

if ! command_exists node; then
  curl -sL https://deb.nodesource.com/setup_16.x | sudo -E bash -
  sudo apt-get install -y nodejs
fi


if command_exists ruby; then
  echo -n "[ Ruby -> Bundler - Solargraph ]"
  gem install bundler
else
  rbenv install 2.7.5
  rbenv global 2.7.5
fi
