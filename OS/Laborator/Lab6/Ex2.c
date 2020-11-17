#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <pthread.h>
#include <string.h>

#define D_MAX 1000

/**
 * Array storing matrices.
 * Mat[0] and mat[1] are initial matrices.
 * Mat[2] stores the answer.
 */
int mat[3][D_MAX][D_MAX];
pthread_t threads[D_MAX][D_MAX];
int N, M, K;

/**
 * Function computing reversal.
 */
void* ReverseArray(void* v_args)
{
    // Convert pointer to interger.
    int* args = v_args;

    // Extract informations from args.
    int x = args[0], y = args[1];

    // Computing answer.
    int ans = 0;
    for (int i = 0; i < M; i++)
        ans += mat[0][x][i] * mat[1][i][y];

    // Storing the answer.
    mat[2][x][y] = ans;

    free(v_args);
}

/**
 * Functie care citeste o matrice.
 * Functia returneaza prin pointeri dimensiunea acesteia.
 */
int ReadMatrix(int c, int* H, int* W)
{
    printf("Care sunt dimensiunile matricei?\n $ ");
    scanf("%d%d", H, W);

    printf("Care sunt valorile matricei?\n");
    for (int i = 0; i < *H; i++) {
        printf(" $ ");
        for (int j = 0; j < *W; j++)
            scanf("%d", mat[c][i] + j);
    }

    return 0;
}

int main(int argc, char* args[])
{
    // Citesc inputul.
    int n1, n2, m1, m2;
    if (ReadMatrix(0, &n1, &m1) ||
            ReadMatrix(1, &n2, &m2)) {
        printf("Nu s-a putut citi inputul!\n");
        return -1;        
    }

    // Nu se potrivesc matricele.
    if (m1 != n2) {
        printf("Dimensiunile nu se potrivesc (%d != %d)!\n", n2, m1);
        return -1;
    }

    N = n1, M = m1, K = m2;

    // Lansez threadurile.
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < K; j++) {
            // Creez argumentele.
            int* args = malloc(2 * sizeof args);
            args[0] = i, args[1] = j;

            // Apelez threadul.
            if (pthread_create(threads[i] + j, NULL, ReverseArray, args)) {
                perror(NULL);
                return errno;
            }
        }
    }

    // Am lansat toate threadurile, acum trebuie sa
    // ma joinuiesc cu toate.
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < K; j++) {
            // Prind threadul.
            if (pthread_join(threads[i][j], NULL)) {
                perror(NULL);
                return errno;
            }
        }
    }

    // Afisez raspunsul.
    printf("Produsul matricelor:\n");
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < K; j++)
            printf(" %d", mat[2][i][j]);
        printf("\n");
    }

    return 0;
}