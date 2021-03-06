# TSP

## 1

### A

Presupunem ca problema nu ar fi NP-Hard.
Fie un graf `G`.
Ne construim un al graf `G'`, unde intre oricare doua noduri `a` si `b` adaugam muchie de cost `1` daca exista muchia `(a, b)` in `G` si de cost `2` daca nu.

Daca TSP ne-ar da un cost de `N` pe `G'`, atunci stim ca avem un ciclu hamiltonian.
Daca exista un ciclu hamiltonian in `G`, atunci exista si un TSP de cost `N`. Asadar existenta unui ciclu hamiltonian si al unui TSP de cost `N` sunt echivalente.

Ergo, P = NP contradictie.

### B

Cum avem numai costuri de 1 si 2, orice 3 muchii respecta inegalitatea triunghiului.

### C

Fie un graf `G` cu `N` noduri complet cu toate muchiile de cost `1`.
In mod evident, TSP ne da raspunsul `N`.
Ne alegem ca APM o stea centrata in `1`. Algoritmul din curs pargurge fiecare din cele `N - 1` muchii din APM de doua ori, deci da raspunsul `2 * (N - 1) = 2 * N - 2`.

In mod evident, `2 * N - 2 > 3 / 2 * N` pentru un `N` suficient de mare.

## 2


### A

Fie cele `4` colturi ale unui patrat.
Costul unui APM este `3`.
Daca adaugam centrul, costul unui APM devine `2 * sqrt(2) = 2.8...`.

### B

Fie `G` un APM al lui `P + Q`.
Dezactivam toate nodurile din `G` care provin din `Q`, si comprimam arborele.
Din inegalitatea triunghiului, `AB + BC > AC`.

Fie un nod `X` din `Q`, conectat inainte de compresie la nodurile `A, ... Z`. Il stergem pe `X` si adaugam muchiile `AB, BC, ..., YZ`. Observam ca suma costurilor acestora este mai mica decat `2 * XA + ... + XZ`. QED
