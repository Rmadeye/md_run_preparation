#!/bin/bash

source /opt/apps/amber20/amber.sh
cpptraj -i ../MD_cfg/cpptraj_prepare_and_analyze.in
python3 ../basic_validation.py -i *.csv
