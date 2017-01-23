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

preload() {
	log 'preload'
	for arg in $@; do
		if [[ "$arg" =~ gz$ ]] && [[ ! -e $arg ]]; then
			error "$arg didn't exist. Process terminated right now."
			exit 100
		fi
	done
}

run() {
	source bwa.ini
	BamName=`basename $1 | sed -e 's/_R1_/_/g' -e 's/fastq\///g' -e 's/\//_/g'`
	SAMPLE=${3:-123}
	PLATFORM="ILLUMINA"

	log $(basename ${BASH_SOURCE[0]})
	log "cmd: $bwa mem -t ${thread} -R \"@RG\tID:${SAMPLE}\tSM:${SAMPLE}\tLB:${SAMPLE}\tPL:${PLATFORM}\" $ref $(join_by " " $@) | $samtools view -hSb - > ${BamName}.bam"
	#exec "cmd: $bwa mem -t ${thread} -R \"@RG\tID:${SAMPLE}\tSM:${SAMPLE}\tLB:${SAMPLE}\tPL:${PLATFORM}\" $ref $(join_by " " $@) | $samtools view -hSb - > ${BamName}.bam"
}

cleanup() {
	log "cleanup"
}

main () {
	preload $@
	run $@
	cleanup
}

RUNNING="$(basename $0)"
if [[ "$RUNNING" == "bwa.sh" ]]
then
	main $@
fi
