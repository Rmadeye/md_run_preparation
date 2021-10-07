#!/usr/bin/bash

source ~/amber20/amber.sh

mpirun -np 8 pmemd.MPI -O -i ../MD_cfg/min.in -o min.out -p ../parms/topology.parm7 -c ../rst7s/coordinates.rst7 -r ../rst7s/coordinates_min.rst7 -inf info.inf

ambpdb -p ../parms/topology.parm7 -c ../rst7s/coordinates_min.rst7 > integrity_check.pdb
