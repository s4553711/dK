#!/bin/bash
DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
source $DIR/common.sh

preload() {
	log 'preload'
}

run() {
	source lofreq.ini

	inputBam=$1
	dindelBam=$(basename ${inputBam}|sed 's/\.bam/\.dindel\.bam/g')
	vcf=$(basename $dindelBam|sed 's/\.bam/\.vcf/g')
	mkdir ${result}
	log $(basename ${BASH_SOURCE[0]})
	log "cmd: ${lofreq} indelqual -f ${ref} --dindel -o ${result}/${dindelBam} ${inputBam}"
	log "cmd: ${lofreq} call --call-indels --no-default-filter -f ${ref} -o ${result}/${vcf} ${dindelBam}"
	exec "${lofreq} indelqual -f ${ref} --dindel -o ${dindelBam} ${inputBam}"
	exec "${lofreq} call --call-indels --no-default-filter -f ${ref} -o ${vcf} ${dindelBam}"
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
if [[ "$RUNNING" == "lofreq.sh" ]]
then
	main $@
fi
