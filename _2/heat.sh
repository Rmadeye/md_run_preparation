#!/usr/bin/bash

source ~/amber20/amber.sh

pmemd.cuda -O -i ../MD_cfg/heat.in -o heat.out -p ../parms/topology.parm7 -c ../rst7s/coordinates_min.rst7 -r ../rst7s/coordinates_heat.rst7 -inf info.inf -ref ../rst7s/coordinates_min.rst7

cpptraj -i ../MD_cfg/check_2.in
