#!/bin/bash -l
#SBATCH -J clustering
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rmadaj@cbmm.lodz.pl
#SBATCH --time=12:00:00
#SBATCH -A plgnovi
#SBATCH --partition=plgrid
module load plgrid/apps/amber/18

mpirun -np 8 cpptraj.MPI -i ../MD_cfg/cpptraj_cluster.txt
