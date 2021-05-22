% Ex 1
% fib(0, 1).
% fib(1, 1).

% fib(N, X) :-
%     N1 is N - 1,
%     N2 is N - 2,
%     fib(N1, X1),
%     fib(N2, X2),
%     X is X1 + X2.

fibf(0, _, X, X).

fibf(N, FaM1, Fa, Y) :-
    N > 0,
    FaP1 is Fa + FaM1,
    NM1 is N - 1,
    fibf(NM1, Fa, FaP1, Y).


fib_calc(K, A) :- fibf(K, 0, 1, A).

