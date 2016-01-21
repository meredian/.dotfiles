#!/bin/bash

set -e;

function exec {
	echo "exec: $1";
	eval $1;
}

DIR="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)";
IGNORE_FILES=(.git .gitmodules .gitignore README.md install.sh)

echo "Installing files from $DIR/ to $HOME/";
cd $DIR;

for file in `ls -A -I $DIR`; do
	for item in "${IGNORE_FILES[@]}"; do
		if [[ "$file" == "$item" ]]; then
			echo "Skipping $file";
			continue 2;
		fi
	done

	src="$DIR/$file";
	trg="$HOME/$file";
	if [ -e $trg ]; then
		if [[ ! -L $trg ]] || ([[ -L $trg ]] && [[ "$src" != $(readlink $trg) ]]); then
			echo "File already exists: $trg";
		else
			echo "File installed: $trg";
		fi
	else
		exec "ln -s $src $trg";
	fi
done
