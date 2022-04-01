#!/bin/bash
#SBATCH -p cpu          # CPU partition
#SBATCH -n 4            # 8 cores
#SBATCH --mem=8GB      # 8 GB of RAM
#SBATCH -J minimisation_rmadeye     # name of your job


source /opt/apps/amber18/amber.sh

mpirun -np 4 pmemd.MPI -O -i ../MD_cfg/min.in -o min.out -p ../parms/topology.parm7 -c ../rst7s/coordinates.rst7 -r ../rst7s/coordinates_min.rst7 -inf info.inf

ambpdb -p ../parms/topology.parm7 -c ../rst7s/coordinates_min.rst7 > integrity_check.pdb


