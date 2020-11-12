#include <unistd.h>
#include <stdio.h>

int main()
{
    int parent_pid = getpid();
    int child_pid = fork();

    if (child_pid < 0) {
        // Error
        printf("Error while forking: %d\n", child_pid);
        return -1;
    }

    if (child_pid == 0) {
        // I am the child.
        char *argv[] = { "ls", NULL };
        execve("/bin/ls", argv, NULL);
        
        // If I get here there is an error.
        perror(NULL);
    }
    else {
        printf("My PID = %d, Child PID = %d\n", parent_pid, child_pid);
        fflush(stdout);
        wait(NULL);
    }
    return 0;
}
