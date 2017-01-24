#!/bin/bash
DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
source $DIR/common.sh

preload() {
	log 'preload'
	source gatk.ini
	rm -rf ${tmp}
	mkdir ${tmp} ${result}
}

run() {
	source gatk.ini
	inputBam=$1
	contig=$2
	cmd="java -Xmx4096m -Djava.io.tmpdir=${tmp} \
			-jar ${gatkJar} \
			-T RealignerTargetCreator \
			-L ${contig} \
			-I ${inputBam} \
			-R ${ref} \
			-o ${result}/clean.intervals ${realignSnp} \
			-mismatch 0.0"
	log $(basename ${BASH_SOURCE[0]})
	log "cmd: $cmd"
	exec "$cmd"

	cmd="java -Xmx4096m -Djava.io.tmpdir=${tmp} \
			-jar ${gatkJar} \
			-T IndelRealigner \
			-L ${contig} \
			-I ${inputBam} \
			-R ${ref} \
			${realignSnp} \
			-targetIntervals ${result}/clean.intervals \
			-o $(echo ${inputBam} | sed 's/\.bam/\.clean\.bam/g') \
			-model USE_READS"
	log "cmd: $cmd"
	exec "$cmd"
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
if [[ "$RUNNING" == "gatkRealign.sh" ]]
then
	main $@
fi
