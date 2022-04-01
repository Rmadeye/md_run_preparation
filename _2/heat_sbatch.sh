#!/bin/bash
#SBATCH -p gpu          # GPU partition
#SBATCH -n 1            # 8 cores
#SBATCH --gres=gpu:1    # 1 GPU 
#SBATCH --mem=8GB      # 8 GB of RAM
#SBATCH -J heating_rmadeye     # name of your job

source /opt/apps/amber20/amber.sh

pmemd.cuda -O -i ../MD_cfg/heat.in -o heat.out -p ../parms/topology.parm7 -c ../rst7s/coordinates_min.rst7 -r ../rst7s/coordinates_heat.rst7 -inf info.inf -ref ../rst7s/coordinates_min.rst7

cpptraj -i ../MD_cfg/generate_minim_check_ntwprt.in