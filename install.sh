#!/bin/bash

set -e;

function exec {
	echo "exec: $1";
	eval $1;
}

DIR="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)";

echo "Installing files from $DIR/ to $HOME/";
cd $DIR;

for file in `cat $DIR/install_files`; do
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
