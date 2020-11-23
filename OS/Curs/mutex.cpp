#include <bits/stdc++.h>
using namespace std;


int main()
{
    atomic_bool my_bool = 0;

    while (!my_bool.exchange(true))
}