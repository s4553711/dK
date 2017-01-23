#!/bin/bash

# directly call bwa.sh
src/bwa.sh seq_R1_001.fastq.gz seq_R2_001.fastq.gz

# include by another script and submit job via qsub
jid=123
qsub -N bwa.${jid} -q queue.q -o qsub.log -e qsub.log -cwd bin/dk run bwa main seq_R1_001.fastq.gz seq_R2_001.fastq.gz
