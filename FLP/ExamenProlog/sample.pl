tail([], []).
tail([_ | T], T).

finish([], []).
finish(T, T).
finish([_ | A], T) :- finish(A, T).

append([], T, T).
append([H | T], L, [H | R]) :- append(T, L, R).

fibb(0, H, _, H) :- !.
fibb(N, H, T, X) :-
    Sum is H + T,
    NM1 is N - 1,
    fibb(NM1, Sum, H, X).

compute_fib(N, X) :- fibb(N, 1, 0, X).

print_line(0, _).
print_line(N, C) :-
    write(C),
    NM1 is N - 1,
    print_line(NM1, C).

print_square(0, _, _).
print_square(Left, N, C) :-
    print_line(N, C),
    nl,
    LeftM1 is Left - 1,
    print_square(LeftM1, N, C).

scalarMult(_, [], []).
scalarMult(A, [H1 | T1], [H2 | T2]) :-
    H2 is A * H1,
    scalarMult(A, T1, T2).

dot([], [], 0).
dot([H1 | T1], [H2 | T2], Ans) :-
    dot(T1, T2, Rest),
    Ans is Rest + H1 * H2.

max([X], X).
max([H | T], M) :-
    max(T, N),
    N > H -> M = N;
             M = H. 

last_element(X, [X]).
last_element(X, [_ | T]) :-
    last_element(X, T).

remove_last_element([_], []).
remove_last_element([H | T1], [H | T2]) :-
    remove_last_element(T1, T2).

% reverse_list([], []).
% reverse_list([H1 | T1], L2) :-
%     length(L2, X),
%     length(T1, Y),
%     X =:= Y + 1,    
%     last_element(H1, L2),
%     remove_last_element(L2, L2p),
%     reverse_list(T1, L2p).

palindrome(X) :-
    reverse_list(X, XRev),
    X == XRev.

reverse_list_internal(X, [], X).
reverse_list_internal(X, [H | T], A) :-
    reverse_list_internal(X, T, [H | A]).

reverse_list(A, B) :-
    reverse_list_internal(A, B, []).


relatie(h(A), g(B)) :-
    integer(A),
    integer(B).
