#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <pthread.h>
#include <string.h>

// Resources available.
int maximal_resources, available_resources;
// Mutex regulating access to `available_resources`.
pthread_mutex_t mutex;

// Increases the available_resources by `count`.
int increase_count(int count)
{
    // locks the mutex.
    int err = pthread_mutex_lock(&mutex);

    // Check if there is an error.
    err |= (available_resources + count < 0 ||
            available_resources - count > maximal_resources) ? -1 : 0;
    
    // No error -> update.
    if (!err) {
        printf("Changed available resources from %d to %d!\n",
                available_resources, available_resources + count);
        available_resources += count;
    }
    else {
        printf("Unable to change available resources from %d to %d!\n",
            available_resources, available_resources + count);
    }
    fflush(stdout);
    // Unlock mutex.
    err |= pthread_mutex_unlock(&mutex);

    // return error status.
    return err;
}

// Decreases the avaiable_resource by count.
int decrease_count(int count)
{
    return increase_count(-count);
}

void* DemoRequest(void* q)
{
    int count = *((int*)q);
    if (count > 0)
        increase_count(count);
    else
        decrease_count(-count);
    free(q);
    return NULL;
}

// Prints a demo.
void Demo()
{
    printf("Starting demo...\n");

    maximal_resources = 10;
    printf("Maximal resources: %d\nAvailable Recourses: %d\n",
            maximal_resources, available_resources);
    
    pthread_t* threads = malloc(sizeof(threads) * 10);
    for (int i = 0; i < 10; i++) {
        int* add = malloc(sizeof add);
        *add = rand() % 10 - 5;
        pthread_create(threads + i, NULL, DemoRequest, add);
    }

    for (int i = 0; i < 10; i++)
        pthread_join(threads[i], NULL);
    free(threads);
}


int main(int argc, char* args[])
{
    pthread_mutex_init(&mutex, NULL);

    Demo();

    return 0;
}