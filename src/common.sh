#!/bin/bash
log() {
	echo "[$(date +"%Y-%m-%d %H:%M:%S") "`hostname`"] $(basename ${BASH_SOURCE[0]}|sed 's/\.sh//g'), INFO: $1"
}

error() {
	echo "[$(date +"%Y-%m-%d %H:%M:%S") "`hostname`"] $(basename ${BASH_SOURCE[0]}|sed 's/\.sh//g'), ERROR: $1"
}

join_by() { local IFS="$1"; shift; echo "$*"; }

exec() {
	cmd=$1
	set -x
	eval "$cmd"
					    
	if [ $? -ne 0  ]; then
		error "Job failed"
		exit 100 
	fi  
}
