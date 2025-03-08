#!/usr/bin/python

import numpy as np
from sklearn.decomposition import PCA

print('reading genotype matrix...')
genotype_mat = np.loadtxt('genotype_matrix.txt',
        dtype = np.int8, delimiter = ',')


'''
The original genotype matrix has dimensions (n_snps x n_patients), for PCA we
need it to be in the form (n_patients x n_snps)
'''

print('transposing genotype matrix...')
genotype_mat = np.transpose(genotype_mat)
n_patients, n_snps = genotype_mat.shape

print('performing pca...')
pca_instance=PCA(n_components=(n_patients-1))
pca_instance.fit(genotype_mat)

#print('printing explained variance by pca (only first 50 principal components...)')
#print(pca_instance.explained_variance_ratio_[:50])

print('setting new coordinates for the datapoints')
genotype_mat_new_coords=pca_instance.transform(genotype_mat)

print('extracting the 1st 4 principal components')
pca_4pcs = genotype_mat_new_coords[:,:4]
print('dimensions of extraction: ', pca_4pcs.shape)

print('writing to file...')
file_out_path = 'pca_4pcs.csv'
np.savetxt(file_out_path, pca_4pcs, delimiter = ',')

print('all done.')



