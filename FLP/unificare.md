a, b contante =>
    a = b => Nu se poate
X variabila, XXXX cv =>
    X = XXXX => L-am gasit pe X (este XXXX)
h(A, B, C) = h(X, Y, Z) =>
    A = X
    B = Y
    C = Z

S1.1

Pas1:
    S: []
    R:
        p(a, x, h(g(y))) = p(z, h(z), h(u))

Pas2:
    S: []
    R:
        a = z
        x = h(z)
        h(g(y)) = h(u)

Pas3:
    S: 
        z = a
    R: 
        x = h(a)
        h(g(y)) = h(u)

Pas4:
    S: 
        z = a
        x = h(a)
    R: 
        h(g(y)) = h(u)

Pas5:
    S: 
        z = a
        x = h(a)
    R: 
        g(y) = u

Pas6:
    S: 
        z = a
        x = h(a)
        u = g(y)
    R: []

z = a
x = h(a)
u = g(y)



S1.2

Pas0:
    S: []
    R:
        g(y) = x 
        p(x, h(y), y) = p(g(z), b, z)
Pas1:
    S:
        x = g(y)
    R:
        p(g(y), h(y), y) = p(g(z), b, z)
Pas2:
    S:
        x = g(y)
    R:
        g(y) = g(z)
        h(y) = b
        y = z
Pas3:
    S:
        x = g(y)
        y = z
    R:
        g(z) = g(z)
        h(z) = b -- FAIL
        

S1.2

1. p(X,Y) :- q(X,Z), r(Z,Y).
2. p(X,X) :- s(X).
3. q(X,b).
4. q(b,a).
5. q(X,a) :- r(a,X).
6. r(b,a).
7. s(X) :- t(X,a).
8. s(X) :- t(X,b).
9. s(X) :- t(X,X).
10. t(a,b).
11. t(b,a).

?- p(X, X).

Voi simula algoritmul de cautare a solutiilor efectuat e prolog in felul urmator:
conditie_initiala
    \-> unificare_posibila_1
        :- conditii_de_satisfacut
            \-> unificare_posibila ....
    \-> unificare_posibila_2
        :- conditii_de_satisfacut
    ...

Algoritmul simuleaza backtracking-ul efectuat de Prolog, evidentiand si care sunt unificarile care au loc pe parcursul acestuia.

p(X, X)
    \-> p(X, X) = p(X, Y) (1) <=> Y = X
        :- q(X, Z), r(Z, X)
            \-> q(X, Z) = q(X,b) (3) <=> Z = b
                :- r(b, X)
                    \-> r(b, X) = r(b,a) (6) <=> X = a
                        => SUCCESS (X = a).
            \-> q(X, Z) = q(b,a) (4) <=> X = b, Z = a
                :- r(a, b).
                    \-> FAIL.
            \-> q(X, Z) = q(X, a) (5) <=> Z = a
                :- r(a, X)
                    \-> FAIL.
    \-> p(X, X) = p(X, X) (2) <=> X = X
        :- s(X)
            \-> s(X) = s(X) (7) <=> X = X
                :- t(X, a)
                    \-> t(X, a) = t(b, a) (11) <=> X = b
                        \-> SUCCESS (X = b).
            \-> S(X) = s(X) (8) <=> X = X
                :- t(X, b)
                    \-> t(X, b) = t(a, b) (10) <=> X = a
                        \-> SUCESS (X = a).
            \-> s(X) = s(X) (9) <=> X = X
                :- t(X, X)
                    \-> FAIL.



p(X, X)
    \-> Aplicam (1):
        Unificam p(X, X) cu p(X, Y): Y = X.
        => q(X, Z) ^ r(Z, X)
            \-> Aplicam (3):
                Unificam q(X, Z) cu q(Z, b): Z = b.
                => r(b, X).
                    \-> Aplicam (6).
                        Unificam r(b, X) cu r(b, a): X = a. SUCCESS.
            \-> Aplicam (4):
                Unificam q(X, Z) cu q(b, a): X=b, Z=a.
                => r(a, b).
                    \-> FAIL.
            \-> ...


S1.3



  /---------------------------------------------------
 /   /----------------------------------
/   /   /-------    /-----                 /----------
λx.(λy.(λx.x + z) ((λx.x x) (x + y) + x)) (λz. x  y  z)
 1   2   3 4   5     6 7 8   9  10   11    12 13 14 15

λx.(x x)   <=> Prolog:     x       :-       x                  y
                        legatura    variabila legata   variabila libera
λx.(x x) y  ->  y y 
  aici x din paranteza sunt variabile legate de variabila de legatura (de argument)
  
