#!/bin/bash
#$ -o job$TASK_ID
#$ -l highp,h_rt=48:00:00,h_data=8G
#$ -pe shared 12
usage() { echo "Usage: bash $0 -a allc_list_file -o output_prefix -b bin_size -h current_directory_path" 1>&2; exit 1; }

while getopts ":a:o:b:h:" o; do
    case "${o}" in
        a) allc_list=${OPTARG};;
	o) out_prefix=${OPTARG};;
	b) bin_size=${OPTARG};;
	h) wd=${OPTARG};;
        *)
            usage;;
    esac
done

cd $wd
echo "CWD: $PWD"

# echo job info on joblog:
echo "Job $JOB_ID started on:   " `hostname -s`
echo "Job $JOB_ID started on:   " `date `
echo " "

# load the job environment:
. /u/local/Modules/default/init/modules.sh

module load anaconda3
#source activate snmcseq
conda activate allcools

allcools generate-mcds --allc_table $allc_list --output_prefix ${out_prefix}_mcds --chrom_size_path  /u/project/cluo/heffel/shizhong/hg19_autosome.genome --mc_contexts CGN CHN --bin_sizes $bin_size --region_bed_paths /u/project/cluo/heffel/shizhong/gencode.v19.coding.autosome_3col.bed.gz --region_bed_names gene --cov_cutoff 2 --cpu 8 --max_per_mcds 3072 --dtype uint16


# echo job info on joblog:
echo "Job $JOB_ID ended on:   " `hostname -s`
echo "Job $JOB_ID ended on:   " `date `
echo "Done"
