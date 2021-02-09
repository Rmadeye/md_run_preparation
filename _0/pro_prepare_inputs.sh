#!/usr/bin/bash
module load plgrid/apps/amber/18 || source ~/amber20_src/amber.sh
ambpdb -p ../parms/lig-prot-solv.parm7 -c ../rst7s/lig-prot-solv.rst7 > input_complex.pdb
read -p 'Set your grant name for CPU jobs: ' grantname
find .. -name "*.sh" -exec sed -i "s/grantid/$grantname/g" {} \;
echo $grantname set as default CPU grant
read -p 'Set your grant name for GPU jobs: ' grantnamegpu
find .. -name "*.sh" -exec sed -i "s/grantidgpu/$grantnamegpu/g" {} \;
echo $grantnamegpu set as default GPU grant

python3 ../python_scripts/prepare_inputs.py
