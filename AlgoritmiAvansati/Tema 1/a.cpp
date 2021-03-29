#include <bits/stdc++.h>
using namespace std;

std::vector<bool>::reference& operator |= (std::vector<bool>::reference& a, std::vector<bool>::reference& a)
{
    if (b)
       a = true;
    return a;
}

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

int main()
{
    
}
