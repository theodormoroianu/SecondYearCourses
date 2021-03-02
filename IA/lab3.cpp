#include <bits/stdc++.h>
using namespace std;

int AStar(vector <vector <pair <int, int>>> adia, int start, set <int> dest, vector <int> estimari)
{
    vector <int> dist(adia.size(), 1e9);
    dist[start] = 0;

    priority_queue <tuple <int, int, int>> pq;
    pq.push(make_tuple(0, 0, start));

    while (!pq.empty()) {
        auto [estimare, cost, nod] = pq.top();
        pq.pop();

        if (dist[nod] < cost)
            continue;
        
        if (dest.find(nod) != dest.end())
            return cost;
    
        for (auto [vec, c] : adia[nod]) {
            if (dist[vec] > dist[nod] + c) {
                dist[vec] = dist[nod] + c;
                pq.push({ -dist[vec] - estimari[vec], dist[vec], vec });
            }
        }
    }

    return -1;
}

int main()
{
    int n, a, b;
    cin >> n >> a >> b;

    vector <vector <pair <int, int>>> adia(n + 1);
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= n; j++) {
            if (i % j == 0 || j % i == 0)
                adia[i].push_back({ j, abs(i - j) });
        }
    }

    set <int> ends = { b };
    vector <int> estimari(n + 1);
    for (int i = 0; i <= n; i++)
        estimari[i] = abs(i - b);

    cout << AStar(adia, a, ends, estimari) << '\n';
}