#include <bits/stdc++.h>
using namespace std;

using State = vector <vector <int>>;


/**
 * Returns an estimated value for passing from state a to state b.
 * The value is the sum of pairwise LCPs over 2.
 */
int Estimate(State a, State b)
{
    assert(a.size() == b.size());
    int count = 0, good = 0;
    
    for (int i = 0; i < (int)a.size(); i++) {
        count += a[i].size();
        for (int j = 0; j < (int)a[i].size() && j < (int)b[i].size(); j++) {
            if (a[i][j] == b[i][j])
                good++;
            else
                break;
        }
    }

    return (count - good) / 2;
}

/**
 * Computes all possible transitions frp,
 * a given state a.
 */
vector <State> Transitions(State a)
{
    vector <State> ans;
    for (int i = 0; i < (int)a.size(); i++) {
        if (a[i].size() == 0)
            continue;
        for (int j = 0; j < (int)a.size(); j++) {
            if (i == j)
                continue;
            ans.push_back(a);
            ans.back()[j].push_back(ans.back()[i].back());
            ans.back()[i].pop_back();
        }
    }
    return ans;
}

/**
 * Returns the minimal cost for passing from the state
 * `init` to the state `final`, along the partial transformations
 * from init to final.
 */
pair <int, vector <State>> AStar(State init, State final)
{
    map <State, int> cost;
    map <State, State> from;
    cost[init] = 0;

    // { -(dist + est), dist, node }
    priority_queue <tuple <int, int, State>> q;
    q.push(make_tuple(0, 0, init));

    int processed = 0;

    while (!q.empty()) {
        auto [expected, until, state] = q.top();
        q.pop();
        if (cost[state] != until)
            continue;

        processed++;

        if (state == final)
            break;

        auto urm = Transitions(state);
        for (auto urm_state : urm) {
            if (cost.find(urm_state) == cost.end() || cost[urm_state] > cost[state] + 1) {
                cost[urm_state] = cost[state] + 1;
                from[urm_state] = state;
                q.push(make_tuple(-(cost[urm_state] + Estimate(urm_state, final)),
                                  cost[urm_state],
                                  urm_state));
            }
        }
    }

    cout << "Visited " << processed << " states!\n";

    if (cost.find(final) == cost.end())
        return { -1, { } };
    
    vector <State> ans = { final };

    while (ans.back() != init)
        ans.push_back(from[ans.back()]);

    reverse(ans.begin(), ans.end());
    return { cost[final], ans };
}

int main()
{
    // Read N
    int n;
    cout << "Care gramezi exista ? ";
    cin >> n;

    auto read_state = [&](string mesaj) {
        cout << mesaj;
        vector <vector <int>> ans;
        for (int i = 0; i < n; i++) {
            cout << "Cate obiecte exista in gramada #" << i << "? ";
            int x;
            cin >> x;
            vector <int> v(x);
            cout << "Introduceti obiectele:\n";
            for (auto& j : v)
                cin >> j;
            ans.push_back(v);
        }
        return ans;
    };

    auto init = read_state("Starea initiala:\n");
    auto final = read_state("Starea finala:\n");
    
    
    auto [cost, drum] = AStar(init, final);

    if (cost < 0) {
        cout << "Nu exista solutie!\n";
        return 0;
    }

    cout << "Solutia are un cost de " << cost << ":\n";
    for (auto v : drum) {
        cout << "[ ";
        for (auto i : v) {
            cout << "{ ";
            for (auto j : i)
                cout << j << " ";
            cout << "} ";
        }
        cout << "]\n";
    }

    return 0;
}