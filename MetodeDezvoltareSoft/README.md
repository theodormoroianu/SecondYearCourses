# Metode de Dezvoltare Software

Link cu slide-urile de anul trecut [here](http://is.gd/arhiva_MDS_2020)

## Referat

Titlu:
Executia Supervizata A Unui Cod Nesecurizat Pe Servere de Productie

Context:
Proiectul ales de echipa mea este construirea unui sistem integrat de evaluare automata a codului pe diverse probleme, asemenea site-urilor inforarena, pbinfo, codeforces etc.
Totusi, site-ul nostru ofera o alta experienta de utilizator, exercitiile oferite nefiind de natura algoritmica, ci jocuri la care utilizatorii au de trimis boti, implementati in C/C++.
Problema intampinata este urmatoarea:
Dorim sa evaluam un cod trimis de un utilizator. Mai mult de atat: cum utilizatorii pot adauga si ei exercitii noi, trebuie ca infrastructura noastra sa permita:
 1. Sa execute in mod securizat "engine"-ul (codul care stie sa simuleze jocul trimis de utilizatori).
 2. Sa permita engine-ului sa execute la randul sau in mod securizat botii trimisi de useri.


Solutia noastra:
Executia libera de cod neverificat pe serverul de productie nu este ideala. In plus de toate problemele de securitate, apar situatii cum ar fi fork-bomb-uri, folosiri excesive de memorie sau de timp, coruperea fisierelor system etc.
Pentru a rezolva aceasta problema, am considerat urmatoarele solutii:
 * Prima solutie care vine in minte este executia codului intr-o masina virtuala sau un container de docker. Masina virtuala, din cauza overhead-ului gigantic de timp, si dificultatii de comunicare dintre VM si lumea exterioara este o solutie suboptima. Pe de alta parte, noi dorim doua straturi se securitate: vrem sa avem un strat de protectie peste engine, care la randul sau doreste un strat de protectie peste boti, pentru care nici VM-urile nici containerele nu mai functioneaza (este foarte greu sa setam containere imbricate).
 * Vorbind cu creatorul sistemului de jailer (o "cutie" care controleaza un proces) pentru infoarena, acesta mi-a recomandat sa folosesc acelasi software, implementat de el in Rust, bazat pe CGroups. Un CGroup, sau control group, este o multime de procese din Linux, cu diferite permisiuni asupra filesistemului, retelei, memoriei etc. Pentru a securiza un proces este suficient sa fie inchis intr-un CGroup singur, cu permisiuni restranse, si software-ul implementat de el, numit "IA-sandbox" face fix asta: permite pornirea unui proces intr-un CGroup nou.
 Avantajul acestei abordari este ca procesul ruleaza nativ pe sistem, in care pot fi mount-uite read-only orice foldere, inclusiv IA-Sandbox! Astfel, se pot face apeluri imbricate ale IA-sandbox-ului, inception-style.

Asadar, sistemul nostru ofera performante native, dar cu doua layere de securitate testate deja de ani de zile pe infoarena.ro.

Referinte:
* [Proiectul nostru](https://universityproject.ml/)
* [IA-Sandbox](https://gitlab.com/adrian.budau/ia-sandbox)
* [Chromium Sandbox - Abordarea folosita de Chromium](https://chromium.googlesource.com/chromium/src/+/master/docs/design/sandbox.md)
* [Managerul implementat in cadrul proiectului nostru](https://github.com/TeamUnibuc/MDS/blob/main/engine/engine.py)

