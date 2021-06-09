#!/bin/bash
set -e
LOGS=./full_env_info.log   #variable to a log file

function basic() {

    echo
    echo "Here is some basic environment information"
    echo
    printenv | grep ^SHELL | tee -a $LOGS
    printenv | grep ^TERM | tee -a $LOGS
    printenv | grep ^USERNAME | tee -a $LOGS
    printenv | grep ^PWD | tee -a $LOGS
    printenv | grep ^PATH | tee -a $LOGS
    printenv | grep ^LANG= | tee -a $LOGS
    printenv >> $LOGS
    echo
    echo "$LOGS file created"

}

function printstat() {
    
    echo "Summary of total disk usage by $(pwd)"
    du -sh $(pwd)
    echo 
    echo "$OPTARG most heavy files in $(pwd)"
    echo
    ls -lSr | tail -$OPTARG
    echo
    echo "All executable files in here"
    find $(pwd) -perm /a=x
    echo
    echo "Stat command"
    stat $(pwd)

}

help="$0 [-b] [-s n]\n -- this script shows information about environment\n
                        and directory statistics.\n
	where:\n
	-h --help  shows this manual.\n

	-b --basic shows basic environment information, writes\n
	     it to fullenvinfo.log file and appends output of printenv command.\n

	-s --stat  shows summary of total disk usage, most heavy files and stat command\n
         n        -argument for tailing output	"

if [ -z "$1" ]; then   #checking for arguments
    echo "No arguments, try [-h] for help"
fi

while getopts ":s:bh" opt; do  #parcing arguments
    case $opt in
        s ) printstat ;;
	b ) basic ;;
        h ) echo -e $help ;;
        \?) echo "Use : cmd [-s] [-b] [-h]";;
    esac
done


