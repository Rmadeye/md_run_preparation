#!/bin/bash -l

cp ../parms/stripped.lig-prot-solv.parm7 merged_centered.nc ../MD_cfg/cluster_cpptraj.in ./

mpirun -np 8 cpptraj.MPI -i cluster_cpptraj.in


