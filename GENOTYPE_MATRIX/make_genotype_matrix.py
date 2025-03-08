#!/usr/bin/python

print('loading packages...')
import pandas_plink
from pandas_plink import read_plink1_bin
import numpy as np

input_file_path = 'plink_file'

print('reading in the plink file...')
genotypes  = pandas_plink.read_plink(input_file_path)[2]
genotypes = genotypes.astype(np.int8)

print('computing the genotypes...')
genotype_mat = genotypes.compute()

print(genotype_mat)


output_file_path = 'genotype_matrix.txt'

print('writing genotype matrix to disc...')
np.savetxt(output_file_path, genotypes.astype(np.int8), fmt='%i', delimiter=",")

print('all done.')


