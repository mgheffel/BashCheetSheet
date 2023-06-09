#laod anaconda3
module load anaconda3
#create env
conda create --name awscli
#activate env and install awscli
conda activate awscli
conda install -c conda-forge awscli
