#include <unistd.h>
#include <stdio.h>
#include <string.h>

int ParseInt(char *arr)
{
    int ans = 0;
    int l = strlen(arr);
    if (l == 0)
        return -1;

    for (int i = 0; i < l; i++) {
        if (arr[i] > '9' || arr[i] < '0')
            return -1;
        ans = 10 * ans + arr[i] - '0';
    }
    return ans;
}

int Solver(int value)
{
    printf("%d ", value);
    fflush(stdout);

    if (value == 1)
        return 0;

    int pid = getpid();
    int child = fork();

    // Error while forking.
    if (child < 0)
        return child;
    if (child == 0) {
        if (value & 1)
            Solver(3 * value + 1);
        else
            Solver(value >> 1);
    }
    else {
        int status;
        wait(&status);
        return status;
    }
}

int main(int argc, char *argv[])
{
    if (argc != 2) {
        printf("Unable to find parameter!\n");
        return -1;
    }
    
    int value = ParseInt(argv[1]);
    if (value == -1) {
        printf("Received value is not an int!\n");
        return -1;
    }

    printf("%d: ", value);
    fflush(stdout);

    int status = Solver(value);

    if (status != 0) {
        printf("Error: %d\n", status);
    }

    return 0;
}