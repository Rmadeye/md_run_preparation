#!/bin/bash -l
#SBATCH -J heater
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rmadaj@cbmm.lodz.pl
#SBATCH --time=1:00:00
#SBATCH -A plgnovi
#SBATCH --partition=plgrid-short

module load plgrid/apps/amber/18

cp ../parms/lig-prot-solv.parm7 ../rst7s/lig-prot-solv_min.rst7 ../MD_cfg/heat.in $SCRATCHDIR

cd $SCRATCHDIR

mpirun -np 8 pmemd.MPI -O -i heat.in -o heat.out -p lig-prot-solv.parm7 -c lig-prot-solv_min.rst7 -r lig-prot-solv_heat.rst7 -inf info.inf -ref lig-prot-solv_min.rst7

cp heat.out ${SLURM_SUBMIT_DIR}
cp lig-prot-solv_heat.rst7 ${SLURM_SUBMIT_DIR}/../rst7s/
cp mdcrd ${SLURM_SUBMIT_DIR}
cd ${SLURM_SUBMIT_DIR}
cpptraj -i ../MD_cfg/check_2.in
