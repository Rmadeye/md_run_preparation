#!/bin/bash
#SBATCH -A plgcx32-cpu
#SBATCH -n 8            # 8 cores
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=r.madaj@uw.edu.pl
#SBATCH --partition=plgrid
#SBATCH -J minimisation_rmadeye     # name of your job


module load amber/20.12-intel-2021b-ambertools-21.12

echo "system minimalisation"
mpirun -np 8  pmemd.MPI -O -i ../MD_cfg/min_system.in -o min3.out -p ../parms/topology.parm7 -c ../rst7s/coordinates_prot.rst7 -r ../rst7s/coordinates_min.rst7 -inf info.inf 

ambpdb -p ../parms/topology.parm7 -c ../rst7s/coordinates_min.rst7 > integrity_check.pdb


sed '/Na+/,$d;/Cl-/,$d;/K+/,$d;' integrity_check.pdb > ../postprocessing/minim.pdb