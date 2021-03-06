# Load Balance

## 1

### A

1.1 aproximativ:
    Daca solutia optima este 100, atunci noi avem cel mult 110

90 20 60 30

OPT: { 60, 30 }, { 90, 20 } -> 110
ALG: { 90, 30 }, { 60, 20 } -> 120  

120 < 1.1 * 110 = 121


### B

A B
while (b >= 110) {
    x <- b
    x -> a
}
OPT < 110
ALG = 120 -> Buseala

## 2

### A

Da:
Se citeste un numar a, si se cere valoarea minima al unui x >= a.
OPT = a
ALG1 = a
ALG2 = 4 * a

-> pentru a = 1, avem AGL2 > 2 * AGL1

### B

DA:
OPT <= ALG2 <= 4 * OPT
OPT <= ALG1 <= 2 * OPT

ALG1 <= 2 * OPT <= 2 * ALG2
ALG1 <= 2 * AGL2.


## 3

Lema 1:
    Niciodata nu o sa adaugam un element intr-un morman cu cel putin OPT elemente.
Demonstratie:
    Din principiul cutiei, mereu exista cel putin un morman cu < OPT elemente. Il alemgen cu greedy pe acela.

Fie X primul element pe care il adaugam la un morman care il face pe acesta sa depaseasa OPT.
1. X nu exista. Asta inseamna ca niciodata nu depasim OPT, deci suntem chiar 1 aprox.
2. X este al k-lea element.
    * K > m: daca K < m, exista cel putin un morman gol in care ne-am putea adauga fara overflow.
    * X <= OPT / 2: Daca X > OPT / 2, avem cel putin K elemente > OPT / 2, deci cel putin m + 1 elemente > OPT / 2, deci din principiul cutiei cel putin doua din ele sunt in aceeasi cutie in OPT. Contradictie.
    * Din Lema 1, niciodata nu o sa adaugam ceva intr-un morman care a depasit OPT, si adaugam mereu elemente <= OPT / 2

=> Niciodata nu avem un morman cu >= 3 / 2 * OPT.

