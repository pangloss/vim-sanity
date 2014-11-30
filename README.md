vim-sanity
==========

This has been my choice rig for vim setup for years. Clone this repo and up pull updates every few eons.


Install Steps
=============
Ensure you don't have a ~/.vim directory (or rename it if you do) and perform the following steps:


```
cd 
git clone git@github.com:pangloss/vim-sanity.git .vim
cd .vim
git submodule init
git submodule update
cd
ln -s .vim/.gvimrc .gvimrc
ln -s .vim/.vimrc .vimrc
```
