#!/bin/bash -l
#SBATCH -J producer
#SBATCH -n 1
#SBATCH --time=72:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rmadaj@cbmm.lodz.pl
#SBATCH -A plgmadeyemdgpu
#SBATCH --partition=plgrid-gpu
#SBATCH --gres=gpu:1

module load plgrid/apps/amber/18

filename=`basename ${PWD%/*}`;

for i in {1..reps}; do

echo 'Job number being done:' $i
output="$filename"\_$i.nc

pmemd.cuda -O -i ../MD_cfg/prod.in -o prod.out -p ../parms/lig-prot-solv.parm7 -c ../rst7s/lig-prot-solv_heat.rst7 -r ../rst7s/lig-prot-solv_"$i".rst7 -inf info.inf -x "$output"

done
