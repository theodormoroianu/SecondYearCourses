plus(0, X, X).
plus(S(Y), X, S(Z)) :- plus(Y, X, Z).

mul(0, _, 0).
mul()