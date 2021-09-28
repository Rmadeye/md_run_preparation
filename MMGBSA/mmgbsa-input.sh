#!/bin/bash -l
#SBATCH -J MMGBSA-inputname
#SBATCH -N 1
#SBATCH -n mmgbsacpu
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rmadaj@cbmm.lodz.pl
#SBATCH --time=24:00:00
#SBATCH -A grantid
#SBATCH --partition=plgrid
module load plgrid/apps/amber/20

cp ../parms/stripped.lig-prot-solv.parm7 ../postprocessing/merged_centered.nc GB.in $SCRATCHDIR

cd $SCRATCHDIR

ante-MMPBSA.py -p stripped.lig-prot-solv.parm7 -s !"(:1-complex)" -c com.parm7 -m ":1-protein" -r prot.parm7 -l lig.parm7 --radii=mbondi2

mpirun -np mmgbsacpu MMPBSA.py.MPI -O -i GB.in -o inputname_GB.dat -do inputname_decomposed.dat -cp com.parm7 -rp prot.parm7 -lp lig.parm7 -y merged_centered.nc

cp inputname_GB.dat inputname_decomposed.dat ${SLURM_SUBMIT_DIR}


