### Usage 
```bash
$ cat bwa.ini
bwa=/opt/app/bwa-0.7.5a/bwa
ref=/wz/ref/human_g1k_v37_phase2/ref.fasta
$ bin/dk run bwa run -t 10 r1.fastq.gz r2.fastq.gz 
dk > pipeline: bwa: 6
dK > execute bwa.sh ,method: flow
[2017-01-20 17:22:09] bwa, INFO: preload
[2017-01-20 17:22:09] bwa, INFO: bwa.sh
[2017-01-20 17:22:09] bwa, INFO: cmd: /opt/app/bwa-0.7.5a/bwa mem /wz/ref/human_g1k_v37_phase2/ref.fasta -t 10 r1.fastq.gz r2.fastq.gz
[2017-01-20 17:22:09] bwa, INFO: cleanup
```
