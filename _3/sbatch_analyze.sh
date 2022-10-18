#!/bin/bash

source /opt/apps/amber20/amber.sh | module load amber/20.12-intel-2021b-ambertools-21.12

parmed -i ../MD_cfg/topology_pdbdetails

cpptraj -i ../MD_cfg/cpptraj_prepare_and_analyze.in
#python3 ../basic_validation.py -i *.csv
