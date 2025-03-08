#!/usr/bin/bash

#SBATCH --mail-user=********
#SBATCH --mail-type=end
#SBATCH --job-name=plink
#SBATCH --output=plink%j.log
#SBATCH --error=plink_%j.log
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --mem=32G
#SBATCH --time=02:00:00


input_vcf_file="VCF_filtered.vcf"
output_plink_prefix="plink_file"


plink --vcf $input_vcf_file --make-bed --out $output_plink_prefix
