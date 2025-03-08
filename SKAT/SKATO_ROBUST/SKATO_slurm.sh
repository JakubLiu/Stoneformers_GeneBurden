#!/usr/bin/bash

#SBATCH --mail-user=*******
#SBATCH --mail-type=end
#SBATCH --job-name=SKATO_pca
#SBATCH --output=SKATO_pca%j.log
#SBATCH --error=SKATO_pca_error%j.log
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --mem=32G
#SBATCH --time=30:00:00


Rscript SKATO_pca.R


