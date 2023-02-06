#!/bin/bash
#SBATCH -n 1
#SBATCH --time=24:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=r.madaj@uw.edu.pl
#SBATCH -A plgtrametes-gpu
#SBATCH --partition=plgrid-gpu-v100
#SBATCH --gres=gpu:1

module load amber/22.0-foss-2021b-ambertools-22.2-cuda-11.4.1

filename=`basename ${PWD%/*}`;
output="$filename"\_index.nc

pmemd.cuda -O -i ../MD_cfg/prod.in -o prod_"index".out -p ../parms/topology.parm7 -c ../rst7s/coordinates_heat.rst7 -r ../rst7s/coordinates_"index".rst7 -inf info_"index".inf -x "$output"
