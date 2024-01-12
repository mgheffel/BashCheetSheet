#!/bin/bash
#$ -o job$TASK_ID
#$ -l h_rt=4:00:00,h_data=8G
#$ -pe shared 1
usage() { echo "Usage: bash $0 -i infile.gz -o outdir" 1>&2; exit 1; }

while getopts ":i:o:" o; do
    case "${o}" in
        i)  infile=${OPTARG};;
	o)  outdir=${OPTARG};;
        *)
            usage;;
    esac
done


echo "infile: $infile"
echo "outdir: $outdir"

# echo job info on joblog:
echo "Job $JOB_ID started on:   " `hostname -s`
echo "Job $JOB_ID started on:   " `date `
echo " "

# load the job environment:
. /u/local/Modules/default/init/modules.sh
## Edit the line below as needed:
#module load python/3.7.2
module load anaconda3
source activate snmcseq
## substitute the command to run your code
## in the two lines below:

newfile=${infile##*/}
echo $newfile
newfile=${newfile::-2}bgz
echo $newfile

echo $outdir/$newfile

zcat $infile | bgzip -c > $outdir/$newfile
tabix -p vcf $outdir/$newfile


# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo "Done"

