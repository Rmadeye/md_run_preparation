#!/bin/bash -l
#SBATCH -J producer
#SBATCH -n 1
#SBATCH --time=72:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rmadaj@cbmm.lodz.pl
#SBATCH -A grantidgpu
#SBATCH --partition=plgrid-gpu
#SBATCH --gres=gpu:1

module load plgrid/apps/amber/18

filename=`basename ${PWD%/*}`;

cp ../parms/lig-prot-solv.parm7 ../rst7s/lig-prot-solv_heat.rst7 ../MD_cfg/prod.in $SCRATCHDIR

cd $SCRATCHDIR

for i in {reps}; do

echo 'Job number being done:' $i
output="$filename"\_$i.nc

pmemd.cuda -O -i prod.in -o prod_"$i".out -p lig-prot-solv.parm7 -c lig-prot-solv_heat.rst7 -r lig-prot-solv_"$i".rst7 -inf info.inf -x "$output"

done

cp *.nc ${SLURM_SUBMIT_DIR}
cp prod.out ${SLURM_SUBMIT_DIR}
cp *.rst7 ${SLURM_SUBMIT_DIR}/../rst7s
