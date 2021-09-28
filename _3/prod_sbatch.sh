#!/bin/bash -l
#SBATCH -J producer
#SBATCH -n 1
#SBATCH --time=72:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rmadaj@cbmm.lodz.pl
#SBATCH -A grantidgpu
#SBATCH --partition=plgrid-gpu
#SBATCH --gres=gpu:1

module load plgrid/apps/amber/20

filename=`basename ${PWD%/*}`;

cp ../parms/lig-prot-solv.parm7 ../rst7s/lig-prot-solv_heat.rst7 ../rst7s/lig-prot-solv.rst7 ../MD_cfg/prod.in $SCRATCHDIR

cd $SCRATCHDIR

output="$filename"\_index.nc

pmemd.cuda -O -i prod.in -o prod_"index".out -p lig-prot-solv.parm7 -c lig-prot-solv_heat.rst7 -r lig-prot-solv_"index".rst7 -inf info.inf -x "$output"

cp *.nc ${SLURM_SUBMIT_DIR}
cp prod.out ${SLURM_SUBMIT_DIR}
cp *.rst7 ${SLURM_SUBMIT_DIR}/../rst7s
