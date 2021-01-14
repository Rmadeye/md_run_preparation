#!/bin/bash -l
#SBATCH -J MMGBSA-azo
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rmadaj@cbmm.lodz.pl
#SBATCH --time=12:00:00
#SBATCH -A plgmadeyemd
#SBATCH --partition=plgrid
module load plgrid/apps/amber/18

mkdir mmgbsa_${SLURM_JOB_ID}

cp ../parms/stripped.lig-prot-solv.parm7 ../postprocessing/merged_centered.nc GB.in $SCRATCHDIR
cd $SCRATCHDIR

ante-MMPBSA.py -p ../stripped.lig-prot-solv.parm7 -s !"(:1-complex)" -c com.parm7 -m ":1-protein" -r prot.parm7 -l lig.parm7 --radii=mbondi2

mpirun -np 8 MMPBSA.py.MPI -O -i GB.in -o combined_GB.dat -cp com.parm7 -rp prot.parm7 -lp lig.parm7 -y ../postprocessing/merged_centered.nc

cp combined_GB.dat FINAL_DECOMP_MMPBSA.dat ${SLURM_SUBMIT_DIR}/mmgbsa_${SLURM_JOB_ID}


