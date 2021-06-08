#include <bits/stdc++.h>

#define N_MAX 100005
#define INF 1000000000

using namespace std;

ifstream fin("input.txt");
ofstream fout("data.out");

int N;
int H[N_MAX];
char C[N_MAX];
int G[N_MAX];
int F[N_MAX];
int T[N_MAX];


int find(char x) {
    for(int i = 1; i <= N; i++) {
        if(C[i] == x) {
            return i;
        }
    }
}

vector <pair <int, int> > Gr[N_MAX];
vector < pair <int, pair <int, int> > > Q;
vector < pair <int, pair <int, int> > > CLOSED;

bool inClosed(int x) {
    for(auto it : CLOSED) {
        if(it.first == x) {
            return true;
        }
    }
    return false;
}

void insert(pair <int, pair <int, int> > p) {
    Q.push_back(p);
    for(int i = Q.size() - 2; i >= 0; i--) {
        if(Q[i].second.first > Q[i + 1].second.first) {
            swap(Q[i], Q[i + 1]);
        }
        if(Q[i].second.first == Q[i + 1].second.first) {
            if(Q[i].second.second < Q[i + 1].second.second) {
                swap(Q[i], Q[i + 1]);
            }
        }
    }
}

int main()
{
    char e, fi;
    fin >> e >> fi;

    fin >> N;
    for(int i = 1; i <= N; i++) {
        fin >> C[i] >> H[i];
    }

    int E = find(e);
    int FI = find(fi);

    int q;
    fin >> q;

    char x, y;
    int cost;
    while(fin >> x >> y >> cost) {
        int X = find(x);
        int Y = find(y);
        Gr[X].push_back(make_pair(Y, cost));
    }

    for(int i = 1; i <= N; i++) {
        G[i] = INF;
    }

    G[E] = 0;
    T[E] = E;
    F[E] = G[E] + H[E];
    Q.push_back({E, {F[E], G[E]}});


    fout << "OPEN = {\n";

    for(auto it : Q) {
        fout << C[it.first] << " cu g = " << it.second.second << " si f = " << it.second.first << " tatal in arbore este " << C[T[it.first]] << "\n";
    }

    fout << "}\n";

    fout << "CLOSED = {\n";

    for(auto it : CLOSED) {
        fout << C[it.first] << " cu g = " << it.second.second << " si f = " << it.second.first << " tatal in arbore este " << C[T[it.first]] << "\n";
    }

    fout << "}\n";


    while(!Q.empty()) {
        int node = Q[0].first;
        int f = Q[0].second.first;
        int g = Q[0].second.second;
        if(inClosed(node)) {
             Q.erase(Q.begin());
             continue;
        }

        if(node == FI) {
            fout << "Am ajuns in " << C[node] << " cu g = " << g << " si f = " << f << " tatal in arbore este " << C[T[node]] << "\n";
            return 0;
        }
        fout << "Ne extindem din nodul " << C[node] << " cu g = " << g << " si f = " << f << " tatal in arbore este " << C[T[node]] << "\n";
        CLOSED.push_back(Q[0]);
        Q.erase(Q.begin());
        for(auto it : Gr[node]) {
            if(!inClosed(it.first)) {
                T[it.first] = node;
                insert({it.first, {H[it.first] + g + it.second, g + it.second}});
            }
        }
        fout << "OPEN = {\n";
        for(auto it : Q) {
            fout << C[it.first] << " cu g = " << it.second.second << " si f = " << it.second.first << " tatal in arbore este " << C[T[it.first]] << "\n";
        }

        fout << "}\n";

        fout << "CLOSED = {\n";

        for(auto it : CLOSED) {
            fout << C[it.first] << " cu g = " << it.second.second << " si f = " << it.second.first << " tatal in arbore este " << C[T[it.first]] << "\n";
        }

        fout << "}\n";
    }
    return 0;
}