#!/usr/bin/bash
module load plgrid/apps/amber/18 || source ~/amber20_src/amber.sh || source ~/amber20/amber.sh
ambpdb -p ../parms/lig-prot-solv.parm7 -c ../rst7s/lig-prot-solv.rst7 > input_complex.pdb
read -p 'Set your grant name for CPU jobs: ' grantname
find .. -name "*.sh" -exec sed -i "s/grantid/$grantname/g" {} \;
echo $grantname set as default CPU grant
read -p 'Set your grant name for GPU jobs: ' grantnamegpu
find .. -name "*.sh" -exec sed -i "s/grantidgpu/$grantnamegpu/g" {} \;
echo $grantnamegpu set as default GPU grant
read -p 'Set number of cores for plgrid-short : ' ncpus_short
find .. -name "*.sh" -exec sed -i "s/nodesnumber_short/$ncpus_short/g" {} \;
echo $ncpus_short set as number of cores for plgrid-short partition

python3 ../python_scripts/prepare_inputs.py
ante-MMPBSA.py -p ../parms/lig-prot-solv.parm7 -c ../parms/stripped.lig-prot-solv.parm7 -s ':WAT,:Na+,:Cl-'

echo "***Set MM/GB(PB)SA calculations***"
read -p 'Set igb for MMGB(PB)SA:  (8 for anything but phosphates)' igb
find .. -name "*.in" -exec sed -i "s/igbset/$igb/g" {} \;
read -p 'Set calculation frame interval for MMGB(PB)SA:  (Default 10)' interval
find .. -name "*.in" -exec sed -i "s/intervalset/$interval/g" {} \;
read -p 'Set number of cpus used for MMGB(PB)SA calculations:  (Default 10)' ncpu_long
find .. -name "*.sh" -exec sed -i "s/mmgbsacpu/$ncpu_long/g" {} \;
echo "MMGB(PB)SA features set: ncpus $ncpu_long, igb = $igb, interval = $interval"
find .. -name "*.sh" -exec sed -i "s/cluster-name/`basename ${PWD%/*}`/g" {} \;




