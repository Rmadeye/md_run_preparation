#!/bin/bash

source ~/amber20/amber.sh

filename=`basename ${PWD%/*}`;

for i in {1..reps}; do

echo 'Job number being done:' $i
output="$filename"\_$i.nc

pmemd.cuda -O -i ../MD_cfg/prod.in -o prod.out -p ../parms/lig-prot-solv.parm7 -c ../rst7s/lig-prot-solv_heat.rst7 -r ../rst7s/lig-prot-solv_"$i".rst7 -inf info.inf -x "$output"

done

cpptraj -i ../MD_cfg/analyze_cpptraj.in
