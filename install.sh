#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles

force=false
no_overwrite=false

link_file () {
  ln -sf $1 $2
  echo "$1 linked to $2"
}

skip_file () {
  echo "$1 not linked"
}

echo "installing dotfiles"
linkables=$( find -H $DOTFILES -maxdepth 2 -name '*.symlink' )
for file in $linkables; do
  dest="$HOME/.$( basename $file ".symlink" )"

  if [ -e $dest ] && [ "$force" == "false" ]; then
    if [ "$no_overwrite" == "true" ]; then
      skip_file $file
      continue
    fi

    echo "$dest already exists, do you want to overwrite it? [y]es, [n]o, [Y]es to all, [N] to all"
    read -n 1 action

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
