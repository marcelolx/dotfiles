# Steps to install NeoVim and Plugins on Windows

* Download latest release https://github.com/neovim/neovim/releases/
* Unzip the package to any location. (My default is D:/Neovim)
* Add `bin` folder to your PATH.
* Install Python and then run `pip install pynvim`
* Open NeoVim and run :PlugInstall
* Install CTags
* Install FZF
* Go to your project and run `nvim-qt`.

### Ruby on Rails

For ctags generation see `2.11 Ctags settings` in `init.vim`.