variabile libere 

 
 x1 = argument  (de legatura)
 y2 = legatura
 x3 = legatura
 x4 = legata de x3
 z5 = variabila libera
 x6 = legatura 
 x7 = legata de x6
 x8 = legata de x6
 x9 = legat de x1
 y10 = legat de y2
 x11 = legat de x1
 z12 = de legatura
 x13 = legat de x1
 y14 = variabila libera
 z15 = legat de z12


S1.4

empty :: list X
cons :: X -> List X -> List X
uncons :: list X -> Y -> (X -> list X -> Y) -> Y


type(_, empty, list(T)) :-
    is_type(T).
type(Gamma, cons(Head, Tail, List), list(Tip)) :-
    type(Gamma, Head, Tip),
    type(Gamma, Tail, list(Tip)),
    is_type(Tip).
type(Gamma, uncons(Lista, IfEmpty, IfNotEmpty), TipY) :-
    type(Gamma, Lista, list(TipX)),
    type(Gamma, IfEmpty, TipY),
    type(Gamma, IfNotEmpty, TipX -> list(TipX) -> TipY).


?????
```python
def uncons(lista, if_empty, if_not_empty):
    if lista == []:
        return if_empty
    head, tail = lista[0], lista[1:]
    return if_not_empty(head, tail)
```

<if (0 <= i, i = i + -4; while (0 <= i, { i = i + -4}), skip), i = 3>
il scoatem pe i din env.
<if (0 <= 3, i = i + -4; while (0 <= i, { i = i + -4}), skip), i = 3>
Il comparam pe 0 cu 3.
<if (true, i = i + -4; while (0 <= i, { i = i + -4}), skip), i = 3>
Executam if-ul.
<i = i + -4; while (0 <= i, { i = i + -4}), i = 3>
Evaluam i.
<i = 3 + -4; while (0 <= i, { i = i + -4}), i = 3>
facem suma.
<i = -1; while (0 <= i, { i = i + -4}), i = 3>
Updatam i.
<while (0 <= i, { i = i + -4}), i = -1>
Transformam while in if.
<if (0 <= i, i = i + -4; while (0 <= i, { i = i + -4}), skip), i = -1>
il evaluam pe i.
<if (0 <= -1, i = i + -4; while (0 <= i, { i = i + -4}), skip), i = -1>
Executam comparatia
<if (false, i = i + 4; while (0 <= i, { i = i + -4}), skip), i = -1>
executam if.
<skip, i = -1>
exetuam skip-ul.
<i = -1>



## Cancer din cv curs


# unificare

    f(X, g(Y)) = f(h(Y), g(X))
   
    step0:
        S: []
        R:
            f(X, g(y)) = f(h(Y), g(X))
    step1:
        S: []
        R:
            X = h(Y)
            g(Y) = g(X)
    step2:
        S:
            X = h(Y)
        R:
            g(Y) = g(h(Y))
    step3:
        S:
            X = h(Y)
        R:
            Y = h(Y)
    step4:
        S:
            X = h(Y)
        R: []
        Incercam sa il scoatem pe Y = h(Y), Y \in h(Y) => Ciclu, FAIL.


# variabile libere / variabile legate


\ x1 . (\ y2 . (\ x3 . x + z) ((\x . x x) (x + y) + x) ) (\ z . x y z)



\ x(1) . (\ y(2) . (\ x(3) . x(4) + z(5)) ((\x(6) . x(7) x(8)) (x(9) + y(10)) + x(11)) ) (\ z(12) . x(13) y(14) z(15))

x(13) legat de x(1)
y(14) liber
z(15) legat de z(12)
x(4) legat de x(3)
z(5) liber
x(7) legat de x(6)
x(8) legat de x(6)
x(9) legat de x(1)
y(10) legat de y(2)
x(11) legat de x(1)




# Descrieți evoluția expresiei de mai jos prin aplicarea de trei ori a regulii de beta reducție

Strict order (bootom-up)

\ x . (\ y . (\ x . x + y) ((\x . x x) (x + y) + x) ) (\ z . x y z)

\ x . (\ y . (\ x . x + y) (((x + y) + x) ((x + y) + x))) (\ z . x y z)

\ x . (((((x +  (\ z . x y z)) + x) ((x +  (\ z . x y z)) + x)) +  (\ z . x y z)))



(\x . \y . x) y

--beta--gresit-->
\y . y = id

--alpha-->
(\x . \z . x) y

--beta-->
\z . y = const y





f a b - c

\ x . (\ y . (\ x . x + y) ((\x . x x) (x + y) + x) ) (\ z . x y z)

--beta-->

\ x . (\ y . (\ x . x + y) ((x + y) (x + y) + x) ) (\ z . x y z)

--beta-->

\ x . (\ y . ((x + y) (x + y) + x) + y ) (\ z . x y z)

--beta-->

