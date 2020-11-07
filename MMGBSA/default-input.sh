#!/usr/bin/bash

source ~/amber18/amber.sh

ante-MMPBSA.py -p ../stripped.lig-prot-solv.parm7 -s !"(:1-complex)" -c com.parm7 -m ":1-protein" -r prot.parm7 -l lig.parm7 --radii=mbondi2

mpirun -np 8 MMPBSA.py.MPI -O -i GB.in -o combined_GB.dat -cp com.parm7 -rp prot.parm7 -lp lig.parm7 -y ../postprocessing/merged_centered.nc

mpirun -np 8 MMPBSA.py.MPI -O -i GBPB.in -o combined_PB.dat -cp com.parm7 -rp prot.parm7 -lp lig.parm7 -y ../postprocessing/merged_centered.nc



