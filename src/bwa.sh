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
	sortedName=$(echo $inputBam | sed 's/\.bam/\.sort/g')

	log "cmd: $samtools sort ${inputBam} ${sortedName}"
	exec "$samtools sort ${inputBam} ${sortedName}"

	log "cmd: $samtools index ${sortedName}.bam"
	exec "$samtools index ${sortedName}.bam"
}

run() {
	source bwa.ini
	BamName=`basename $1 | sed -e 's/_R1_/_/g' -e 's/fastq\///g' -e 's/\//_/g'`
	SAMPLE=${3:-123}
	PLATFORM="ILLUMINA"

	mkdir ${result}
	log $(basename ${BASH_SOURCE[0]})
	log "cmd: $bwa mem -t ${thread} -R \"@RG\tID:${SAMPLE}\tSM:${SAMPLE}\tLB:${SAMPLE}\tPL:${PLATFORM}\" $ref $(join_by " " $@) | $samtools view -hSb - > ${result}/${BamName}.bam"
	exec "$bwa mem -t ${thread} -R \"@RG\tID:${SAMPLE}\tSM:${SAMPLE}\tLB:${SAMPLE}\tPL:${PLATFORM}\" $ref $(join_by " " $@) | $samtools view -hSb - > ${result}/${BamName}.bam"
}

cleanup() {
	log "cleanup"
}

main () {
	source bwa.ini
	BamName=`basename $1 | sed -e 's/_R1_/_/g' -e 's/fastq\///g' -e 's/\//_/g'`
	preload $@
	run $@
	(samtools=$samtools; postBamProcess ${result}/${BamName}.bam)
	cleanup
}

RUNNING="$(basename $0)"
if [[ "$RUNNING" == "bwa.sh" ]]
then
	main $@
fi
