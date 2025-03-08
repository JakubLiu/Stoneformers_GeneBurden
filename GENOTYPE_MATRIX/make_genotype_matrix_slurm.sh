#!/usr/bin/bash

#SBATCH --mail-user=******
#SBATCH --mail-type=end
#SBATCH --job-name=gen_mat
#SBATCH --output=gen_mat%j.log
#SBATCH --error=gen_mat_error_%j.log
#SBATCH --ntasks=2
#SBATCH --cpus-per-task=4
#SBATCH --mem=32G
#SBATCH --time=10:00:00


python3 make_genotype_matrix.py

