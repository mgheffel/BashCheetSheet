#!/bin/bash
#$ -o job$TASK_ID
#$ -l h_rt=23:59:00,h_data=4G
#$ -pe shared 24
usage() { echo "Usage: bash $0 -c case -s sample -o output_directory" 1>&2; exit 1; }

while getopts ":i:c:r:o:p:b:" o; do
    case "${o}" in
        i)  cell_table=${OPTARG};;
	c)  n_cpu=${OPTARG};;
#        r)  resolution=${OPTARG};;
	o)  out_dir=${OPTARG};;
#	b)  cell_id=${OPTARG};;
        *)
            usage;;
    esac
done


export NUMEXPR_MAX_THREADS=8
export PATH="/u/home/h/heffel/.local/bin:$PATH"
#echo $PATH


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
#module load python/3.7.2
module load anaconda3/2023.03
conda activate schicluster_env
## substitute the command to run your code
## in the two lines below:
echo "$in_file $resolution $cell_id $out_dir $chrom_file"
#python3 gnomadToPickle.py gnomad.genomes.r3.0.sites.vcf.bgz test_gnomad_output.pickle
command time hicluster embedding --cell_table $cell_table --output_dir $out_dir --dim 50
    --dist 1000000 \
    --scale_factor 10000 --resolution 10000 \
    --norm_sig --save_raw --cpu 16
echo "icluster embedding --cell_table $cell_table --output_dir $out_dir --dim 50
    --dist 1000000 \
    --scale_factor 100000 --resolution 100000 \
    --norm_sig --save_raw --cpu 16"

# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo "Done"

