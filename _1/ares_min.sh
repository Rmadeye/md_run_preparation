#!/bin/bash
#SBATCH -A plgtrametes-cpu
#SBATCH -n 8            # 8 cores
#SBATCH --time=3:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=r.madaj@uw.edu.pl
#SBATCH --partition=plgrid-now
#SBATCH -J minimisation_rmadeye     # name of your job


module load amber/22.1-intel-2021b-ambertools-22.3-updated-cpptraj

echo "system minimalisation"
mpirun -np 8  pmemd.MPI -O -i ../MD_cfg/min.in -o min.out -p ../parms/topology.parm7 -c ../rst7s/coordinates.rst7 -r ../rst7s/coordinates_min.rst7 -inf info.inf 

ambpdb -p ../parms/topology.parm7 -c ../rst7s/coordinates_min.rst7 > integrity_check.pdb


sed '/Na+/,$d;/Cl-/,$d;/K+/,$d;' integrity_check.pdb > ../postprocessing/minim.pdb