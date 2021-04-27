tata(ion, ana).

mama(elena, maria).
mama(elena, alina).
mama(elena, ana).

parinte(Par, Cop) :- tata(Par, Cop); mama(Par, Cop). % disjunctie

frate(A, B) :-
    (tata(Z, A), tata(Z, B));
    (mama(Z, A), mama(Z, B)).