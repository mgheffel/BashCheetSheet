# create a new environment with a name and base python version
conda create -n myenv python=3.8

#checking if this works and is sufficent
conda create --name scanpy3_env -c conda-forge -c bioconda scanpy seaborn leidenalg fa2
