#!/bin/bash
#SBATCH -A grantname
#SBATCH -n 1            # 8 cores
#SBATCH --time=00:20:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=r.madaj@uw.edu.pl
#SBATCH -J heating_rmadeye     # name of your job
#SBATCH --partition=plgrid-gpu-v100
#SBATCH --gres=gpu:1


module load amber/22.0-foss-2021b-ambertools-22.2-cuda-11.4.1


pmemd.cuda -O -i ../MD_cfg/heat.in -o heat.out -p ../parms/topology.parm7 -c ../rst7s/coordinates_min.rst7 -r ../rst7s/coordinates_heat.rst7 -inf info.inf -ref ../rst7s/coordinates_min.rst7

cpptraj -i ../MD_cfg/generate_minim_check_ntwprt.in