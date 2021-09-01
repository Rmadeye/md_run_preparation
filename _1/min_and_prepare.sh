#!/usr/bin/bash

source ~/amber20/amber.sh

mpirun -np 8 pmemd.MPI -O -i ../MD_cfg/min.in -o min.out -p ../parms/lig-prot-solv.parm7 -c ../rst7s/lig-prot-solv.rst7 -r ../rst7s/lig-prot-solv_min.rst7 -inf info.inf

ambpdb -p ../parms/lig-prot-solv.parm7 -c ../rst7s/lig-prot-solv_min.rst7 > integrity_check.pdb
