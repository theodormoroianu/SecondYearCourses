# Metode de Dezvoltare Software

Link cu slide-urile de anul trecut [here](http://is.gd/arhiva_MDS_2020)

## Referat

Titlu:
Executia Supervizata A Unui Cod Neverificat Pe Server

Context:
Proiectul ales de echipa mea este construirea al unui sistem integrat de evaluare automata a codului pe diverse probleme, asemenea site-urilor inforarena, pbinfo, codeforces etc.
Totusi, site-ul nostru oferta o alta experienta de utilizator, exercitiile oferite ne-fiind de natura algoritmica, ci fiind jocuri la care utilizatorii au de trimis boti, implementati in C/C++.
Problema intampinata este urmatoarea: Dorim sa evaluam un cod trimis de un utilizator. Mai mult de atat: cum utilizatorii pot adauga si ei exercitii noi, trebuie ca infrastructura noastra sa permita:
 1. Sa execute in mod securizat ceea-ce numim "engine"-ul, cod care stie sa simuleze jocul.
 2. Sa permita engine-ului sa execute la randul sau in mod securizat botii trimisi de useri.


De ce este interesant, si ce solutie avem:
Executia libera de cod ne-verificat pe serverul de productie nu este ideala. In plus de toate problemele de securitate, apar situatii cum ar fi fork-bomb-uri, folosiri excesive de memorie sau de timp, coruperea fisierelor system etc.
Pentru a rezolva aceasta problema, am considerat multiple solutii:
 * Prima solutie care vine in minte este executia codului intr-o masina virtuala sau un container de docker. Masina virtuala, din cauza overhead-ului gigantic de timp, si dificultatea de comunicare dintre VM si lumea exterioara este o solutie suboptima. Pe de alta parte, noi dorim doua straturi se securitate: vrem sa avem un strat de protectie peste engine, care la randul sau doreste un strat de protectie peste boti, pentru care nici VM-urile nici containerele nu mai functioneaza.
 * Vorbind creatorul sistemului de jailer (o "cutie" care controleaza un proces) pentru infoarena, acesta mi-a recomandat sa folosesc acelasi software, implementat de el in Rust, bazat pe CGroups. Un CGroup, sau control group, este o multime de procese din Linux, cu diferite permisiuni asupra filesistemului, retelei, memoriei etc. Pentru a securiza un proces este suficient sa fie inchis intr-un cgroup singur, cu permisiuni restranse, si software-ul implementat de el, numit "IA-sandbox" face fix asta: permite pornirea unui proces intr-un CGroup nou.
Avantajul acestei abordari este ca procesul ruleaza nativ pe sistem, in care pot fi mount-uite orice foldere. Astfel, se pot face apeluri imbricate ale IA-sandbox-ului, inception-style.

Referinte:
* [IA-Sandbox](https://gitlab.com/adrian.budau/ia-sandbox)
* [Chromium Sandbox - Abordarea folosita de Chromium](https://chromium.googlesource.com/chromium/src/+/master/docs/design/sandbox.md)
* [Managerul implementat in cadrul proiectului nostru](https://github.com/TeamUnibuc/MDS/blob/main/engine/engine.py)

