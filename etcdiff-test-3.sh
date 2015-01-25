#!/bin/bash

#: Title        : etcdiff
#: Date         : 2015-01-26
#: Author       : "Vladimir" <vladimir.trigueiros@gmail.com>
#: Version      : 1.0
#: Description  : Compare file changes in directore /etc
#  See project: https://github.com/VVTinho/etcdiff
#: Options      : Inget


# Check if current user is root
if [[ $EUID -ne 0 ]]
then
   echo "This script must be run as root"

   exit 0
fi

# Create variabel current_time, and add a date timestamp
current_time=$(date "+%Y.%m.%d-%T")

# Create a variabel path_etc, and add a path to directorie /etc
path_etc="/usr/local/etc"

mkdir -p ${path_etc}/backups

# Create a variabel path_ba, and add a path to directorie /backups
# path_ba="/usr/local/etc/backups"
path_ba="${path_etc}/backups"

# txt='find ${path_ba} -type f -name "*.md5"'

# Create a variabel path_error, and add a path to a log file
# path_error="${path_ba}/error.${current_time}.log"

# find $path_ba -type d -print0 | xargs -0 chmod 755
# find $path_ba -type f -print0 | xargs -0 chmod 644

# Check if there is a directorie backups in directorie etc
#if [ ! -d $path_ba ]
#then
#	# Go to directorie /usr/local/etc
#        cd $path_etc
#
#	# Create directorie backups
#	# -p switch = if you have directorie backups, dont create a new one
#	mkdir -p backups
#fi

# Om filen finns som den gör skicka man manualen till /usr/local/man/
#if [ -f $path_ba/etcdiff-manual ]
#then
#        # Go to directorie /usr/local/etc/backups
#        cd $path_ba
#
#	cat etcdiff-manual | gzip > /usr/local/man/etcdiff-manual.1
#fi

# Redirect both stdout and stderr to file error.${current_time}.log
#(
#	echo "${current_time} : Starting work"
#
#		# ... more commands ...
#		# TEsting testing
#
#		current_time=$(date "+%Y.%m.%d-%T")
#
#	echo "${current_time} : Done"
#) >& $path_error

# Check if there is a file in /usr/local/etc/backups called etc-$current_time.B.md5
#if [ ! -f $path_ba/etc-$current_time.B.md5 ]
#then
#	# Go to directorie /usr/local/etc/backups
#        cd $path_ba
#
#	# Use find command and make your 1st backup file
#	find /etc -type f -exec md5sum {} \; > etc-$current_time.B.md5
#fi

