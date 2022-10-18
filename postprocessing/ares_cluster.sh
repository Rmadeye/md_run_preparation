#!/bin/bash
#SBATCH -A plgcx32-cpu
#SBATCH -n 8            # 8 cores
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mem=16GB
#SBATCH --mail-user=r.madaj@uw.edu.pl
#SBATCH --partition=plgrid
#SBATCH -J minimisation_rmadeye     # name of your job


module load amber/20.12-intel-2021b-ambertools-21.12

cp ../parms/details.parm7 ../MD_cfg/cpptraj_cluster.in ./

cpptraj -i cpptraj_cluster.in