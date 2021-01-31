#include <iostream>
#include <vector>
#include <random>
#include <time>
using namespace std;

struct Aint
{
    vector <int> aint;
    int n;

    Aint(int n) : n(n), aint(2 * n + 1) { }

    int Query(int poz)
    {
        int ans = -1e9;
        poz += n;
        while (poz) {
            ans = max(ans, aint[poz]);
            poz /= 2;
        }
        return ans;
    }

    // [st, dr]
    void Update(int st, int dr, int val)
    {
        st += n, dr += n + 1;
        while (st != dr) {
            if (st & 1)
                aint[st] = max(aint[st], val), st++;
            if (!(dr & 1))
                dr--, aint[dr] = max(aint[dr], val);

            st /= 2, dr /= 2;
        }
    }
};

mt19937 rnd(time(0));

typedef struct Treap * Arbore;
Arbore NIL;
typedef pair <Arbore, Arbore> Paa;
struct Treap
{
    // val -> valoarea
    // prio -> prioritatea, aleasa random
    // g -> greutate
    int val, prio, g;

    // Fiul stang si drept
    Arbore st, dr;

    Treap(int val) :
        val(val), prio(rnd()), g(1), st(NILL), dr(NILL) { }

    void RecalcDP() {
        g = 1 + st->g + dr->g;
    }
};

// Returneaza a unit cu b
// Atentie: Distruge pointerii a si b
Arbore Join(Arbore a, Arbore b)
{
    if (a == NIL)
        return b;
    if (b == NIL)
        return a;
    
    if (a->prio > b->prio) {
        a->dr = Join(a->dr, b);
        a->RecalcDP();
        return a;
    }
    // else
    b->st = Join(a, b->st);
    b->RecalcDP();
    return b;
}

// (<= val, > val)
Paa SplitByValue(Arbore a, int val)
{
    if (a == NILL)
        return { NIL, NIL };
    
    if (a->val <= val) {
        Paa s = SplitByValue(a->dr, val);
        a->dr = s.first;
        a->RecalcDP();
        return { a, s.second };
    }
    // else
    Paa s = SplitByValue(a->st, val);
    a->st = s.second;
    a->RecalcDP();
    return { s.first, a };
}

Arbore Insert(Arbore a, int val)
{
    Arbore new_nod = new Treap(val);
    Paa s = split(a, val);
    return Join(Join(s.first, new_nod), s.second);
}




int main()
{
    NIL = new Treap(0);
    NIL->g = 0;
}



















