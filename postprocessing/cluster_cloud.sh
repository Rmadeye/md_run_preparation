#!/bin/bash -l
#SBATCH -J cluster-name
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --mail-type=ALL
#SBATCH --mail-user=
#SBATCH --time=24:00:00
#SBATCH -A grantid
#SBATCH --partition=

module load plgrid/apps/amber/20

filename=`basename ${PWD%/*}`;

cp ../parms/stripped.topology.parm7 merged_centered.nc ../MD_cfg/cpptraj_cluster.in $SCRATCHDIR

cd $SCRATCHDIR
mpirun -np 16 cpptraj.MPI -i cpptraj_cluster.in

cp *.c* ${SLURM_SUBMIT_DIR}
cp summary.dat ${SLURM_SUBMIT_DIR}
cp *.pdb ${SLURM_SUBMIT_DIR}


