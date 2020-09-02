#!/usr/bin/env python3
import sys

def find_ligand_residue_number(file: str) -> int:
    resn = ['UNL', 'UNK', 'LIG']
    with open(file, "r") as ligfile:
        for line in ligfile:
            line = line.split()
            if line[3] in resn:
                return int(line[4])

if __name__ == '__main__':
    try:
        file = sys.argv[1]
        print(find_ligand_residue_number(file))
    except IndexError:
        print("Incorrect file")
