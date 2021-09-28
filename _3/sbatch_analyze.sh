#!/bin/bash -l
#SBATCH -J basic_analysis
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --time=1:00:00
#SBATCH -A grantid
#SBATCH --partition=plgrid-short

module load plgrid/apps/amber/20

cpptraj -i ../MD_cfg/cpptraj_prepare_and_analyze.in

module load plgrid/tools/python/3.8

python3 ../python_scripts/basic_validation.py -i *.csv
