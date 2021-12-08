#!/bin/bash -l
#SBATCH -J heater
#SBATCH -N 1
#SBATCH -n nodesnumber_short
#SBATCH --time=1:00:00
#SBATCH -A grantid
#SBATCH --partition=plgrid

module load plgrid/apps/amber/20

cp ../parms/topology.parm7 ../rst7s/coordinates_min.rst7 ../MD_cfg/heat.in $SCRATCHDIR

cd $SCRATCHDIR

mpirun -np nodesnumber_short pmemd.MPI -O -i heat.in -o heat.out -p topology.parm7 -c coordinates_min.rst7 -r coordinates_heat.rst7 -inf info.inf -ref coordinates_min.rst7

cp heat.out ${SLURM_SUBMIT_DIR}
cp coordinates_heat.rst7 ${SLURM_SUBMIT_DIR}/../rst7s/
cp mdcrd ${SLURM_SUBMIT_DIR}
cd ${SLURM_SUBMIT_DIR}
cpptraj -i ../MD_cfg/check_2.in
