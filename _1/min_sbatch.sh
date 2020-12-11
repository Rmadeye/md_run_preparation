#!/bin/bash -l
#SBATCH -J minimer
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --time=1:00:00
#SBATCH -A plgmadeyemd
#SBATCH --partition=plgrid-short
module load plgrid/apps/amber/18
mpirun -np 8 pmemd.MPI -O -i ../MD_cfg/min.in -o min.out -p ../parms/lig-prot-solv.parm7 -c ../rst7s/lig-prot-solv.rst7 -r ../rst7s/lig-prot-solv_min.rst7 -inf info.inf

ambpdb -p ../parms/lig-prot-solv.parm7 -c ../rst7s/lig-prot-solv_min.rst7 > integrity_check.pdb

ante-MMPBSA.py -p ../parms/lig-prot-solv.parm7 -c ../parms/stripped.lig-prot-solv.parm7 -s ':WAT,:Na+,:Cl-'

#python3 ../python_scripts/prepare_inputs.py