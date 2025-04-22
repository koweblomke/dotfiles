# dotfiles


# Nix

I use nix and nix-darwin as package manager for my MacBook. See this [Nix for MacOs Youtube video](https://www.youtube.com/watch?v=Z8BL8mdzWHI&t=282s) for more explaination.

Nix also has a module for brew to install packages via brew. 

clone dotfiles into .config
```copy
git clone https://github.com/koweblomke/dotfiles.git .config 
```

## Step 1. Install nix

> [!IMPORTANT]
> make sure nix or any form of NixOs or nix-shell isn't installed. Then [uninstall](https://nix.dev/manual/nix/2.18/installation/uninstall#macos) it 

```
sh <(curl -L https://nixos.org/nix/install)
```

### Create new flake.nix 

> [!NOTE]
> skip this!, this is only for fresh install if you do not have a flake.nix file yet.

```
cd .config
nix flake init -t nix-darwin --extra-experimental-features "nix-command flakes"
```

then configure the darwinConfigurations name and the architecture. (see [video](https://www.youtube.com/watch?v=Z8BL8mdzWHI&t=282s))

## Step 2. Install nix-darwin

```
nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/.config/nix#macwerk
```

## Step 3. Using nix-darwin

```
darwin-rebuild switch --flake ~/.config/nix#macwerk
```

### .zshrc, oh-my-zsh and powerlevel10

To manage [oh-my-zsh](https://ohmyz.sh/) and [powerlevel10k](https://github.com/romkatv/powerlevel10k) with nix we need to use nix-homemanger as nix-darwin has no options to manager oh-my-zsh. For this we use the nix-darwin home-manager module in the [flake.nix](./nix/flake.nix) file.

> [!IMPORTANT]
> nix now also manages the .zshrc file. So don't edit it manually.

> [!NOTE]
> if you don't have a [p10k.zsh](./nix/p10k/p10k.zsh) file yet you need to create one by [manually installing powerlevel10k](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#manual) before managing zsh with nix home-manager. Save the p10k.zsh file in .config/nix/p10k folder and then you can remove powerlevel10k and re-install it with nix. 

### Nix Links:

- [MyNixOs](https://mynixos.com/)
- [Nix flakes](https://mynixos.com/flakes)
- [nix-darwin options](https://mynixos.com/nix-darwin/options)
- [nix-homemanager options](https://mynixos.com/home-manager/options)


# vim

TO-DO: descibe and update vim settings using vundle

```
#!/bin/bash

### install Vundle
#
#  https://github.com/VundleVim/Vundle.vim
#

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
```