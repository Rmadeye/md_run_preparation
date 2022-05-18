#!/bin/bash
#SBATCH -C rtx2080ti
#SBATCH -p gpu          # GPU partition
#SBATCH -n 1            # 8 cores
#SBATCH --gres=gpu:1    # 1 GPU 
#SBATCH --mem=8GB      # 8 GB of RAM
#SBATCH -J producer     # name of your job

source /opt/apps/amber20/amber.sh

filename=`basename ${PWD%/*}`;
output="$filename"\_index.nc

pmemd.cuda -O -i ../MD_cfg/prod.in -o prod_"index".out -p ../parms/topology.parm7 -c ../rst7s/coordinates_heat.rst7 -r ../rst7s/coordinates_"index".rst7 -inf info.inf -x "$output"
