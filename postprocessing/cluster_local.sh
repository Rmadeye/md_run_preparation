#!/bin/bash
#SBATCH -p cpu          # CPU partition
#SBATCH -n 1            # 8 cores
#SBATCH --mem=10GB      # 8 GB of RAM
#SBATCH -J clustering     # name of your job

cp ../parms/stripped.topology.parm7 ../MD_cfg/cpptraj_cluster.in ./

cpptraj -i cpptraj_cluster.in


