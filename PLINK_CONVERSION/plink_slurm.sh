#!/usr/bin/bash

#SBATCH --mail-user=jakub-jozef.liu@charite.de
#SBATCH --mail-type=end
#SBATCH --job-name=plink
#SBATCH --output=plink%j.log
#SBATCH --error=plink_%j.log
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --mem=32G
#SBATCH --time=02:00:00


input_vcf_file="/data/cephfs-1/work/projects/stoneformers-geneburden/stoneformers/STEP_AFTER_MEETING/FILTERING/VCF_filtered.vcf"
output_plink_prefix="/data/cephfs-1/work/projects/stoneformers-geneburden/stoneformers/STEP_AFTER_MEETING/PLINK_CONVERSION/plink_file"


plink --vcf $input_vcf_file --make-bed --out $output_plink_prefix
