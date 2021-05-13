%---------------------------------
% Jon Snow and Daenerys Targaryen
%---------------------------------

male(rickardStark).
male(eddardStark).
male(brandonStark).
male(benjenStark).
male(robbStark).
male(aerysTargaryen).
male(rhaegarTargaryen).


%---------------------------

female(lyarraStark).
female(catelynStark).
female(lyannaStark).
female(sansaStark).
female(aryaStark).
female(rhaellaTargaryen).
female(eliaTargaryen).

%------------------------

parent_of(rickardStark,eddardStark).
parent_of(rickardStark,brandonStark).
parent_of(rickardStark,benjenStark).
parent_of(rickardStark,lyannaStark).
parent_of(lyarraStark,eddardStark).
parent_of(lyarraStark,brandonStark).
parent_of(lyarraStark,benjenStark).
parent_of(lyarraStark,lyannaStark).

parent_of(eddardStark,robbStark).
parent_of(eddardStark,sansaStark).
parent_of(eddardStark,aryaStark).
parent_of(eddardStark,branStark).
parent_of(eddardStark,rickonStark).
parent_of(catelynStark,robbStark).
parent_of(catelynStark,sansaStark).
parent_of(catelynStark,aryaStark).
parent_of(catelynStark,branStark).
parent_of(catelynStark,rickonStark).

parent_of(aerysTargaryen,rhaegarTargaryen).
parent_of(aerysTargaryen,viserysTargaryen).
parent_of(aerysTargaryen,daenerysTargaryen).

parent_of(rhaellaTargaryen,rhaegarTargaryen).
parent_of(rhaellaTargaryen,viserysTargaryen).
parent_of(rhaellaTargaryen,daenerysTargaryen).

parent_of(rhaegarTargaryen,jonSnow).
parent_of(lyannaStark,jonSnow).

parent_of(rhaegarTargaryen,aegonTargaryen).
parent_of(rhaegarTargaryen,rhaenysTargaryen).

parent_of(eliaTargaryen,aegonTargaryen).
parent_of(eliaTargaryen,rhaenysTargaryen).


%---------------------

father_of(Father, Child)
    :- parent_of(Father, Child), male(Father).

mother_of(Mother, Child)
    :- parent_of(Mother, Child), female(Mother).

grandfather_of(Grandfather, Child)
    :- father_of(Grandfather, X), parent_of(X, Child).

grandmother_of(Grandfather, Child)
    :- mother_of(Grandfather, X), parent_of(X, Child).

sister_of(Sister, Person)
    :- female(Sister), parent_of(X, Sister), parent_of(X, Person).

brother_of(Sister, Person)
    :- male(Sister), parent_of(X, Sister), parent_of(X, Person).

aunt_of(Aunt, Person)
    :- sister_of(Aunt, X), parent_of(X, Person).

uncle_of(Aunt, Person)
    :- brother_of(Aunt, X), parent_of(X, Person).

ancestor_of(Ancestor, Person)
    :- parent_of(Ancestor, Person)
    ;  parent_of(Ancestor, X), ancestor_of(X, Person).

human(X) :- male(X); female(X).

not_parent_of(Parent, Child)
    :- human(Parent), \+ parent_of(Parent, Child).

ancestor_not_parent(Ancestor, Child)
    :- ancestor_of(Ancestor, Child), \+ parent_of(Ancesotr, Child).

