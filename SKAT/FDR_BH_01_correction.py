#!/usr/bin/python
import numpy as np
import statsmodels.stats.multitest as mult

pca_raw_pvals = np.loadtxt('/data/cephfs-1/work/projects/stoneformers-geneburden/stoneformers/STEP_AFTER_MEETING/SKAT/SKAT_pca_output_matrix.txt',
        usecols = 1, dtype = float)

fdr_level = 0.1

corrected_pvals = mult.multipletests(pvals = pca_raw_pvals,
        alpha = fdr_level,
        method = 'fdr_bh')[1]

np.savetxt('/data/cephfs-1/work/projects/stoneformers-geneburden/stoneformers/STEP_AFTER_MEETING/SKAT/fdr_bh_corrected_pca_pvals.txt',  corrected_pvals)

print(corrected_pvals)

n_significant_005 = corrected_pvals[corrected_pvals <= 0.05].shape[0]

print('Significant genes after BH correction on alpha level 0.05: {}'.format(n_significant_005))
