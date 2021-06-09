#!/bin/bash
#
# Shows info about RAM, environment, disk usage and directory statistic.

set -e
LOGS=./full_env_info.log   #variable to a log file

timestamp() {
  date +"%T"
}

###########################################
# Shows RAM , basic environment variables
# and writes it into a log file in your current working directory.
# Arguments:
#   None
###########################################

function basic() {

  timestamp
  echo -e "\nInformation about RAM"
  echo -e "\nINFORMATION ABOUT RAM\n" > $LOGS
  free -h  | tee -a $LOGS
  cat /proc/meminfo >> $LOGS
  echo -e "\nHere is some basic environment information"
  printenv | grep ^SHELL | tee -a $LOGS
  printenv | grep ^TERM | tee -a $LOGS
  printenv | grep ^USERNAME | tee -a $LOGS
  printenv | grep ^PWD | tee -a $LOGS
  printenv | grep ^PATH | tee -a $LOGS
  printenv | grep ^LANG= | tee -a $LOGS
  echo -e "\nENVIRONMENT VARIABLES INFORMATION\n" >> $LOGS
  printenv >> $LOGS
  echo -e "\n$LOGS file created"

}

###########################################
# Shows total disk usage, most heavy files in current directory,
# all executables and stat.
# Arguments:
#   Number for tail output
###########################################

function printstat() {
  
  timestamp	
  echo -e "\nSummary of total disk usage by $(pwd)"
  du -sh $(pwd)
  echo -e "\n$OPTARG most heavy files in $(pwd)"
  ls -lSr | tail -$OPTARG
  echo -e "\nAll executable files in here"
  find $(pwd) -perm /a=x
  echo -e "\nStat command"
  stat $(pwd)

}

help="$0 [-b] [-s n] -- this script shows information about environment and
\ndirectory statistics.	Where: -h --help  shows this manual.
\n-b --basic shows basic environment information, writes it to fullenvinfo.log
\nfile and appends output of printenv command.
\n-s --stat  shows summary of total disk usage, most heavy files 
\nand stat command. [n] -argument for tailing output"

if [ -z "$1" ]; then   #checking for empty argument list
  echo "No arguments, try [-h] for help"
fi

while getopts "s:bh" opt; do  #parcing arguments
  case $opt in
    s ) printstat $OPTARG ;;
    b ) basic ;;
    h ) echo -e $help ;;
    \?) echo "Use : cmd [-s n] [-b] [-h]";;
  esac
done


