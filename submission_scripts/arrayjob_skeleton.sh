#!/bin/bash
#$ -o job$TASK_ID
#$ -l highp,h_rt=167:00:00,h_data=4G
#$ -pe shared 24
usage() { echo "Usage: bash $0 -c case -s sample -o output_directory" 1>&2; exit 1; }

while getopts ":i:c:" o; do
    case "${o}" in
        i)  in_file=${OPTARG};;
        c)  chrom_file=${OPTARG};;
        *)
            usage;;
    esac
done

#use sample index instead of sample when running with array jobs
sampleIndex=$(($SGE_TASK_ID))

echo "output directory: $out_dir"

# echo job info on joblog:
echo "Job $JOB_ID started on:   " `hostname -s`
echo "Job $JOB_ID started on:   " `date `
echo " "

# load the job environment:
. /u/local/Modules/default/init/modules.sh
## Edit the line below as needed:
module load anaconda3/2023.03
conda activate conda_env

## substitute the command to run your code
## in the two lines below:
echo "variables"

#run code
#echo "words"

# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo "Done"
