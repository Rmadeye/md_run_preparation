#!/bin/bash
#SBATCH -p cpu          # CPU partition
#SBATCH -w edi00
#SBATCH -n 8            # 8 cores
#SBATCH --mem=8GB      # 8 GB of RAM
#SBATCH -J MMGBSA     # name of your job


source /opt/apps/amber18/amber.sh

ante-MMPBSA.py -p ../parms/stripped.topology.parm7 -s "!(:1-complex)" -c com.parm7 -m ":1-protein" -r prot.parm7 -l lig.parm7 --radii=mbondi2

mpirun -np 8 MMPBSA.py.MPI -O -i GB.in -o inputname_GB.dat -do inputname_decomposed.dat -cp com.parm7 -rp prot.parm7 -lp lig.parm7 -y ../postprocessing/merged_centered.nc


