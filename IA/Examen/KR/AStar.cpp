#include <bits/stdc++.h>
using namespace std;

using T = int;

int main()
{
    cout << "Reading input from file 'input.txt'...\n";
    cout << "Input should be in the following format:\n";
    cout << "  Start node  Destination node\n";
    cout << "  Number of nodes\n  Node1 Estimation1\n  Node2 Estimation2\n  ...\n";
    cout << "  Number of edges\n  Start1 Destination1 Cost1\n  ...\n";

    cout << "\nReading from input.txt ...\n";
    
    ifstream in("input.txt");
    ofstream out("edges.txt");
    string start_node, destination_node;
    in >> start_node >> destination_node;

    int nr_nodes;
    in >> nr_nodes;

    map <string, T> estimations;
    for (int i = 0; i < nr_nodes; i++) {
        string name;
        T est;
        in >> name >> est;
        estimations[name] = est;
    }

    map <string, vector <pair <string, T>>> edges;
    int nr_edges;
    in >> nr_edges;

    for (int i = 0; i < nr_edges; i++) {
        string from, to;
        T cost;
        in >> from >> to >> cost;
        edges[from].push_back({ to, cost });
    }


    // { node, g, f, from }
    // where f + est + g
    using Stare = tuple <string, T, T, string>;
    vector <Stare> open, closed;

    // Where does a node come from.
    map <string, pair <string, T>> backward_path;

    // Adaugam primul nod.
    open.push_back(make_tuple(start_node, 0, estimations[start_node], "nimeni"));

    // biggest stare to be the best one.
    // want smallest f to be the last
    // when equal in f, want biggest g.
    auto cmp = [&](Stare a, Stare b) {
        if (get<2>(a) != get<2>(b))
            return get<2>(a) > get<2>(b);
        return get<1>(a) < get<1>(b);
    };

    while (!open.empty()) {
        sort(open.begin(), open.end(), cmp);
        reverse(open.begin(), open.end());

        // Afisam cozile
        auto show_queue = [&](vector <Stare> coada, string name) {
            cout << "Coada " << name << ":\n";
            for (auto [node, g, f, from] : coada)
                cout << "   (" << "Nod:" << node << ", g:" << g << ", f:" << f << ", parinte:" << from << ")";
            cout << '\n';
        };

        static int pas = 1;
        cout << "Pas " << (pas++) << "\n";
        show_queue(open, "Open");
        show_queue(closed, "Closed");

        // re-dam reverse
        reverse(open.begin(), open.end());
        auto [node, g, f, from] = open.back();
        closed.push_back(open.back());
        open.pop_back();

        if (node == destination_node) {
            cout << "Am ajuns la nodul destinatie destinatie!\n";
            break;
        }

        cout << "Nodul pe care il consideram este " << node << ", cu g:" << g << ", si f:" << f << ". Incercam sa ii pargurgem vecinii.\n";
        
        for (auto [vec, cost] : edges[node]) {
            auto draw_edge = [&]() {
                out << node << "  ->  " << vec << "  g=" << g + cost << ", f=" << g + cost + estimations[vec] << "\n";
            };
            cout << "  Ne uitam la nodul " << vec << ", pentru ca avem muchia " << node << "->" << vec << " de cost " << cost << " ...\n";
            bool is_in_closed = false;
            int poz = 0;
            for (auto i : closed) {
                if (get<0>(i) == vec) {
                    is_in_closed = true;
                    break;
                }
                poz++;
            }

            Stare potential_state = make_tuple(vec, g + cost, estimations[vec] + g + cost, node);

            if (is_in_closed && cmp(potential_state, closed[poz])) {
                cout << "    Nodul " << vec << " este in lista closed cu cost mai bun, asa ca il ignoram.\n";
                continue;
            }
            else if (is_in_closed) {
                cout << "  Nodul " << vec << " este in Closed, dar cu un cost mai prost, asa ca il mutam in Open.\n";
                open.push_back(potential_state);
                backward_path[vec] = { node, cost };
                closed.erase(closed.begin() + poz);
                draw_edge();
                continue;
            }

            bool is_in_open = false;

            for (auto& [nod_lst, g_lst, f_lst, from_lst] : open) {
                if (nod_lst == vec) {
                    is_in_open = true;
                    if (f_lst > get<2>(potential_state) || (f_lst == get<2>(potential_state) &&
                            g_lst < get<1>(potential_state))) {
                        cout << "  " << vec << " este in Open, dar cu g:" << g_lst << ",f:" << f_lst << ", s-a modificat la ";
                        tie(nod_lst, g_lst, f_lst, from_lst) = potential_state;
                        cout << "g:" << g_lst << ",f:" << f_lst << "!\n";
                        backward_path[nod_lst] = { node, cost };
                        draw_edge();
                    }
                }
            }

            if (!is_in_open) {
                cout << "  " << vec << " nu este in Open, asa ca il adaug.\n";
                backward_path[vec] = { node, cost };
                open.push_back(potential_state);
                draw_edge();
            }
        }

        cout << '\n';
    }
    
    if (backward_path.find(destination_node) == backward_path.end()) {
        cout << "Nu a putut ajunge la destinatie!\n";
        exit(0);
    }
    T cost = 0;
    vector <string> path = { };
    for (string s = destination_node; backward_path.find(s) != backward_path.end(); ) {
        cost += backward_path[s].second;
        path.push_back(s);
        s = backward_path[s].first;
    }

    reverse(path.begin(), path.end());

    cout << "Drumul optim are un cost de " << cost << ", si este:\n";
    cout << start_node;
    for (auto i : path)
        cout << " -> " << i;
    cout << '\n';
    out.close();

}