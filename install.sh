#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles

force=false
no_overwrite=false

usage () {
  cat << EOF
Usage: $0 [-fny]
where:
  -f force linking
  -n no to all, do not overwrite existing files
  -y yes to all (same as -f)
EOF
}

success () {
  echo -e "\r\033[2K  [ \033[00;32mOK\033[0m ] $1"
}

fail () {
  echo -e "\033[2K  [\033[0;31mFAIL\033[0m] $1"
}

link_file () {
  if [ -d $2 ]; then
    rm -rf $2
  fi
  ln -snf $1 $2
  success "$( basename $1 ".symlink" ) linked to $2"
}

skip_file () {
  fail "$( basename $1 ".symlink" ) not linked"
}

link_dotfiles () {
  linkables=$( find -H $DOTFILES -maxdepth 2 -name '*.symlink' )
  for file in $linkables; do
    file_name=$( basename $file ".symlink" )
    dest="$HOME/.$file_name"

    if [ -e $dest ] && [ "$force" == "false" ]; then
      if [ "$no_overwrite" == "true" ]; then
        skip_file $file
        continue
      fi

      read -n 1 -p "$file_name already exists, do you want to overwrite it? [y]es, [n]o, [Y]es to all, [N] to all: " action
      echo ""

      case "$action" in
        y )
          link_file $file $dest;;
        Y )
          force=true
          link_file $file $dest;;
        n )
          skip_file $file;;
        N )
          no_overwrite=true
          skip_file $file;;
        * )
          ;;
      esac
    else
      link_file $file $dest
    fi
  done
}

while getopts ":fyn" opt; do
  case $opt in
    f|y )
      force=true;;
    n )
      no_overwrite=true;;
    * )
      usage
      exit 0;;
  esac
done

echo "Initializing submodules"
git submodule update --init
echo "Installing dotfiles"
link_dotfiles
echo "Installing vim plugins"
vim -u ~/.vim/plugins.vim +PlugInstall +qa
