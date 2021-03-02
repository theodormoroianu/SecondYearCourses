import numpy as np
import copy
import math

class NodParcurgere:
    def __init__(self, info, parinte, g, f):
        self.info = info
        self.parinte = parinte  # parintele din arborele de parcurgere
        self.f = f
        self.g = g

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
    def __init__(self, start, scopuri, capacitateBarca, n):
        self.start = start
        self.scopuri = scopuri
        self.capacitateBarca = capacitateBarca
        self.n = n

    def indiceNod(self, n):
        return self.noduri.index(n)

    # va genera succesorii sub forma de noduri in arborele de parcurgere
    def genereazaSuccesori(self, nodCurent):
      #de modificat
        listaSuccesori = []
        [can, mis, eps] = nodCurent.info
        t1 = 0
        t2 = 0
        if eps == 1:
          t1 = n - can 
          t2 = n - mis
        else:
          t1 = can
          t2 = mis
        for i in range(t1+1):
          for j in range (t2+1):
            if (i == 0 or j==0 or i <= j) and i+j <= self.capacitateBarca and (i != 0 or j!=0):
              canNew = can + eps*i
              misNew = mis + eps*j
              if (canNew == 0 or misNew == 0 or canNew <= misNew) and (n - canNew == 0 or n - misNew == 0 or  n - canNew <= n-misNew):
                res = [canNew, misNew, eps * (-1)]
                if nodCurent.contineInDrum(res):
                  continue
                listaSuccesori.append((res, nodCurent.g + 1, self.calculeaza_h(nodCurent.info)))
        return listaSuccesori

    def calculeaza_h(self, nod_info):
      #se completeaza in functie de problema hi = [(x + y)/m] xf+yf >= x + y (aducem de pe drept) -> hf >= hi | xf + yf >= x + y - m -> hf >= hi - 1 -> hf + 1 >= hi CONSISTENT
      a, b, dir_ = nod_info
      return (a + b) // capacitate_barca

      


    def __repr__(self):
        sir = ""
        for (k, v) in self.__dict__.items():
            sir += "{} = {}\n".format(k, v)
        return (sir)


##############################################################################################
#                                 Initializare problema                                      #
##############################################################################################

# pozitia i din vector
capacitate_barca = 4
nrSolutiiCautate = 1
n = 20
start = [n, n, -1]
scopuri = [[0, 0, 1]]

gr = Graph(start, scopuri, capacitate_barca, n)

def in_list(nod_info, lista):
  for nod in lista:
    if nod.info == nod_info:
      return nod
  return None

def a_star():
  closed, opened = [], [NodParcurgere(start, None, 0, 0)]

  while len(opened) != 0:
    nod_curent = opened[0]
    opened.pop(0)
  
    closed.append(nod_curent)

    if nod_curent.info in scopuri:
      nod_curent.afisDrum()
      return
    
    succ = gr.genereazaSuccesori(nod_curent)

    def insertElem(nod):
      poz = 0
      while poz + 1 < len(opened) and [opened[poz].f, -opened[poz].g] < [nod.f, -nod.g]:
        poz += 1
      opened.insert(poz, nod)

    for i in succ:
      nod = in_list(i[0], closed)
      if nod is not None:
        if nod.f > i[1] + i[2]:
          closed.remove(nod)
          insertElem(NodParcurgere(i[0], nod_curent, i[1], i[1] + i[2]))
        continue
      
      nod = in_list(i[0], opened)
      if nod is not None:
        if nod.f > i[1] + i[2]:
          opened.remove(nod)
          insertElem(NodParcurgere(i[0], nod_curent, i[1], i[1] + i[2]))
        continue
  
      # got here -> does not appear
      insertElem(NodParcurgere(i[0], nod_curent, i[1], i[1] + i[2]))


if __name__ == '__main__':
    a_star()