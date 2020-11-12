#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Parseaza numere din stringuri
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

int main(int argc, char *argv[])
{
    // Trebuie sa primesc exact doua argumente
    if (argc != 2) {
        printf("Unable to find parameter!\n");
        return -1;
    }
    
    int parent_pid = getpid();
    int child_pid = fork();

    if (child_pid < 0) {
        // Error forking
        printf("Error while forking: %d\n", child_pid);
        return -1;
    }

    if (child_pid == 0) {
        // Sunt fiul, asa ca parsez numarul, si afisez secventa
        int value = ParseInt(argv[1]);
        if (value == -1) {
            printf("Received value is not an int!\n");
            return -1;
        }

        printf("%d: ", value);
        while (value != 1) {
            printf("%d ", value);
            if (value & 1) {
                // Could potentially cause overflow, so need to check
                int x = 3 * value + 1;
                if (value != (x - 1) / 3) {
                    printf("Overflow!\n");
                    return -1;
                }
                value = 3 * value + 1;
            }
            else
                value >>= 1;
        }
        printf("1\n");
        return 0;
    }
    else {
        int ret_status = 0;
        wait(&ret_status);
        printf("Child %d finished.\n", child_pid);
        if (ret_status != 0)
            printf("Error in child process: %d\n", ret_status);
    }
    return 0;
}