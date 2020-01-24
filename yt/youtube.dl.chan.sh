#!/bin/bash

# OPTIONS:
#	START:
#	--directory DIR: main directory | DEFAULT: $HOME
#		errors:
#			directory not available
#			permissions
#			erroneous directory
# --archive-file-per-channel: specify whether archive file saved in \
#															$CHANNELNAME/archive
# --archive-file FILE: specify archive file DEFAULT: $HOME/ARCHIVE
# --once: run once | DEFAULT
# --daemon: run as daemon # use crond
# --run-at [TIME]: check at TIME # crond
# --preset: use default preset | DEFAULT: YES
# --log-new-videos: log new videos to file | DEFAULT: NO
# --log-file FILE: log file | DEFAULT: $HOME/programlog
# --log [WARNINGS] [ERRORS] [VIDEOS] [RERUNS] [EVERYTHING]: what to log |
#																														DEFAULT: EVERYTHING
#	--save [THUMBNAILS] [DESCRIPTION] 
#				 [INFO] [ANNOTATIONS] [ADS]: 
#				 what to save | DEFAULT: EVERYTHING | use youtube-dl args instead
# --save-format ???
# --directory-options [NOSPACE] [LOWERCASE] | DEFAULT: $HOME/$CHANNELNAME
# --config-file FILE: config file | DEFAULT ~/.programrc
# --arg "ARGS": pass additional args urself to youtube-dl | DEFAULT: ...
######
# ADD:
# --channel-list FILE: FILE to save to | DEFAULT: $HOME/channel.list
# --delimiter "DELIM": add delim for entries between fields | DEFAULT: ":"
# --regex "REGEX": add regex for which videos to check for | DEFAULT: NONE
# --length-min TIME: min length of video | DEFAULT: NONE
# --length-max TIME: max length of video | DEFAULT: NONE
# --title: title of folder if channel title too vague | DEFAULT: NONE
# --set-directories-in-channel-list-file ???
	FORMAT:
		channel.link:"name":"type":"regex":"min":"max":"title":"directory"
# restart :
######
# OPTIONS:
#OPT=VAL;
######
# ERRORS:
#		permission denied
#		not enough space
#		syntax error in options
#		bad format for channel list
#		no channels found according to delim
#		missing fields		
#		link not found
#####
# WARNINGS:
#		space warning
#		huge list warning
#####
# QUTEBROWSER:
#	make special qutebrowser shortcuts+script for adding channels
# generalize everything
#	cache video pages: dig through youtube-dl code

set -o posix

LOG=/var/log/ytdl.log
TMP=/tmp/ytdl.tmp

# function awkize() {	# $1, var, $2 field to print $3, optional delimiter
#		echo "$1" | awk -F"$3" '{print \$2}';
# }

for arg in $(< "channel.list"); do

	typeof=$(echo "$arg" | awk -F":" '{print $3}'); ## there shld be a better way
	typeof=${arg/^\([a-z]|\.\)\:\([a-z]|\.\)				## without awk
	name=$(echo "$arg" | awk -F":" '{print $2}');
	name=${name,,[A-Z]};
	link=$(echo "$arg" | awk -F":" '{print $1}');

	if [[ "$typeof" == "video" ]]; then
		viddir="$HOME/media/yt.channels";
		cmdstring="youtube-dl";
	elif [[ "$typeof" == "artist" ]]; then
		viddir="$HOME/media/music/ro.music/artist";
		cmdstring="youtube-dl -x";
	else
		viddir="$HOME/media/music/ro.music/case";
		cmdstring="youtube-dl -x";
	fi

	if [[ ! (-d "$viddir/$typeof/$name") ]]; then
		mkdir "$viddir/$typeof/$name";
	fi

	# date ...
	declare -i size1=$(du -c -d 0 "$viddir/$typeof/$name" | head -1 | awk \
										 -F" " '{print $1}');

	touch "$TMP";

	"$cmdstring" \ # youtube-dl | youtube-dl -x
						 -q 
						 --write-description \
					   --write-info-json \
						 --write-annotations \
						 --sleep-interval 0.3 \
						 --max-sleep-interval 1 \
						 --no-continue \
						 --no-color \

						 --metadata-from-title "%(artist)s - %(title)s" \
						 --download-archive "$viddir/$name/arch" \
						 -o "$viddir/$name/%(upload_date)s.%(title)s.%(ext)s" \
						 -R "infinite" \
						 -i "https://www.youtube.com$link" > "$TMP"

	if [[ ! (-d "$viddir/$name/info") ]]; then
		mkdir "$viddir/$name/info";
	fi

	mv "$viddir"/"$name"/*.xml -t "$viddir"/"$name"/info/;
	mv "$viddir"/"$name"/*.json -t "$viddir"/"$name"/info/;
	mv "$viddir"/"$name"/*.description -t "$viddir"/"$name"/info/;
	# date ...
	declare -i size2=$(du -c -d 0 "$viddir/$typeof/$name" | head -1 | awk \
										 -F" " '{print $1}');
	if [[ $size2 -gt $size2 ]]; then
		# ...
		
	else
		# ...
	fi

	rm 
	
done

# dateafter DATE 
# remove case
# log also

