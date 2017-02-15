#!/usr/bin/env python
import sys;
from collections import OrderedDict
from pprint import pprint

def readInput(fileName):
	d = []
	with open(sys.argv[1]) as f:
		for line in f:
			token = line.split("\t")
			d.append(str(token[0]+":"+token[1]).rstrip())
	return d

def readInterval(d1, jobs):
	i = 1
	JOBS = jobs
	TOTAL_COUNT = len(d1)
	SPAN = int(TOTAL_COUNT / JOBS)
	job_count = 1
	prev_offset = 0
	d = []
	for val in d1:
		(pos, offset) = val.split(':', 2)
		if i % SPAN == 0:
			read_length = 0
			if job_count == JOBS:
				bgzip_length = ""
				read_length = 0
			else:
				bgzip_length = "-s "+str(int(offset) - int(prev_offset))
				read_length = int(offset) - int(prev_offset)
			#print "> ",i," ",job_count," / ",JOBS," ",pos," : ",offset,"<<  command -b ",prev_offset,bgzip_length
			d.append((str(prev_offset)+":"+str(read_length)).rstrip())
			prev_offset = offset
			job_count = job_count + 1
		i = i + 1
	return d

if len(sys.argv) < 3:
	print "Error argument"
	sys.exit()

run_jobs = int(sys.argv[3])
d1 = readInput(sys.argv[1])
d2 = readInput(sys.argv[2])
interval_d1 = readInterval(d1, run_jobs)
interval_d2 = readInterval(d2, run_jobs)

n = 0
for v in interval_d1:
	(pos1, offset1) = v.split(':', 2)
	(pos2, offset2) = interval_d2[n].split(':', 2)
	#print n," > ",v," ,",interval_d2[n]," ::: -b1 ",pos1," -s1 ",offset1," -b2 ",pos2," -s2 ",offset2
	print pos1,"\t",offset1,"\t",pos2,"\t",offset2
	n += 1
