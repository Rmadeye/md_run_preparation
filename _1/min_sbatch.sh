#!/bin/bash
#SBATCH -p cpu          # CPU partition
#SBATCH -n 8            # 8 cores
#SBATCH --exclude=edi00
#SBATCH --mem=8GB      # 8 GB of RAM
#SBATCH -J minimisation_rmadeye     # name of your job


source /opt/apps/amber18/amber.sh

echo "lipid-water minimalisation"
mpirun -np 8  pmemd.MPI -O -i ../MD_cfg/min_lipid_water.in -o min1.out -p ../parms/topology.parm7 -c ../rst7s/coordinates.rst7 -r ../rst7s/coordinates_lipid.rst7 -inf info.inf 
echo "protein minimalisation"
mpirun -np 8  pmemd.MPI -O -i ../MD_cfg/min_prot.in -o min2.out -p ../parms/topology.parm7 -c ../rst7s/coordinates_lipid.rst7 -r ../rst7s/coordinates_prot.rst7 -inf info.inf 
echo "system minimalisation"
mpirun -np 8  pmemd.MPI -O -i ../MD_cfg/min_system.in -o min3.out -p ../parms/topology.parm7 -c ../rst7s/coordinates_prot.rst7 -r ../rst7s/coordinates_min.rst7 -inf info.inf 

ambpdb -p ../parms/topology.parm7 -c ../rst7s/coordinates_min.rst7 > integrity_check.pdb


sed '/Na+/,$d;/Cl-/,$d;/K+/,$d;' integrity_check.pdb > ../postprocessing/minim.pdb