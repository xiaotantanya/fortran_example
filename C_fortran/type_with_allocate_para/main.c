#include <stdio.h>
#include <stdlib.h>

struct my_struct {
    int nrows;
    int ncols;
    float **data;
};

/* Fortran subroutine declaration */
extern void my_fortran_function_(struct my_struct *s);

/* Function to initialize the structure */
void init_my_struct(struct my_struct *s, int nrows, int ncols) {
    int i;

    s->nrows = nrows;
    s->ncols = ncols;

    /* Allocate memory for data array */
    s->data = (float **)malloc(nrows * sizeof(float *));
    if (s->data == NULL) {
        fprintf(stderr, "Memory allocation failed.\n");
        exit(1);
    }

    for (i = 0; i < nrows; i++) {
        s->data[i] = (float *)malloc(ncols * sizeof(float));
        if (s->data[i] == NULL) {
            fprintf(stderr, "Memory allocation failed.\n");
            exit(1);
        }
    }
}

/* Function to free memory allocated for the structure */
void free_my_struct(struct my_struct *s) {
    int i;

    for (i = 0; i < s->nrows; i++) {
        free(s->data[i]);
    }
    free(s->data);
}

/* Example usage */
int main() {
    struct my_struct my_data;
    int nrows = 3;
    int ncols = 4;
    int i, j;

    init_my_struct(&my_data, nrows, ncols);

    /* Populate data */
    for (i = 0; i < nrows; i++) {
        for (j = 0; j < ncols; j++) {
            my_data.data[i][j] = i * ncols + j;
        }
    }

    /* Call Fortran function */
    my_fortran_function_(&my_data);

    /* Free memory */
    free_my_struct(&my_data);

    return 0;
}
