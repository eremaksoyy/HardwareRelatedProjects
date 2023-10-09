#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <unistd.h>

void *worker(void *param);

#define NUMBER_OF_DARTS	    50000000
#define NUMBER_OF_THREADS	5

// to complete: variables

int circle_count=0;
  

/*
 * Generates a double precision random number
 */
double random_double()
{
	return random() / ((double)RAND_MAX + 1);
}

// initialyzing mutex
pthread_mutex_t  mutex = PTHREAD_MUTEX_INITIALIZER;

int main (int argc, const char * argv[]) {
	

	/* seed the random number generator */
    srandom((unsigned)time(NULL));


	// to complete: Threads Creations 
    pthread_t threads[NUMBER_OF_THREADS];
    int i;
    int thread_args[NUMBER_OF_THREADS]; // this array is used to pass the # of darts to each thread
    
    
    for (i=0 ; i<NUMBER_OF_THREADS ; i++) {
        thread_args[i] = NUMBER_OF_DARTS / NUMBER_OF_THREADS;
        pthread_create(&threads[i], NULL, worker, &thread_args[i]); } // creating threads

    for (i=0 ; i<NUMBER_OF_THREADS ; i++) {
        pthread_join(threads[i], NULL); }   // joining threads
    

	/* estimate Pi */
	estimated_pi = 4.0 * circle_count / NUMBER_OF_DARTS;

	printf("Pi = %f\n",estimated_pi);

	return 0;
}


// modifying this function to protect the CS (or CR) by using the mutex created
void *worker(void *param)
{
	int number_of_darts;
	number_of_darts = *((int *)param);
	int i;
	int hit_count = 0;
	double x,y;

	for (i = 0; i < number_of_darts; i++) {
		/* generate random numbers between -1.0 and +1.0 (exclusive) */
		x = random_double() * 2.0 - 1.0;
		y = random_double() * 2.0 - 1.0;

		if ( sqrt(x*x + y*y) < 1.0 ){
            pthread_mutex_lock(&mutex); // locking mutex
			++hit_count;
            pthread_mutex_unlock(&mutex);   // unlocking mutex after updaating the hit count value
        }      
	}
    
    pthread_mutex_lock(&mutex); // locking mutex
	circle_count += hit_count;
    pthread_mutex_unlock(&mutex);   // unlocking mutex after updating the circle count value
    
	pthread_exit(0);
}

