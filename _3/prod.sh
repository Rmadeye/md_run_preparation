#!/bin/bash

source ~/amber20/amber.sh

filename=`basename ${PWD%/*}`;

for i in {1..reps}; do

echo 'Job number being done:' $i
output="$filename"\_$i.nc

pmemd.cuda -O -i ../MD_cfg/prod.in -o prod.out -p ../parms/topology.parm7 -c ../rst7s/coordinates_heat.rst7 -r ../rst7s/coordinates_"$i".rst7 -inf info.inf -x "$output"

done

cpptraj -i ../MD_cfg/analyze_cpptraj.in
