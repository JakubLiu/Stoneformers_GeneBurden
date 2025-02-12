#!/usr/bin/python
import numpy as np


GeneIDs = np.loadtxt('/data/cephfs-1/work/projects/stoneformers-geneburden/stoneformers/STEP_AFTER_MEETING/FILTERING/GeneIDs.txt', dtype = str)

counter = 1
lengths = []

for i in range(0, len(GeneIDs)-1):
    
    if GeneIDs[i] == GeneIDs[i+1]:
        counter = counter + 1
    else:
        print(counter)
        lengths.append(counter)
        counter = 1
        next



print("Mean number of SNPs per gene: {}".format(np.mean(lengths)))
print("Median number of SNPs per gene: {}".format(np.median(lengths)))

