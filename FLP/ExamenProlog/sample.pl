bigger(elefant, horse).
bigger(horse, donkey).
bigger(donkey, mouse).
bigger(house, elefant).

is_bigger(A, B) :- bigger(A, B).
is_bigger(A, B) :- bigger(A, X), is_bigger(X, B).