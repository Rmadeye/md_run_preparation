#!/usr/bin/bash

source ~/amber18/amber.sh

mpirun -np 8 pmemd.MPI -O -i ../MD_cfg/min.in -o min.out -p ../lig-prot-solv.parm7 -c ../lig-prot-solv.rst7 -r lig-prot-solv_min.rst7 -inf info.inf

ambpdb -p ../lig-prot-solv.parm7 -c lig-prot-solv_min.rst7 > integrity_check.pdb
