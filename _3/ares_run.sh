#!/bin/bash
#SBATCH -n 1
#SBATCH --time=48:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=r.madaj@uw.edu.pl
#SBATCH -A plgcx32gpu-gpu
#SBATCH --partition=plgrid-gpu-v100
#SBATCH --gres=gpu:1

module load amber/20.12-fosscuda-2020b-ambertools-21.12

filename=`basename ${PWD%/*}`;
output="$filename"\_index.nc

pmemd.cuda -O -i ../MD_cfg/prod.in -o prod_"index".out -p ../parms/topology.parm7 -c ../rst7s/coordinates_heat.rst7 -r ../rst7s/coordinates_"index".rst7 -inf info_"index".inf -x "$output"
