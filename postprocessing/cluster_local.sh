#!/bin/bash -l

cp ../parms/stripped.lig-prot-solv.parm7 merged_centered.nc ../MD_cfg/cpptraj_cluster.in ./

mpirun -np 8 cpptraj.MPI -i cpptraj_cluster.in


