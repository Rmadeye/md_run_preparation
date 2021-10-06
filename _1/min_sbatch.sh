#!/bin/bash -l
#SBATCH -J minimisation
#SBATCH -N 1
#SBATCH -n nodesnumber_short
#SBATCH --time=1:00:00
#SBATCH -A grantid
#SBATCH --partition=
module load plgrid/apps/amber/20

cp ../parms/topology.parm7 ../rst7s/coordinates.rst7 ../MD_cfg/min.in $SCRATCHDIR

cd $SCRATCHDIR

mpirun -np nodesnumber_short pmemd.MPI -O -i min.in -o min.out -p topology.parm7 -c coordinates.rst7 -r coordinates_min.rst7 -inf info.inf

ambpdb -p topology.parm7 -c coordinates_min.rst7 > integrity_check.pdb

cp coordinates_min.rst7 ${SLURM_SUBMIT_DIR}/../rst7s/
cp integrity_check.pdb ${SLURM_SUBMIT_DIR}

