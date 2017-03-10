#!/bin/bash
DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
source $DIR/common.sh

preload() {
	log 'preload'
	for arg in $@; do
		if [[ "$arg" =~ gz$ ]] && [[ ! -e $arg ]]; then
			error "$arg didn't exist. Process terminated right now."
			exit 100
		fi
	done
}

postBamProcess() {
	inputBam=$1
	sortedName=$(echo $inputBam | sed 's/\.bam/\.sort\.bam/g')

	cmd="$samtools sort ${inputBam} -o ${sortedName} && $samtools index ${sortedName}"
	log "cmd: $cmd"
	exec "$cmd"
}

run() {
	PLATFORM="ILLUMINA"
	ERROR_LOG="bwa.${SAMPLE}.err"
	log $(basename ${BASH_SOURCE[0]})
	cmd="$bwa mem -t ${thread} -R \"@RG\tID:${SAMPLE}\tSM:${SAMPLE}\tLB:${SAMPLE}\tPL:${PLATFORM}\" \
		$ref $(join_by " " $@) 2>${ERROR_LOG} | $samtools view -hSb - > ${result}/${BamName}.bam 2>>${ERROR_LOG}"
	log "cmd: $cmd"
	exec "$cmd"
}

cleanup() {
	log "cleanup"
}

main () {
	(
		source bwa.ini
		SAMPLE=${3:-123}
		if [[ "$1" =~ "/dev/fd" ]]; then
			BamName=$SAMPLE
		else
			BamName=`basename $1 | sed -e 's/_R1_/_/g' -e 's/fastq\///g' -e 's/\//_/g'`
		fi
		[[ -e ${result} ]] && rm -rf ${result}
		mkdir ${result}
		scriptFile="$PWD/bwa.${SAMPLE}.sh"
		preload $@
		run $@
		(samtools=$samtools; postBamProcess ${result}/${BamName}.bam)
		cleanup
	)
}

RUNNING="$(basename $0)"
if [[ "$RUNNING" == "bwa.sh" ]]
then
	main $@
fi
