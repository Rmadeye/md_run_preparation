#!/bin/bash -l
#SBATCH -J heater
#SBATCH -N 1
#SBATCH -n 8 
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rmadaj@cbmm.lodz.pl
#SBATCH --time=1:00:00
#SBATCH -A plgmadeyemd
#SBATCH --partition=plgrid-short

module load plgrid/apps/amber/18
mpirun -np 8 pmemd.MPI -O -i ../MD_cfg/heat.in -o heat.out -p ../parms/lig-prot-solv.parm7 -c ../rst7s/lig-prot-solv_min.rst7 -r ../rst7s/lig-prot-solv_heat.rst7 -inf info.inf -ref ../rst7s/lig-prot-solv_min.rst7

cpptraj -i ../MD_cfg/check_2.in
