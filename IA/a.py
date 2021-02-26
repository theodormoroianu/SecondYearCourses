from copy import deepcopy

class NodParcurgere:
    def __init__(self, id, info, cost, parinte):
        self.id = id  # este indicele din vectorul de noduri
        self.info = info
        self.parinte = parinte  # parintele din arborele de parcurgere
        self.cost = cost

    def obtineDrum(self):
        l = [self.info]
        nod = self
        while nod.parinte is not None:
            l.insert(0, nod.parinte.info)
            nod = nod.parinte
        return l

    def afisDrum(self):  # returneaza si lungimea drumului
        l = self.obtineDrum()
        print(("->").join([str(x) for x in l]))
        return len(l)

    def contineInDrum(self, infoNodNou):
        nodDrum = self
        while nodDrum is not None:
            if (infoNodNou == nodDrum.info):
                return True
            nodDrum = nodDrum.parinte

        return False

    def __repr__(self):
        sir = ""
        sir += self.info + "("
        sir += "id = {}, ".format(self.id)
        sir += "drum="
        drum = self.obtineDrum()
        sir += ("->").join(drum)
        sir += " cost:{})".format(self.cost)
        return (sir)

class Graph:  # graful problemei
    def __init__(self, start):
        self.start = start

    def indiceNod(self, n):
        return self.noduri.index(n)

    # va genera succesorii sub forma de noduri in arborele de parcurgere
    def genereazaSuccesori(self, nodCurent, c):
        listaSuccesori = []
      
        stive = nodCurent.info

        for i in range(len(stive)):
            if len(stive[i]) == 0:
                continue
            for j in range(len(stive)):
                if i == j:
                    continue
                stiva_noua = deepcopy(stive)
                stiva_noua[j].append(stiva_noua[i][-1])
                stiva_noua[i].pop()

                listaSuccesori.append(NodParcurgere(-1, stiva_noua, 1 + nodCurent.cost, nodCurent))

        return listaSuccesori

    def __repr__(self):
        sir = ""
        for (k, v) in self.__dict__.items():
            sir += "{} = {}\n".format(k, v)
        return (sir)

start = [[1, 5, 2, 3], [54, 10, 2], [34, 44, 1]]
nrSolutiiCautate = 1
gr = Graph(start)

def isScope(nod):
    nr = -1
    for i in nod:
        if nr != -1 and len(i) != 0 and len(i) != nr:
            return False
        if len(i) != 0:
            nr = len(i)
    return True

def uniform_cost(gr):
    global nrSolutiiCautate
    c = [NodParcurgere(-1, start, 0, None)]
    continua = True
    while (len(c) > 0 and continua):
        nodCurent = c.pop(0)
        # print("Processing node ", nodCurent.info)

        if isScope(nodCurent.info):
            nodCurent.afisDrum()
            nrSolutiiCautate -= 1
            if nrSolutiiCautate == 0:
                continua = False

        lSuccesori = gr.genereazaSuccesori(nodCurent, c)
        for s in lSuccesori:
            i = 0
            gasit_loc = False
            for i in range(len(c)):
                # diferenta e ca ordonez dupa f
                if c[i].cost >= s.cost:
                    gasit_loc = True
                    break
            if gasit_loc:
                c.insert(i, s)
            else:
                c.append(s)
                
if __name__ == '__main__':
  print("Got here")
  uniform_cost(gr)