#!/bin/bash -l
#SBATCH -J minimisation
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --time=1:00:00
#SBATCH -A plgnovi
#SBATCH --partition=plgrid-short
module load plgrid/apps/amber/18

cp ../parms/lig-prot-solv.parm7 ../rst7s/lig-prot-solv.rst7 ../MD_cfg/min.in $SCRATCHDIR

cd $SCRATCHDIR

mpirun -np 8 pmemd.MPI -O -i min.in -o min.out -p lig-prot-solv.parm7 -c lig-prot-solv.rst7 -r lig-prot-solv_min.rst7 -inf info.inf

ambpdb -p lig-prot-solv.parm7 -c lig-prot-solv_min.rst7 > integrity_check.pdb

ante-MMPBSA.py -p lig-prot-solv.parm7 -c stripped.lig-prot-solv.parm7 -s ':WAT,:Na+,:Cl-'

cp lig-prot-solv_min.rst7 ${SLURM_SUBMIT_DIR}/../rst7s/
cp integrity_check.pdb ${SLURM_SUBMIT_DIR}
cp stripped.lig-prot-solv.parm7 ${SLURM_SUBMIT_DIR}/../parms
