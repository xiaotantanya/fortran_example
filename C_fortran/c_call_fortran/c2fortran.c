#include<string.h>

struct test{
    int n;
    float m;
};

int main(int argc,char* argv[]){
    struct test t;
    t.n = 90;
    t.m = 0.003;
    int i;
    float e = 2.71828;
    char hello[32];
    int length = sizeof(hello);
    strcpy(hello,"Hello Fortran from C");
    for(i=strlen(hello);i<length;i++){
        hello[i] = ' ';
    }
    showhie_(hello,&length,&e,&t);
    return 0;
}