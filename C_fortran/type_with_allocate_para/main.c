#include <stdio.h>
#include <stdlib.h>

// struct my_struct {
//     int nrows;
//     int ncols;
//     float **data;
// };

/* Fortran subroutine declaration */
extern void my_fortran_function_(int *s);


/* Example usage */
int main() {
    int * s = (int*)malloc(10*sizeof(int));
    for(int i = 0;i<10;i++){
        s[i] = i;
    }
    printf("before changed, s[0]: %d\n", s[0]);
    my_fortran_function_(s);
    printf("after changed, s[0]: %d\n", s[0]);

}
