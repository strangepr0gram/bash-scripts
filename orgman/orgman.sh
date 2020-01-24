#!/bin/bash

set -o posix

# synopsis

if [[ $# -eq 0 ]]; then
	echo "synopsis: orgman [-l] [-c] [-cd] [-f\
	ORGFILE [-ss SECTION] | -o DIR] [-del mode [mode] [mode] [...] ] [arg ...]";
	exit 1;
fi

## option processing ##

while getopts "o:O:" Opt; do
	case $Opt in
			o ) echo "o found"; OUTPUT=$OPTARG; shift 2;;
			O ) echo "O found"; FILE=$OPTARG; shift 2;;
	esac
done

## main code

	for man in $@; do
		descr=`whatis $man | head -1 | sed -e "s/\//\\\\\\\\\//g"`;
		man -P cat $man > $man.org;
		sed -i -f "seds/orgize" $man.org;
		sed -ie "1s/.*/\*\ $descr/" $man.org; 
		if [[ OPTDIR != "" ]]; then
			if [[ `mv $man.org $OPTDIR` == 1 ]]; then echo "no dir"; exit 1; fi
		fi
		echo "orgized" $man"." in $OPTDIR$man.org;
	done

# options:
# -o output dir
# -O main org-mode file
