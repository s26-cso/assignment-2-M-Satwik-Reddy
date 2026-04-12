#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>

int main(){
    char op[6];
    int num1,num2;
    char path[32];

    //read until EOF
    while(scanf("%s %d %d", op, &num1,&num2) == 3){
        //building library path
        strcpy(path,"./lib");
        strcat(path, op);
        strcat(path,".so");

        //load library into memory
        void *load = dlopen(path,RTLD_LAZY);
        if(!load){
            printf("Error loading the library\n");
            continue;
        }

        //finding function inside the library
        int (*operation)(int,int) = (int (*)(int, int))dlsym(load,op);

        if(operation == NULL){
            printf("Error finding the function\n");
            dlclose(load);
            continue;
        }

        printf("%d\n",operation(num1,num2));
        dlclose(load);          //for 2GB limit
    }

    return 0;
}