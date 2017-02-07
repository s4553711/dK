#!/bin/bash
DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
source $DIR/common.sh

preload() {
	log 'preload'
}

run() {
	cmd="${freebayes} -= -@ ${varint_input} -f ${ref} -L $bamList --region $region"
	log "cmd: $cmd"
	#exec "$cmd"
}

cleanup() {
	log "cleanup"
}

main () {
	(
		source freebayes.ini
		preload $@
		run $@
		cleanup
	)
}

RUNNING="$(basename $0)"
if [[ "$RUNNING" == "freebayes.sh" ]]
then
	main $@
fi
