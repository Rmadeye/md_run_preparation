source ~/amber18/amber.sh

mpirun -np 8 pmemd.MPI -O -i ../MD_cfg/heat.in -o heat.out -p ../lig-prot-solv.parm7 -c ../_1/lig-prot-solv_min.rst7 -r lig-prot-solv_heat.rst7 -inf info.inf -ref ../_1/lig-prot-solv_min.rst7
