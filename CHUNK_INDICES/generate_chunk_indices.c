#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define N_ID 1000  // 1000 <---- wc -l file.txt    the size of the array should be equal to the number of lines in the gene ID file

int main(){
    FILE *ID_file;   // pointer to the input file
    FILE *start_idx_file;    // pointer the one of the output files
    FILE *end_idx_file;      // pointer to one of the output files
    char line[100];   // array to hold each gene ID
    // array to hold the contents of the file:
    char *ID_array[N_ID];  
    int i;
    char current_ID[20];    // here we will copy the pointers for comparison
    char next_ID[20];
    // create intentionally to large arrays to hold the indices, set all their elements to -1
    int start_incides[N_ID];   memset(start_incides, -1, sizeof(start_incides));
    int end_indices[N_ID];     memset(end_indices, -1, sizeof(end_indices));
    int loc_start;
    int loc_end;
    int current_chunk_end;
    int next_chunk_start;
    int size_counter;

    ID_file = fopen("geneIDs.txt", "r");  // open the file

    i = 0;
    // loop over the lines of the file and store them in the array
    while (fgets(line, sizeof(line), ID_file) != NULL) {
        ID_array[i] = strdup(line);
        i = i + 1;

    }

    start_incides[0] = 1;    
    loc_start = 1;
    loc_end = 0;
    for(i=0;i<(N_ID-9);i++){

        strcpy(current_ID, ID_array[i]);
        strcpy(next_ID, ID_array[i+1]);

        if(strcmp(current_ID, next_ID) != 0){     // compare the two IDs
            current_chunk_end = i+1;
            next_chunk_start = i+2;
            end_indices[loc_end] = current_chunk_end;
            start_incides[loc_start] = next_chunk_start;
            loc_end = loc_end + 1;
            loc_start = loc_start + 1;
            
        }
    }
    end_indices[loc_start-1] = N_ID;

    size_counter = 0;
    for(i=0;i<=N_ID;i++){
        if(end_indices[i] == -1){
            break;
        }
        else{
            size_counter = size_counter + 1;
        }
    }
    
    // declare end and start index arrays without the overhead in space
    int *start_incides_clean = malloc(size_counter * sizeof(int));
    int *end_incides_clean = malloc(size_counter * sizeof(int));

    //populate these arrays
    for(i=0; i<size_counter;i++){
        start_incides_clean[i] = start_incides[i];
        end_incides_clean[i] = end_indices[i];
    }

    start_idx_file = fopen("start_indices.txt", "w");
    end_idx_file = fopen("end_indices.txt", "w");

    for(i=0;i<size_counter;i++){
        fprintf(start_idx_file, "%d\n", start_incides_clean[i]);
        fprintf(end_idx_file, "%d\n", end_incides_clean[i]);
    }

    fclose(start_idx_file);
    fclose(end_idx_file);
    return(0);
}

