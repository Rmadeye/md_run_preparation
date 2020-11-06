#!/usr/bin/bash

source ~/amber20_src/amber.sh

ante-MMPBSA.py -p ../stripped.lig-prot-solv.parm7 -s !"(:1-436)" -c com.parm7 -m ":1-435" -r prot.parm7 -l lig.parm7 --radii=mbondi2

mpirun -np 8 MMPBSA.py.MPI -O -i GB.in -o combined_GB.dat -cp com.parm7 -rp prot.parm7 -lp lig.parm7 -y ../_3/cluster.c0

mpirun -np 8 MMPBSA.py.MPI -O -i GBPB.in -o combined_PB.dat -cp com.parm7 -rp prot.parm7 -lp lig.parm7 -y ../_3/cluster.c0
