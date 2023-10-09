#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#define N 5

void *threadCall(void *arg);
int memory_array[N];    // global array created for the shared memory

int main()
{
    pthread_t thread;  
    int i, threadNew;

    printf("The values of the array elements:\n");
    
    for (i = 0; i < N; i++) {
        memory_array[i] = 334;
        printf("%d\n", memory_array[i]);  }

    threadNew = pthread_create(&thread, NULL, threadCall, NULL);
    if (threadNew) {
        printf("Thread creation is failed\n");
        return 1;  }

    threadNew = pthread_join(thread, NULL);
    if (threadNew) {
        printf("Thread join is failed\n");
        return 1; }

    printf("The values of the array elements again:\n");
    
    for (i = 0; i < N; i++) {
        printf("%d\n", memory_array[i]); }

    return 0;
    
}


// new function created to update the values in the shared array when a thread is called
void *threadCall(void *arg) {
    int i;
    printf("Updating the values of the array elements:\n");
    
    for (i = 0; i < N; i++) {
        memory_array[i] = 462;  }
        
    pthread_exit(NULL);
}



