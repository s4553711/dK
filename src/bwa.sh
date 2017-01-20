#!/bin/bash
log() {
	echo "[$(date +"%Y-%m-%d %H:%M:%S")] $(basename ${BASH_SOURCE[0]}|sed 's/\.sh//g'), INFO: $1"
}

error() {
	echo "[$(date +"%Y-%m-%d %H:%M:%S")] $(basename ${BASH_SOURCE[0]}|sed 's/\.sh//g'), ERROR: $1"
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

preload() {
	log 'preload'
}

run() {
	source bwa.ini
	log $(basename ${BASH_SOURCE[0]})
	log "cmd: $bwa mem $ref $(join_by " " ${@:2})"
	#exec "${BWA} mem -t 10 -R \"@RG\tID:${SAMPLE}\tSM:${SAMPLE}\tLB:${SAMPLE}\" ${REF} 2> bwa.log"
}

cleanup() {
	log "cleanup"
}

flow () {
	preload
	run $@
	cleanup
}

RUNNING="$(basename $0)"
if [[ "$RUNNING" == "bwa.sh" ]]
then
	flow $@
fi
