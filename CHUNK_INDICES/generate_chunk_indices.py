#!/usr/bin/python

import numpy as np

print('reading the gene ID file...')
geneID_file_path = '/GeneIDs.txt'
IDs = np.loadtxt(geneID_file_path,dtype = str, delimiter = None, encoding='utf-8')


print('calculating the indices...')
num_IDs = IDs.shape[0]

# generate fixed sizes arrays that are intentionally to large, but this is more efficient than doing variable sized objects
start = np.zeros(num_IDs,dtype = np.uint64)
end = np.zeros(num_IDs,dtype = np.uint64)

start[0] = 1 # the 1st start index must be a 1 (and not a 0), because later we will work in R
loc_end = 0
loc_start = 1

print('starting loop...')

# here get the start and end indices
# this needs to be checked when the real data arrive, because if this is off, then everything downstream is incorrect
for i in range(1,num_IDs-1):
    if IDs[i] != IDs[i+1]:
        current_chunk_end = i+1
        next_chunk_start = current_chunk_end + 1
        end[loc_end] = current_chunk_end
        start[loc_start] = next_chunk_start
        loc_end = loc_end + 1
        loc_start = loc_start + 1

end[loc_start-1] = num_IDs


# now get remove the overhead from the too big arrays
size = 0

for val in start:
    if val == 0:
        break
    else:
        size = size + 1

start_small = np.zeros(size, dtype = np.uint64)
end_small = np.zeros(size, dtype = np.uint64)

for i in range(0,size):
    start_small[i] = start[i]
    end_small[i] = end[i]


print('saving the files...')
# NOTE: I save these arrays as strings (fmt = '%s'), because the default integer saving format is a 64bit integer...
# ... but when the real data comes, this might not be enough to store big indices

outfile_start = 'indices_start.txt'
outfile_end = 'indices_end.txt'
np.savetxt(outfile_start, start_small, fmt='%s', delimiter=",")
np.savetxt(outfile_end, end_small, fmt='%s', delimiter=",")

print('all done.')
