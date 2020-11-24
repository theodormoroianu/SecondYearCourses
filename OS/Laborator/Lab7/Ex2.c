#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <pthread.h>
#include <string.h>
#include <semaphore.h>

sem_t sem;
pthread_mutex_t mutex;
int nr_processes;

void barrier_point()
{
    // Cate procese au vizitat deja bariera.
    static int visited = 0;

    // Blochez mutexul, ca sa pot sa ma joc cu visited.
    pthread_mutex_lock(&mutex);
    visited++;

    // Au trecut deja toate procesele, deci deblockez semaforul
    // cu o unitate.
    if (visited == nr_processes) {
        pthread_mutex_unlock(&mutex);
        sem_post(&sem);
        return;
    }
    
    // Deblockez mutexul.
    pthread_mutex_unlock(&mutex);

    // Astept sa imi dea si mie cnv o unitate.
    sem_wait(&sem);

    // Am reusit sa ies din semafor, trebuie sa dau si eu la altul
    sem_post(&sem);
}

void* tfun(void* v)
{
    int *tid = (int*) v;

    printf("%d reached the barrier!\n", *tid);
    fflush(stdout);
    
    barrier_point();

    printf("%d passed the barrier!\n", *tid);
    fflush(stdout);

    free(tid);

    return NULL; 
}

int main(int argc, char* args[])
{
    // Creeam semaforul, initial cu nicio libertate.
    sem_init(&sem, 0, 0);

    // Creeam mutexul.
    pthread_mutex_init(&mutex, NULL);

    printf("Cate procese doriti sa apelati?\n $ ");
    scanf("%d", &nr_processes);

    
    pthread_t* threads = malloc(sizeof(threads) * nr_processes);
    for (int i = 0; i < nr_processes; i++) {
        int* arg = malloc(sizeof arg);
        *arg = i;
        pthread_create(threads + i, NULL, tfun, arg);
    }

    for (int i = 0; i < nr_processes; i++)
        pthread_join(threads[i], NULL);
    free(threads);

    return 0;
}