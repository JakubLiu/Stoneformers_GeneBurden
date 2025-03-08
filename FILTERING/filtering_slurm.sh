#!/usr/bin/bash

#SBATCH --mail-user=*********
#SBATCH --mail-type=end
#SBATCH --job-name=filtering
#SBATCH --output=filtering%j.log
#SBATCH --error=filtering_error_%j.log
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --mem=32G
#SBATCH --time=01:00:00


input_vcf_path="*****"
output_filtered_vcf_path="*****"

bcftools filter -i '(INFO/dbNSFP_CADD_phred >= 20 || INFO/dbNSFP_CADD_phred
= ".") && (INFO/dbNSFP_gnomAD_exomes_AF < 0.025 || INFO/dbNSFP_gnomAD_exomes_AF
== ".") && (INFO/dbNSFP_gnomAD_genomes_AF < 0.025 || INFO/dbNSFP_gnomAD_genomes_AF == ".") && (INFO/ANN ~ "missense_variant" || INFO/ANN ~ "conservative_inframe_insertion" || INFO/ANN ~ "disruptive_inframe_insertion" || INFO/ANN ~ "conservative_inframe_deletion" || INFO/ANN ~ "disruptive_inframe_deletion" || INFO/ANN ~ "start_lost" || INFO/ANN ~ "stop_gained" || INFO/ANN ~ "frameshift_variant" || INFO/ANN ~ "splice_donor_variant" || INFO/ANN ~ "plice_acceptor_variant")' $input_vcf_path -o $output_filtered_vcf_path

