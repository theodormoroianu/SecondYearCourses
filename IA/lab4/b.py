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

class Graph:  # graful problemei
    def __init__(self, start, scopuri, capacitateBarca, n):
        self.start = start
        self.scopuri = scopuri
        self.capacitateBarca = capacitateBarca
        self.n = n

    # va genera succesorii sub forma de noduri in arborele de parcurgere
    def genereazaSuccesori(self, nodCurent):
        # de modificat
        listaSuccesori = []
        mat = nodCurent.info
        
        for i in range(3):
            for j in range(3):
                if mat[i][j] is not None:
                    continue

                for new_poz in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
                    if i + new_poz[0] not in [0, 1, 2] or j + new_poz[1] not in [0, 1, 2]:
                        continue

                    res = [[mat[i][j] for j in range(3)] for i in range(3)]
                    res[i][j], res[i + new_poz[0]][j + new_poz[1]] = res[i + new_poz[0]][j + new_poz[1]], res[i][j]
                    if nodCurent.contineInDrum(res):
                        continue
                    listaSuccesori.append((res, self.calculeaza_h(res), nodCurent.g + 1))
        return listaSuccesori

    def calculeaza_h(self, nod_info):
        # de completa
        # nod.info = (x, y, eps) h(nod) = [(x + y)/M]
        # consistenta nod.info = (x, y, eps) -> nod'.info = (x',y',-1 * eps) ||h(nod) <= c(nod -> nod') + h(nod')|| echiv ||h(nod) <= 1 + h(nod')|| echiv [(x + y)/M] <= 1 + [(x' + y')/M]
        # x' + y' => x + y - M echiv x' + y' + M >= x + y echiv
        # h(nod) <= c(nod -> nod') + h(nod')
        poz_act = [None for i in range(9)]
        poz_final = [None for i in range(9)]

        for i in range(3):
            for j in range(3):
                if nod_info[i][j] is not None:
                    poz_act[nod_info[i][j]] = (i, j)
                if scop[i][j] is not None:
                    poz_final[scop[i][j]] = (i, j)

        est = 0
        for i in range(1, 9):
            est += abs(poz_act[i][0] - poz_final[i][0]) + abs(poz_act[i][1] - poz_final[i][1])
        return (est + 1) // 2

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
n = 10
scop = [[1, 2, 3], [4, 5, 6], [7, 8, None]]
start = [[1, 2, 3], [4, 5, 6], [None, 7, 8]]
# scop = [[5, 7, 2], [None, 8, 6], [3, 4, 1]]
# start = [[5, 7, 2], [8, None, 6], [3, 4, 1]]

gr = Graph(start, scop, capacitate_barca, n)

def construieste_drum(nodCurent: NodParcurgere, limita):
  #de completat
  if nodCurent.info == scop:
    # nodCurent.afisDrum()
    print(nodCurent.afisDrum())
    return (True, 0)

  if nodCurent.f > limita:
    return (False, nodCurent.f)

  min_outside_f = float('inf')

  for (info, est, dist) in gr.genereazaSuccesori(nodCurent):
    (gasit_scop, new_min_f) = construieste_drum(NodParcurgere(info, nodCurent, dist, dist + est), limita)
    if gasit_scop:
      return (True, 0)
    min_outside_f = min(min_outside_f, new_min_f)
  
  return (False, min_outside_f)


def ida_star():
  #de completat
  #s - >1 -> 2 -> 3
  #s -> 1 -> 4 -> 3// h = 1
  #h = 2 # h = 3 ... h <= numar de noduri
  #limita = estimare(nodStart)
  #generam toate nodurile f <= limita
  #nodurile f > limita, 
  #limita = minim
  
  estimare_act = 0

  nod_start = NodParcurgere(
    start,
    None,
    0,
    gr.calculeaza_h(start)
  )

  while True:
    (gasit, new_est) = construieste_drum(nod_start, estimare_act)
    if gasit:
      break

    if new_est == float('inf'):
      print("Unable to find path!!")
      break
    estimare_act = new_est
    print("New estimate: ", estimare_act)



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

    if nod_curent.info == scop:
      print(nod_curent.afisDrum())
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
    ida_star()