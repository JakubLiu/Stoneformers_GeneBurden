#!/usr/bin/Rscript

library(data.table)
library(SKAT)
library(bigmemory)

# read genotype matrix

genotype_mat_path <- "/data/cephfs-1/work/projects/stoneformers-geneburden/stoneformers/STEP_AFTER_MEETING/GENOTYPE_MATRIX/genotype_matrix.txt"
genotype_matrix <- read.big.matrix(
  genotype_mat_path,
  sep = ",",
  header = FALSE,
  backingfile = "genotype_umap_backing.bin", # this writes a backup file to disc, chunks will be read into main memory from this binary file
  descriptorfile = "genotype_umap_desc.desc", # a metadata file will also be written to disc
  type = "integer"
)

#read chunk index files

start_idx_path <- "/data/cephfs-1/work/projects/stoneformers-geneburden/stoneformers/STEP_AFTER_MEETING/CHUNK_INDICES/indices_start.txt"
end_idx_path <- "/data/cephfs-1/work/projects/stoneformers-geneburden/stoneformers/STEP_AFTER_MEETING/CHUNK_INDICES/indices_end.txt"
start_indices <- scan(start_idx_path, what = integer(), sep = "\n")
end_indices <- scan(end_idx_path, what = integer(), sep = '\n')

n_SNP <- nrow(genotype_matrix)
n_samples <- ncol(genotype_matrix)

# make aritficial covariate matrix (for now we don't use covariates)
covariate_matrix <- fread("/data/cephfs-1/work/projects/stoneformers-geneburden/stoneformers/STEP_AFTER_MEETING/UMAP/umap.txt")

covariate_matrix <- as.matrix(covariate_matrix)

# make artificial (binary) response vector
phenotype_file_path <- "/data/cephfs-1/work/projects/stoneformers-geneburden/stoneformers/Phenotypes.txt"
Y <- scan(phenotype_file_path, what = integer(), sep = '\n')

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
if(n_samples != length(Y)){
  if(n_samples > length(Y)){
    genotype_matrix <- genotype_matrix[,1:length(Y)]
  }
  else if(n_samples < length(Y)){
    Y <- Y[1:n_samples]
  }
}
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



geneIDs_file_path <- "/data/cephfs-1/work/projects/stoneformers-geneburden/stoneformers/STEP_AFTER_MEETING/FILTERING/GeneIDs.txt"
geneIDs <- scan(geneIDs_file_path, what = character(), sep = '\n')


num_indices <- length(start_indices)

output_matrix <- matrix(rep(0,num_indices*3), nrow = num_indices, ncol = 3)

for(i in 1:num_indices){
    
  start <- start_indices[i]
    end <- end_indices[i]
    if(start == end){  # if a gene is represented by only one single SNP, we have to increment the end variable...
      end <- end + 1 # ...because in R, the ranges are like this [start,end) and we want [start,end]
    }
    genotype_matrix_chunk <- genotype_matrix[start:end,]
    
    print(c(dim(genotype_matrix_chunk), start, end, paste0(i/num_indices*100, "%")))  # print the dimensions of the matrix for sanity check
    print('_________________________________________________________________________________')
    
    genotype_matrix_chunk <- t(genotype_matrix_chunk)
    obj <- SKAT_Null_Model(Y ~ covariate_matrix, out_type = "D")
    skat_result <- SKATBinary_Robust(genotype_matrix_chunk, obj, method = 'SKATO')
    # there are some errors, due to the data, but the method seems fine

    #results[[paste0("chunk_", start, "_to_", end)]] <- skat_result$p.value

    output_matrix[i,1] <- paste0("chunk_", start, "_to_", end)
    output_matrix[i,2] <- skat_result$p.value
    output_matrix[i,3] <- geneIDs[start]
}


print(output_matrix)
write.table(output_matrix, file = "/data/cephfs-1/work/projects/stoneformers-geneburden/stoneformers/STEP_AFTER_MEETING/SKAT/SKATO_ROBUST/SKATO_ROBUST_pca_output_matrix.txt", row.names = FALSE, col.names = FALSE)
print('all done')

