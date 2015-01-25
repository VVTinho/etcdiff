#!/bin/bash

#: Title        : etcdiff
#: Date         : 2015-01-22
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

# Create a variabel path_ba, and add a path to directorie /backups
path_ba="/usr/local/etc/backups"

path_error="${path_ba}/error.${current_time}.log"

# Redirect both stdout and stderr to file error.${current_time}.log
(
    echo "${current_time} : Starting work"

    # ... more commands ...

    echo "${current_time} : Done"
) >& $path_error

# Check if there is a directorie backups in directorie etc
if [ ! -d $path_ba ]
then
	# Go to directorie /usr/local/etc
        cd $path_etc

	# Create directorie backups
	# -p switch = if you have directorie backups, dont create a new one
	mkdir -p backups
fi

# Check if there is a file in /usr/local/etc/backups called etc-$current_time.B.md5
if [ ! -f $path_ba/etc-$current_time.B.md5 ]
then
	# Go to directorie /usr/local/etc/backups
        cd $path_ba

	# Use find command and make your 1st backup file
	find /etc -type f -exec md5sum {} \; > etc-$current_time.B.md5
fi

# Check if there is a argument to ./etcdiff
# Install manpage-etcdiff
# Display a message that you have made your first backup file
# if [ -z "$1" ]
if [ $# -lt 1 ]
then
	echo ""

	echo "-------------------------------------------"

	echo "No argument/command supplied"

	cd $path_ba

	# Install manpage-etcdiff
	printf " .\ Manpage for etcdiff script.\n .\ Contact vladimir.trigueiros@gmail.com in to correct errors or typos.\n .TH man 8 24 Jan 2015 1.0 etcdiff man page\n .SH NAME etcdiff \- create a new LDAP user\n .SH SYNOPSIS etcdiff [USERNAME]\n .SH DESCRIPTION etcdiff is high level shell program for adding users to LDAP server. On Debian$\n .SH OPTIONS The etcdiff does not take any options. However, you can supply username.\n .SH SEE ALSO useradd(8), passwd(5), nuseradd.debian(8)\n .SH BUGS No known bugs.\n .SH AUTHOR Vladimir Trigueiros (vladimir.trigueiros@gmail.com)\n" > etcdiff-manual

	# manpage-etcdiff is installed (man page for etcdiff)
	echo "You have installed man page manual for etcdiff"

	# Help text!
	echo "See/Run ./etcdiff.sh manpage-etcdiff"

	# Created the first backup file
        echo "You have created a file with a list of files from directorie /etc"

        # Help text!
        echo "Your backup file is: etc-<date>+<time>.B.md5, path = /usr/local/etc/backups"

	echo "-------------------------------------------"

	echo ""
fi

if [ "$1" == "v" ]
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
if [ "$1" == "l" ]
then
	cd /usr/local/etc/

	echo ""

	echo "-------------------------------------------"

	find /usr/local/etc/backups -type f | cut -c28-46

	# -q om filerna har ändrats

	echo "-------------------------------------------"

	echo ""

	exit 0
fi

# Check if the first input argument $1 is c
if [ "$1" == "c" ]
then
	echo ""

        echo "-------------------------------------------"

	cd /usr/local/etc/backups/

	# find /etc -type f -exec md5sum {} \; >> etc-$current_time.C.md5

	find /etc -type f >> etc-$current_time.C.md5

	# find /etc -type f ! -name '*.swp*' | xargs stat --format '%y %n' | cut -d' ' -f1-2 | sed 's/-//' | sed 's/-//' | sed 's/ //' | sed 's/://' | sed 's/://' >> etc-$current_time.C.md5

	echo "Select and compare and old backup file, declaring timestamp ex ( 2015.01.23-22:02:15 )"

	echo "Run command etcdiff l to list the timestamps in your backups directorie"

	read timestamp

	diff etc-$timestamp.B.md5 etc-$current_time.C.md5

	echo "-------------------------------------------"

	echo ""

	exit 0
fi

# Check if the first input argument $1 is h
if [ "$1" == "h" ]
then
	echo ""

	echo "-------------------------------------------"

        echo "HELP TEXT!"
	echo "See man page for etcdiff ( ./etcdiff.sh manpage-etcdiff )"

	echo "switch c = copy timestamp a compare changes"
	echo "switch l = list all files in backups directorie"
	echo "switch r and switch ALL = delete alla files in backups directorie"
	echo "switch h = help text"
	echo "switch v = display the script version"
	echo "switch libnotify = Instal libnotify"
	echo "switch manpage-etcdiff = display etcdiff man page manual"

	echo "-------------------------------------------"

        echo ""

	exit 0
fi

# Check if the first input argument $1 is r
# Check if the second input argument $2 is ALL
if [ "$1" == "r" ] && [ "$2" == "ALL" ]
then
	# Delete directorie backups
	rm -rf $path_ba

        echo "You have deleted all timestamps"

	exit 0
fi

# Check if the first input argument $1 is etcdiff
# Check if the second input argument $2 is timestamp 1
if [ "$1" == "etc" ]  && [ "$2" == "etc-$current_time.B.md5" ]
then
	# find /etc -type f ! -name '*.swp*' | xargs stat --format '%y %n' | cut -d' ' -f1-2 | sed 's/-//' | sed 's/-//' | sed 's/ //' | sed 's/://' | sed 's/://' >>
	echo "Compare two timestamp files"

	exit 0
fi

# Check if the first input argument $1 is manpage-etcdiff
# Display etcdiff man manual page if argument $1 is manpage-etcdiff
if [ "$1" == "manpage-etcdiff" ]
then
	cd /usr/local/etc/backups
	man ./etcdiff-manual

	exit 0
fi

# Check if the first input argument $1 is libnotify
# Install libnotify-bin with command libnotify
if [ "$1" == "libnotify" ]
then
        echo "Begin installation of libnotify-bin"

        sleep 1

        sudo apt-get install libnotify-bin

        exit 0
fi

# Check if the first input argument $1 is etcd
# Create a backup md5sum file and check if there is any changes in the files in /etc
if [ "$1" == "etcdiff" ]
then
	echo "Gor en backup av katalog /etc"
	echo "Jamfor filerna i din nyskapade backup med din gammla backup"

	# Go to directorie /usr/local/etc
	cd /usr/local/etc

	# Create a directorie backups
	mkdir -p backups

	# Go to directorie /usr/local/etc/backups
	cd /usr/local/etc/backups

	# Use command find to find files in directorie /etc
	# Use -type f to find files
	# Use -exec md5sum and set md5 on the files
	# Create and append output in file etc-$current_time.A.md5
	find /etc -type f -exec md5sum {} \; >> etc-$current_time.A.md5

	# find /etc -type f -exec md5sum {} \; >> etc-$current_time.B.md5
	# grep -v ' \.$|---|[0-9][ac][0-9]

	if diff etc-$current_time.A.md5 etc-$current_time.B.md5 > /dev/null 2>&1
	then
		echo "Files are same."
		result=$(diff etc-$current_time.A.md5 etc-$current_time.B.md5)
                printf "${result}\n"
	else
		echo "Files are different."
		result=$(diff etc-$current_time.A.md5 etc-$current_time.B.md5)
		printf "${result}\n"
	fi
fi
