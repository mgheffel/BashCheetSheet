#!/bin/bash
#$ -o job$TASK_ID
#$ -l h_rt=23:00:00,h_data=8G
#$ -pe shared 4
usage() { echo "Usage: bash $0 -c case -s sample -o output_directory" 1>&2; exit 1; }

while getopts ":f:d:c:r:o:" o; do
    case "${o}" in
        f)  cell_list_file=${OPTARG};;
	c)  chrom=${OPTARG};;
        r)  resolution=${OPTARG};;
	o)  out_prefix=${OPTARG};;
#	b)  cell_id=${OPTARG};;
        *)
            usage;;
    esac
done

#use sample index instead of sample when running with array jobs
sampleIndex=$(($SGE_TASK_ID))

echo $cell_list_file
echo $resolution
echo $out_prefix

# echo job info on joblog:
echo "Job $JOB_ID started on:   " `hostname -s`
echo "Job $JOB_ID started on:   " `date `
echo " "

# load the job environment:
. /u/local/Modules/default/init/modules.sh
## Edit the line below as needed:
#module load python/3.7.2
module load anaconda3
conda activate schicluster_env
## substitute the command to run your code
## in the two lines below:
echo "$in_file $resolution $cell_id $out_dir $chrom_file"
#python3 gnomadToPickle.py gnomad.genomes.r3.0.sites.vcf.bgz test_gnomad_output.pickle
for c in `seq 1 22`; do
	command time hicluster embed-concatcell-chr --cell_list $cell_list_file --outprefix $out_prefix --res ${resolution};
done
#command time hicluster impute-cell --indir $in_dir/chr1/ --outdir $out_dir/chr1/ --chrom_file $chrom_file --res ${resolution} --pad 1 --cell ${cell_id} --chrom 1;


# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo "Done"

