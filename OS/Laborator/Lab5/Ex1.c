#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <errno.h>
#include <sys/wait.h>


// Used for parsing arguments.
int ParseInt(char* s)
{
    int l = strlen(s);
    int ans = 0, i;

    for (i = 0; i < l; i++) {
        if (s[i] > '9' || s[i] < '0')
            return -1;
        ans = 10 * ans + s[i] - '0';
    }
    return ans;
}

int main(int argc, char* args[])
{
    // Nu am primit niciun numar.
    if (argc == 1) {
        printf("Error: Found no arguments!\n");
        return 0;
    }

    // Name of the shared_memory.
    const char shm_collaz_name[] = "collaz_shared_memory";

    // Open the shared memory.
    int shm_fd = shm_open(
            shm_collaz_name,
            O_CREAT | O_RDWR,
            S_IRUSR | S_IWUSR);
    
    // Unable to open file descriptor.
    if (shm_fd < 0) {
        perror(NULL);
        return errno;
    }

    // Size alocated for each child process.
    int SIZE_PER_CHILD = getpagesize();
     // If for some reasons getpagesize() is too small.
    while (SIZE_PER_CHILD < 100)
        SIZE_PER_CHILD *= 2;
    int shm_size = SIZE_PER_CHILD * (argc - 1);
    
    // Unable to resize shared memory.
    if (ftruncate(shm_fd, shm_size) == -1) {
        perror(NULL);
        shm_unlink(shm_collaz_name);
        return errno;
    }

    // Print info to terminal.
    printf("Hello There!\nI am process #%d!\n", getpid());
    fflush(stdout);

    // Id used for identifying the collaz number
    // the process has to compute.
    // 0 for main process.
    int id = 0; 

    // Now I create a new fork for each child.
    for (int i = 1; i < argc; i++) {
        int pid = fork();

        if (pid < 0) {
            printf("Unable to fork!\n");
            perror(NULL);
            return errno;
        }
        if (pid == 0) {
            // Child process here.
            id = i;
            printf("Branch: #%d ---> #%d\n",
                    getppid(), getpid());
            fflush(stdout);
            break;
        }
    }

    // I am a forked process.
    if (id) {
        // Now, open shared memory.
        int* shm_ptr = mmap(
                0,
                shm_size,
                PROT_READ | PROT_WRITE,
                MAP_SHARED,
                shm_fd,
                (id - 1) * SIZE_PER_CHILD);

        if (shm_ptr == MAP_FAILED) {
            perror(NULL);
            printf("Unable to open shared memory!\n");
            fflush(stdout);
            return errno;
        }

        int val = ParseInt(args[id]);

        if (val == -1) {
            shm_ptr[0] = -1, shm_ptr[1] = 0;
            munmap(shm_ptr, SIZE_PER_CHILD);
            return -1;
        }

        // Store initial number at pozition 0, and size
        // at pozition 1.
        shm_ptr[0] = val;
        shm_ptr[1] = 0;

        for (int i = 2; i < SIZE_PER_CHILD / 4 && val; i++) {
            shm_ptr[i] = val;
            shm_ptr[1]++;
            if ((val & 1) && val != 1)
                val = 3 * val + 1;
            val /= 2;
        }

        munmap(shm_ptr, SIZE_PER_CHILD);

        return 0;
    }

    // I am not a forked process.
    
    // First, wait for all children.
    for (int i = 1; i < argc; i++) {
        int process_id, ret_code;
        process_id = wait(&ret_code);
        if (ret_code == 0)
            printf("Wait: #%d <--- #%d\n", getpid(), process_id);
        else
            printf("Wait: #%d <--- #%d (Status = %d)\n", getpid(), process_id, ret_code);
        fflush(stdout);
    }

    // Now, open shared memory.
    void* shm_ptr = mmap(
            0,
            shm_size,
            PROT_READ | PROT_WRITE,
            MAP_SHARED,
            shm_fd,
            0);

    if (shm_ptr == MAP_FAILED) {
        perror(NULL);
        printf("Unable to open shared memory!\n");
        fflush(stdout);
        return errno;
    }

    printf("\nAll children returned, now displaying computed data:\n");
    fflush(stdout);

    for (int i = 1; i < argc; i++) {
        // Vector for element #i
        int* vec = shm_ptr + SIZE_PER_CHILD * (i - 1);
        printf("%d: ", vec[0]);
        for (int j = 0; j < vec[1]; j++)
            printf("%d ", vec[j + 2]);
        printf("\n");
        fflush(stdout);
    }

    munmap(shm_ptr, shm_size);
    shm_unlink(shm_collaz_name);

    return 0;
}