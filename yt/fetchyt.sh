#!/bin/bash

FILE="$HOME/media/bash.scripts/bleh"

set -o posix;

typeof="$3"
if [[ "$typeof" == "video" ]]; then
   viddir="$PATH/media/yt.channels/";
   cmdstring="youtube-dl";
elif [[ "$typeof" == "artist" ]]; then
   viddir="$PATH/media/music/ro.music/artist/";
   cmdstring="youtube-dl -x";
else
   viddir="$PATH/media/music/ro.music/case/";
   cmdstring="youtube-dl -x";
fi

link=$1;
link="${link/https\:\/\/www\.youtube\.com}";
echo $link;

name=$2;
name="${name/\ \-\ YouTube}";
name="${name//\ /\.}";
name="${name,,[A-Z]}"
echo $name;

echo "$link":"$name":"$typeof" >> "$FILE"
