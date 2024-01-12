#!/bin/bash
#$ -o job$TASK_ID
#$ -l h_rt=2:00:00,h_data=16G
#$ -pe shared 2
usage() { echo "Usage: bash $0 -r reference.fasta -o output_prefix" 1>&2; exit 1; }

while getopts ":r:o:" o; do
    case "${o}" in
	r)  ref=${OPTARG};;
	o)  prefix=${OPTARG};;
        *)
            usage;;
    esac
done

#use sample index instead of sample when running with array jobs

echo "reference: $ref"

# echo job info on joblog:
echo "Job $JOB_ID started on:   " `hostname -s`
echo "Job $JOB_ID started on:   " `date `
echo " "

# load the job environment:
. /u/local/Modules/default/init/modules.sh
## Edit the line below as needed:
#module load python/3.7.2
module load bwa/0.7.17

bwa index -p $prefix $ref

# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo "Done"

