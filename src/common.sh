#!/bin/bash
log() {
	out=$(echo $scriptFile|sed 's/\.sh/\.log/g')
	if [ -z $out ]; then
		echo "[$(date +"%Y-%m-%d %H:%M:%S") "`hostname`"] $(basename ${BASH_SOURCE[0]}|sed 's/\.sh//g'), INFO: $1"
	else
		echo "[$(date +"%Y-%m-%d %H:%M:%S") "`hostname`"] $(basename $scriptFile), INFO: $1" >> $out
	fi
}

error() {
	out=$(echo $scriptFile|sed 's/\.sh/\.log/g')
	if [ -z $out ]; then
		echo "[$(date +"%Y-%m-%d %H:%M:%S") "`hostname`"] $(basename ${BASH_SOURCE[0]}|sed 's/\.sh//g'), ERROR: $1"
	else
		echo "[$(date +"%Y-%m-%d %H:%M:%S") "`hostname`"] $(basename $scriptFile), ERROR: $1" >> $out
	fi
}

join_by() { local IFS="$1"; shift; echo "$*"; }

exec() {
	cmd=$1
	#set -x
	eval "$cmd"
					    
	if [ $? -ne 0  ]; then
		error "Job failed"
		exit 100 
	fi  
}