matches_exist () {
	[ $# -gt 1 ] || [ -e "$1" ]
}

# [ $# -lt 1 ] 
# Check if there is a argument to ./etcdiff and if there is files that ends with .md5
# if [ -z "$1" ] matches_exist /usr/local/etc/backups/*.md5
if matches_exist /usr/local/etc/backups/*.md5 && [ $# -lt 1 ]
then
	# [[ ( -n ${txt} ) ]]

	echo ""

	echo "-------------------------------------------"

	echo "Compare the two latest timestamps if at least two timestamps have been created earlier (with the -c switch)."

	# latest timestamp
        stat -c%y $path_ba

	# näst nyaste timestamp
	stat -c%x $path_ba

	# find /usr/local/etc/backups -maxdepth 1 -name /usr/local/etc/backups -printf %Tc

	# find /usr/local/etc/backups -print0 | grep -FzZ `/usr/local/etc/backups`

	# find . -type f -print0 | xargs -0 stat -f "%m %N" | sort -rn | head -1 | cut -f2- -d" "

	# Install manpage-etcdiff
	# printf " .\ Manpage for etcdiff script.\n .\ Contact vladimir.trigueiros@gmail.com in to correct errors or typos.\n .TH man 8 24 Jan 2015 1.0 etcdiff man page\n .SH NAME etcdiff \- create a new LDAP user\n .SH SYNOPSIS etcdiff [USERNAME]\n .SH DESCRIPTION etcdiff is high level shell program for adding users to LDAP server. On Debian$\n .SH OPTIONS The etcdiff does not take any options. However, you can supply username.\n .SH SEE ALSO useradd(8), passwd(5), nuseradd.debian(8)\n .SH BUGS No known bugs.\n .SH AUTHOR Vladimir Trigueiros (vladimir.trigueiros@gmail.com)\n" > etcdiff-manual

	echo "-------------------------------------------"

	echo ""
else
	echo ""

        echo "-------------------------------------------"

	echo "No timestamps exist (use -c to create)."

	echo "-------------------------------------------"

        echo ""
fi

if [ "$1" == "-v" ]
then
	echo ""

	echo "-------------------------------------------"

	echo "Script version"
	echo "Version 1.0 (release mode)" | sed -ne 's/[^0-9]*\(\([0-9]\.\)\{0,4\}[0-9][^.]\).*/\1/p'

	echo "-------------------------------------------"

	echo ""

	exit 0
fi

# Check if the first input argument $1 is l
if [ "$1" == "-l" ]
then
	echo ""

        echo "-------------------------------------------"

	# cd $path_etc

	find $path_ba -type f | cut -c24-54 | grep -v 'error' | grep -v 'etcdiff-manual'

	# -q om filerna har ändrats

	echo "-------------------------------------------"

	echo ""

	exit 0
fi

# Check if the first input argument $1 is c
if [ "$1" == "-c" ]
then
	echo ""

        echo "-------------------------------------------"

	echo "You have created a backup file"

	find /etc -type f >> ${path_ba}/etc-$current_time.A.md5

	# find /etc -type f ! -name '*.swp*' | xargs stat --format '%y %n' | cut -d' ' -f1-2 | sed 's/-//' | sed 's/-//' | sed 's/ //' | sed 's/://' | sed 's/://' >> etc-$current_time.C.md5

	echo "-------------------------------------------"

	echo ""

	exit 0
fi

# Check if the first input argument $1 is h
if [ "$1" == "-h" ]
then
	echo ""

	echo "-------------------------------------------"

        echo "HELP TEXT!"

	echo "Compares files in /etc from various times."
	echo "-c = create timestamp."
	echo "-l = list all existing timestamps."
	echo "-r timestamp | ALL = delete specified or all timestamps."
	echo "-h = show this help text"
	echo "-v = display version"

	echo "Without options, show differences between last two timestamps."
	echo "With two timestamps as arguments, compare differences between corresponding times."
	echo "See man page for etcdiff (man etcdiff.sh) for details."

	echo "-------------------------------------------"

        echo ""

	exit 0
fi

# Check if the first input argument $1 is r
# Check if the second input argument $2 is ALL
if [ "$1" == "-r" ] && [ "$2" == "ALL" ]
then
	echo ""

        echo "-------------------------------------------"

	# Delete directorie backups
	rm -rf $path_ba

        echo "You have deleted all timestamps"

	echo "-------------------------------------------"

        echo ""

	exit 0
fi

# Check if the first input argument $1 is manpage-etcdiff
# Display etcdiff man manual page if argument $1 is manpage-etcdiff
#if [ "$1" == "man" ] && [ "$2" == "etcdiff" ]
#then
#	cd $path_ba
#
#	man ./etcdiff-manual
#
#	exit 0
#fi

# Check if the first input argument $1 is libnotify
# Install libnotify-bin with command libnotify
#if [ "$1" == "libnotify" ]
#then
#        echo "Begin installation of libnotify-bin"
#
#        sleep 1
#
#        sudo apt-get install libnotify-bin
#
#        exit 0
#fi

# Check if the first input argument $1 is etcd
# Create a backup md5sum file and check if there is any changes in the files in /etc
#if [ "$1" == "etcdiff" ]
#then
#	echo "Gör en aktuell backup av katalog /etc"
#	echo "Jamfor filerna i din nyskapade backup med din gammla backup"
#
#	# Go to directorie /usr/local/etc/backups
#	cd $path_ba
#
#	# Use command find to find files in directorie /etc
#	# Use -type f to find files
#	# Use -exec md5sum and set md5 on the files
#	# Create and append output in file etc-$current_time.A.md5
#	find /etc -type f -exec md5sum {} \; > etc-$current_time.A.md5
#
#	# find /etc -type f -exec md5sum {} \; >> etc-$current_time.B.md5
#	# grep -v ' \.$|---|[0-9][ac][0-9]
#
#	if diff etc-$current_time.A.md5 etc-$current_time.B.md5 > /dev/null 2>&1
#	then
#		echo "Files are same."
#
#		result=$(diff etc-$current_time.A.md5 etc-$current_time.B.md5)
#                printf "${result}\n"
#	else
#		echo "Files are different."
#
#		result=$(diff etc-$current_time.A.md5 etc-$current_time.B.md5)
#		printf "${result}\n"
#	fi
#fi
