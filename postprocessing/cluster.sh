#!/bin/bash -l
#SBATCH -J cluster-name
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rmadaj@cbmm.lodz.pl
#SBATCH --time=24:00:00
#SBATCH -A grantid
#SBATCH --partition=plgrid

module load plgrid/apps/amber/18

filename=`basename ${PWD%/*}`;

cp ../parms/stripped.lig-prot-solv.parm7 merged_centered.nc ../MD_cfg/cluster_cpptraj.in $SCRATCHDIR

cd $SCRATCHDIR
mpirun -np 16 cpptraj.MPI -i cluster_cpptraj.txt

cp *.c* ${SLURM_SUBMIT_DIR}
cp summary.dat ${SLURM_SUBMIT_DIR}
cp *.pdb ${SLURM_SUBMIT_DIR}


