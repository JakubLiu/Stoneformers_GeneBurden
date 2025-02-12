#!/usr/bin/python

import numpy as np
import umap

print('reading genotype matrix...')
genotype_mat = np.loadtxt('/data/cephfs-1/work/projects/stoneformers-geneburden/stoneformers/STEP_AFTER_MEETING/GENOTYPE_MATRIX/genotype_matrix.txt',
        dtype = np.int8, delimiter = ',')


'''
The original genotype matrix has dimensions (n_snps x n_patients), for PCA we
need it to be in the form (n_patients x n_snps)
'''

print('transposing genotype matrix...')
genotype_mat = np.transpose(genotype_mat)
n_patients, n_snps = genotype_mat.shape

print('performing umap...')
umap_instance = umap.UMAP()
embedding = umap_instance.fit_transform(genotype_mat)

print('saving file...')
np.savetxt('/data/cephfs-1/work/projects/stoneformers-geneburden/stoneformers/STEP_AFTER_MEETING/UMAP/umap.txt',
        embedding)

print('all done.')
