#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <pthread.h>
#include <string.h>

/**
 * Function reverses array `vec`, and
 * stores answer in `ans`.
 * Size of `vec` is assumed as
 * strlen(vec).
 */
void* ReverseArray(void* v_vec)
{
    char* vec = v_vec;

    int l = strlen(vec);
    char* ans = malloc(l + 1);
    ans[l] = 0;

    for (int i = 0; i < l; i++)
        ans[l - i - 1] = vec[i];

    return ans;
}

int main(int argc, char* args[])
{
    // Salveaza strigul.
    char* my_str = 0;

    // Am primit prin argumente.
    if (argc > 2) {
        int l_act = 0, l_total = 0;
        for (int i = 1; i < argc; i++)
            l_total += strlen(args[i]) + 1;
        
        my_str = malloc(l_total);

        for (int i = 1; i < argc; i++) {
            int l = strlen(args[i]);
            memcpy(my_str + l_act, args[i], l);
            l_act += l + 1;
            my_str[l_act - 1] = ' ';
        }
        my_str[l_act - 1] = 0;
    }
    else {
        // Citesc inputul.
        printf("Care este lungimea sirului pe care doriti "
           "sa il inversati?\n $ ");
        int n;
        scanf("%d", &n);
        my_str = malloc(n + 1);
        my_str[n - 1] = 0;

        printf("Care este stringul?\n");
        printf(" $ ");

        scanf("\n");
        for (int i = 0; i < n; i++)
            scanf("%c", my_str + i);
        printf("\n");
    }

    // Creez si lansez threadul.
    pthread_t thr;
    if (pthread_create(&thr, NULL, ReverseArray, my_str)) {
        perror(NULL);
        return errno;
    }
    
    char* ans;

    // Prind threadul.
    if (pthread_join(thr, (void**)&ans)) {
        perror(NULL);
        return errno;
    }

    // Afisez raspunsul.
    printf("Sirul rasturnat este:\n\"%s\"\n", ans);
    free(ans);

    return 0;
}