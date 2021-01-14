#!/bin/bash -l
#SBATCH -J basic_analysis
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mail-type=ALL
#SBATCH --mail-user=rmadaj@cbmm.lodz.pl
#SBATCH --time=1:00:00
#SBATCH -A plgmadeyemd
#SBATCH --partition=plgrid-short

module load plgrid/apps/amber/18

cpptraj -i ../MD_cfg/analyze_cpptraj.in
