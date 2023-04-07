#!/bin/bash
#SBATCH -A plgtrametes-cpu
#SBATCH -n 8            # 8 cores
#SBATCH --time=3:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=r.madaj@uw.edu.pl
#SBATCH --partition=plgrid-now
#SBATCH -J minimisation_rmadeye     # name of your job

module load amber/22.1-intel-2021b-ambertools-22.3-updated-cpptraj

#ante-MMPBSA.py -p ../parms/stripped.topology.parm7 -s "!(:1-complex)" -c com.parm7 -m ":1-protein" -r prot.parm7 -l lig.parm7 --radii=mbondi2

mpirun -np 8 MMPBSA.py.MPI -O -i GB.in -o inputname_GB.dat -do inputname_decomposed.dat -cp ../parms/com.parm7 -rp ../parms/prot.parm7 -lp ../parms/lig.parm7 -y ../postprocessing/merged_centered.nc

