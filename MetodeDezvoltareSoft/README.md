# Metode de Dezvoltare Software

Link cu slide-urile de anul trecut [here](http://is.gd/arhiva_MDS_2020)

## Referat

Titlu:
Executia Unui Cod Ne-verificat pe Server

Context:
Proiectul ales de echipa mea este construirea al unui sistem integrat de evaluare automata a codului, asemenea site-urilor inforarena, pbinfo, codeforces etc.
Site-ul nostru oferta totusi o alta experienta de utilizator, exercitiile oferite ne-fiind de natura algoritmica, ci fiind jocuri la care utilizatorii au de trimis boti.
Problema principala este urmatoarea: Dorim sa evaluam un cod trimis de un utilizator. Mai mult de atat: Dorim sa executam un cod trimis de un utilizator, care la randul sau sa poata evalua cod trimis de alti useri.

De ce este interesant:
In mod evident, executia libera de cod ne-verificat pe serverul de productie nu este ideala. In plus de toate problemele de securitate, apar situatii cum ar fi fork-bomb-uri, folosiri excesive de memorie sau de timp, coruperea fisierelor system etc.
Pentru a rezolva aceasta problema, am considerat multiple solutii. Prima solutie care vine in minte este executia codului intr-o masina virtuala sau un container de docker. Totusi, noi dorim doua straturi se securitate. pentru care nici VM-urile si containerele nu mai functioneaza. Vorbind cu cel care a implementat sistemul de jailer pentru infoarena, mi-a recomandat sa folosesc acelasi software, implementat de el in Rust, bazat pe CGroups. Un CGroup, sau control group, este o multime de procese cu diferite permisiuni asupra filesistemului, retelei, memoriei etc, si pentru a securiza un proces este suficient sa fie inchis intr-un cgroup singur, cu permisiuni restranse.
Avantajul acestei abordari este ca procesul ruleaza nativ pe sistem, in care pot fi mount-uite orice foldere. Astfel, se pot face apeluri imbricate se procese, inception style.

Referinte:
* [IA-Sandbox](https://gitlab.com/adrian.budau/ia-sandbox)
* [Chromium Sandbox](https://chromium.googlesource.com/chromium/src/+/master/docs/design/sandbox.md)