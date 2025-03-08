#!/usr/bin/bash

#SBATCH --mail-user=*********
#SBATCH --mail-type=end
#SBATCH --job-name=SKAT_umap
#SBATCH --output=SKAT_umap%j.log
#SBATCH --error=SKAT_umap_error%j.log
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --mem=32G
#SBATCH --time=30:00:00


Rscript SKAT_umap.R
