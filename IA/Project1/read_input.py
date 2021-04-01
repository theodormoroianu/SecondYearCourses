from os import listdir
from os.path import isfile, join
from typing import List, Tuple
import state

def ReadFolder(folder: str) -> List[str]:
    """
        Reads an input folder, and returns the files from within.
        @param folder: folder to read.
        @return: list with all the files.
    """

    onlyfiles = [f for f in listdir(folder) if isfile(join(folder, f))]
    
    return onlyfiles

def ReadFile(filepath: str):
    """
        Reads a file, and returns { color, bonus }.
        @param: file to read.
    """

    with open(filepath, "r") as fin:
        lines = [x.split() for x in fin.readlines()]
        N, M = (len(lines) - 1) // 2, len(lines[0])
        
        if len(lines[N]) != 0:
            raise IOError("Invalid input file!")

        state.Initialize(lines[:N], lines[N + 1:])