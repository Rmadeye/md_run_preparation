#!/usr/bin/bash
module load plgrid/apps/amber/20 || source ~/amber20_src/amber.sh || source ~/amber20/amber.sh
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
read -p 'Set name of the ligand unless standard (UNL, MOL, UNK) : ' ligname
find .. -name "*.py" -exec sed -i "s/DEF/$ligname/g" {} \;
echo $ligname set as ligand name


python3 ../python_scripts/prepare_inputs.py
ante-MMPBSA.py -p ../parms/lig-prot-solv.parm7 -c ../parms/stripped.lig-prot-solv.parm7 -s ':WAT,:Na+,:Cl-'
read -p 'Set production time to be analyzed (ns) : ' prodtime
find .. -name "*.*" -exec sed -i "s/productiontime/$prodtime/g" {} \;
echo $prodtime set as time for basic analysis
read -p 'Set number of residues for RMSF analysis : ' rmsfresidues
find .. -name "*.py" -exec sed -i "s/rmsfresidues/$rmsfresidues/g" {} \;
echo $rmsfresidues set as number of residues for RMSF study
read -p 'Set residue/ligand name for cluster analysis : ' clusname
find .. -name "*.*" -exec sed -i "s/clusname/$clusname/g" {} \;
echo $clusname set as cluster analysis reference
echo "***Set MM/GB(PB)SA calculations***"
read -p 'Set igb for MMGB(PB)SA:  (8 for anything but phosphates)' igb
find .. -name "*.in" -exec sed -i "s/igbset/$igb/g" {} \;
read -p 'Set calculation frame interval for MMGB(PB)SA:  (Default 10)' interval
find .. -name "*.in" -exec sed -i "s/intervalset/$interval/g" {} \;
read -p 'Set number of cpus used for MMGB(PB)SA calculations:  (Default 10)' ncpu_long
find .. -name "*.sh" -exec sed -i "s/mmgbsacpu/$ncpu_long/g" {} \;
echo "MMGB(PB)SA features set: ncpus $ncpu_long, igb = $igb, interval = $interval"
find .. -name "*.sh" -exec sed -i "s/cluster-name/`basename ${PWD%/*}`/g" {} \;




