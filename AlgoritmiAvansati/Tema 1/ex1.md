# Knapsack

## A.

Complexitate: `O(N * K)`
Memorie: `O(K)`

```C++
int SumaMax(vector <int> w, int K)
{
    vector <bool> viz(K + 1);
    viz[0] = 1;
    for (auto i : w)
        for (int j = K; j >= i; j--)
            viz[j] |= viz[j - i];
    
    int ans = K;
    while (!viz[ans])
        ans--;
    return ans;
}
```

## B.


```C++
int K, ans = 0, act;
cin >> K;

while (cin >> act)
{
    if (ans + act <= K)
        ans += act;
    else if (ans < act)
        ans = act;
}

cout << "Answer is " << ans << '\n';
```

### Demonstractie

1. w[0] + ... + w[n] <= K
    -> Luam tot
2. w[0] + ... + w[n] > K
    -> ans >= K / 2:
        Fie avem un element >= K / 2 -> il luam
        Fie nu avem, deci niciodata nu ne blocam cu < K / 2