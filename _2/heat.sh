#!/usr/bin/bash

source ~/amber20_src/amber.sh

mpirun -np 8 pmemd.MPI -O -i ../MD_cfg/heat.in -o heat.out -p ../parms/lig-prot-solv.parm7 -c ../rst7s/lig-prot-solv_min.rst7 -r ../rst7s/lig-prot-solv_heat.rst7 -inf info.inf -ref ../rst7s/lig-prot-solv_min.rst7

cpptraj -i ../MD_cfg/cpptraj_generate_pdb_and_check_traj.in