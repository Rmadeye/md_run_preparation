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

cp ../parms/topology.parm7 ../rst7s/coordinates_heat.rst7 ../rst7s/coordinates.rst7 ../MD_cfg/prod.in $SCRATCHDIR

cd $SCRATCHDIR

output="$filename"\_index.nc

pmemd.cuda -O -i prod.in -o prod_"index".out -p topology.parm7 -c coordinates_heat.rst7 -r coordinates_"index".rst7 -inf info.inf -x "$output"

cp *.nc ${SLURM_SUBMIT_DIR}
cp prod.out ${SLURM_SUBMIT_DIR}
cp *.rst7 ${SLURM_SUBMIT_DIR}/../rst7s