\ x . ((x + (\ z . x y z)) (x + (\ z . x y z)) + x) + (\ z . x y z) 

Normal order (topmost, leftmost)

\ x . (\ y . (\ x . x + y) ((\x . x x) (x + y) + x) ) (\ z . x y z)

--beta--> (gresit)

\ x . (\ x . x + (\ z . x y z)) ((\x . x x) (x + (\ z . x y z)) + x) 

corect: mai intai redenumesc x


\ x . (\ y . (\ x . x + y) ((\x . x x) (x + y) + x) ) (\ z . x y z)

==alpha==

\ x . (\ y . (\ a . a + y) ((\x . x x) (x + y) + x) ) (\ z . x y z)

--beta-->

\ x . (\ a . a + (\ z . x y z)) ((\x . x x) (x + (\ z . x y z)) + x)

--beta-->

\ x . ((\x . x x) (x + (\ z . x y z)) + x) + (\ z . x y z)

--beta-->

\ x . ((x + (\ z . x y z)) (x + (\ z . x y z)) + x) + (\ z . x y z)




# Are expresia de mai jos tip sau nu. Dacă da, scrieți tipul. Dacă nu, argumentați de ce nu.

e := 




--beta-->

e := \ x . (\ y . (\ x . x + z) (((x + y) (x + y)) + x) ) (\ z . x y z)
                                   \int/   \int/

Int nu este o functie -> nu poate primi un alt int ca paramentru FAIL.

Pentru ca e să aibă tip, orice subexpresie a lui e trebuie să aibă tip.

În particular, (\x . x x) (x + y) trebuie să aibă tip.
  - (x + y) trebuie sa aiba tip, care nu poate fi decât int (regula lui +)
  - din regula pentru aplicare, (\x . x x) (x + y) are tip t dacă (\x . x x) are tipul int -> t
    dar din regula pentru lambda, (\x . x x) are tipul int -> t daca din x : int putem deduce că x x : t
    dar, din regula pentru aplicare x x : t dacă x are tipul t1 -> t și x are tipul t1
    de unde int = int -> t    (imposibil, pentru că int și -> sunt constructori)


e := \ x . (\ y . (\ x . x:int + z:int):int->int ((\x . x:?int x:?int):?int->int (x:int + y:int):int + x:int) ) (\ z . x y z)



# Fie programul IMP  Pgm ::=  "if x >= y then max := x else max := y" și starea sigma ::= "x |-> 3, y |-> 5". Descrieți următoarele cinci tranziții într-un pas ale configurației de execuție < Pgm, sigma >  (indicând axioma folosită).


<if x >= y then max := x else max := y, x |-> 3, y |-> 5>
Il evaluam pe x.
<if 3 >= y then max := x else max := y, x |-> 3, y |-> 5>
Il evaluam pe y.
<if 3 >= 5 then max := x else max := y, x |-> 3, y |-> 5>
Evaluam 3 >= 5.
<if false then max := x else max := y, x |-> 3, y |-> 5>
Evaluam if-ul.
<max := y, x |-> 3, y |-> 5>
Inlocuim pe y.
<max := 5, x |-> 3, y |-> 5>
Executam operatia.
<, max |-> 5, x |-> 3, y |-> 5>
























   < if x >= y then max := x else max := y  ,   {x |-> 3, y |-> 5} > 
--ax. variabile-->
   < if 3 >= y then max := x else max := y  ,   {x |-> 3, y |-> 5} > 
--ax. variabile-->
   < if 3 >= 5 then max := x else max := y  ,   {x |-> 3, y |-> 5} > 
--ax. >=-->
   < if false then max := x else max := y  ,   {x |-> 3, y |-> 5} > 
--ax. if-->
   < max := y  ,   {x |-> 3, y |-> 5} > 
--ax. variabile-->
   < max := 5  ,   {x |-> 3, y |-> 5} > 


# Dat fiind programul Prolog Pgm, scrieți un query (de forma ...) care produce rezultatele ...


# Lambda-calcul: Care este forma normală a expresiei: ....



# Adăugați la limbajul IMP "++ x" ca expresie de incerementare a identificatorului x și scrieți regulile de execuție într-un pas care trebuie adăugate sau modificate pentru a putea da semantică lui ++




λx.(λi0.(λi1.i1 + z) ([λi1.i1 i1] [x + i0] + x)) (λi0.x y i0)
λx.(λi0.i0 + z) ((λi0.i0 i0) (x + [λi0.x y i0]) + x)
λx.(λi0.i0 i0) (x + [λi0.x y i0]) + x + z
λx.(λi0.i0 i0) (x + (λi0.x y i0)) + x + z
λx.x + (λi0.x y i0) (x + (λi0.x y i0)) + x + z
λx.x + (x y) (x + (x y)) + x + z