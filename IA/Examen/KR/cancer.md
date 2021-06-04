# Pas1:
    Closed:
        []
    Open:
        [(a, g=0, f=inf, tata=none)]
    Ne extindem din a, cu g=0, f=inf.
# Pas2:
    Closed:
        [(a, g=0, f=inf, tata=none)]
    Open:
        [(b, g=5, f=11, tata=a),
         (e, g=1, f=19, tata=a),
         (g, g=19, f=25, tata=a),
         (d, g=9, f=19, tata=a)]
    Ne exindem din b, cu g=5, f=11.
# Pas3:
    Closed:
        [(b, g=5, f=11, tata=a),
         (a, g=0, f=inf, tata=none)]
    Open:
        [(e, g=1, f=19, tata=a),
         (g, g=19, f=25, tata=a),
         (d, g=9, f=19, tata=a)]
    Ne extindem din d, cu g=9, f=19.
# Pas4:
    Closed:
        [(b, g=5, f=11, tata=a),
         (a, g=0, f=inf, tata=none),
         (d, g=9, f=19, tata=a)]
    Open:
        [(e, g=1, f=19, tata=a),
         (g, g=13, f=19, tata=d),
         (c, g=14, f=22, tata=d)]
    Ne extindem din g, cu g=13, f=19.
# Pas5:
    Closed:
        [(b, g=5, f=11, tata=a),
         (a, g=0, f=inf, tata=none),
         (d, g=9, f=19, tata=a),
         (g, g=13, f=19, tata=d)]
    Open:
        [(e, g=1, f=19, tata=a),
         (c, g=14, f=22, tata=d),
         (f, g=19, f=19, tata=g)]
    Nodul optim din Open este f, cu g=19 si f=19, care este si nodul destinatie, asa ca oprim cautarea.

Drumul optim este a -> d -> g -> f,
    care are cost 9 + 4 + 6 = 19.