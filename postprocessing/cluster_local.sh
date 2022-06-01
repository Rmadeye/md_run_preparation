#!/bin/bash
#SBATCH -p cpu          # CPU partition
#SBATCH -n 1            # 8 cores
#SBATCH --exclude=edi08
#SBATCH --mem=10GB      # 8 GB of RAM
#SBATCH -J clustering     # name of your job

source ~/amber20/amber.sh || source /opt/apps/amber20/amber.sh

cp ../parms/stripped.topology.parm7 ../MD_cfg/cpptraj_cluster.in ./

cpptraj -i cpptraj_cluster.in


