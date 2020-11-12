#include <unistd.h>
#include <stdio.h>
#include <string.h>

// Parses an int value
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

int PrintSequence(int value)
{
    printf("%d: ", value);
    while (value != 1) {
        printf("%d ", value);
        if (value & 1) {
            int x = 3 * value + 1;
            if ((x - 1) / 3 != value) {
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

int main(int argc, char *argv[])
{
    printf("Starting main process: %d\n", getpid());
    fflush(stdout);

    // Number of calls.
    int count_calls = 0;

    for (int i = 1; i < argc; i++) {
        int value = ParseInt(argv[i]);
        if (value == -1) {
            printf("Invalid number entered!\n");
            return -1;
        }
        int child_pid = fork();
        if (child_pid < 0) {
            printf("Error while trying to fork: %d!\n", child_pid);
            return -1;
        }
        if (child_pid == 0) {
            printf("\nNew process: PID  = %d  PPID = %d\n", getpid(), getppid());
            int ret_code = PrintSequence(value);
            if (ret_code != 0) {
                printf("Process %d finished with an error!\n", getpid());
                return ret_code;
            }
            printf("Process %d finished\n", getpid());
            return 0;       
        }
        else
            count_calls++;
    }

    while (count_calls--) {
        int process_id, ret_code;
        process_id = wait(&ret_code);
        if (ret_code == 0)
            printf("Process %d returned normally to %d\n", process_id, getpid());
        else
            printf("Process %d returned to %d with status %d\n", process_id, getpid(), ret_code);
        fflush(stdout);
    }
    
    return 0;
}