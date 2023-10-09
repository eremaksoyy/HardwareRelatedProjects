#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/mman.h>

int main(){

    int N=5; // Number of elements for the array

    int *ptr = mmap(NULL,N*sizeof(int),PROT_READ | PROT_WRITE,MAP_SHARED | MAP_ANONYMOUS,0,0);

    if(ptr == MAP_FAILED){
     printf("Mapping Failed\n");
     return 1;
    }

    for(int i=0; i < N; i++){
     ptr[i] = 334;
    }

    printf("The values of the array elements :\n");

    for (int i = 0; i < N; i++ ){
     printf(" %d \n", ptr[i] );
    }



    pid_t pid = fork();

     if ( pid == 0 ){
     printf("Updating the values of the array elements :\n");
     for (int i = 0; i < N; i++)
                     ptr[i] = 462;

    }
    else{

     wait(NULL);

     printf("The values of the array elements again:\n");
     for (int i = 0; i < N; i++ )
             printf("%d \n", ptr[i] );

    }

    int err = munmap(ptr, N*sizeof(int));

    if(err != 0){
     printf("UnMapping Failed\n");
     return 1;
    }
    return 0;
}
