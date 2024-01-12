#!/bin/bash
#$ -o job$TASK_ID
#$ -l h_rt=2:00:00,h_data=16G
#$ -pe shared 2
usage() { echo "Usage: bash $0 -c case -s sample -o output_directory" 1>&2; exit 1; }

while getopts ":c:s:o:" o; do
    case "${o}" in
        c)
            case=${OPTARG};;
        s)
            sample=${OPTARG};;
	o)  out_dir=${OPTARG};;
        *)
            usage;;
    esac
done

#use sample index instead of sample when running with array jobs
sampleIndex=$(($SGE_TASK_ID-1))
echo "case: $case"
echo "sample: $sample"
echo "sampleIndex: $sampleIndex"
echo "output directory: $out_dir"

# echo job info on joblog:
echo "Job $JOB_ID started on:   " `hostname -s`
echo "Job $JOB_ID started on:   " `date `
echo " "

# load the job environment:
. /u/local/Modules/default/init/modules.sh
## Edit the line below as needed:
#module load python/3.7.2
module load python/anaconda3
conda activate snmcseq
## substitute the command to run your code
## in the two lines below:
echo './flatten_case_sample.py $case $sampleIndex $out_dir'
#python3 gnomadToPickle.py gnomad.genomes.r3.0.sites.vcf.bgz test_gnomad_output.pickle
python3 /u/home/h/heffel/project-cluo/scripts/flatten_case_sample.py $case $sampleIndex $out_dir
echo "flatten_case_sample.py $case $sampleIndex $out_dir"

# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo "Done"

