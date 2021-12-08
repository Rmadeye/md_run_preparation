#!/usr/bin/bash

echo "***Checking if protein (prot.pdb) and ligand (lig.mol2, lig.frcmod) files (if necessary) are present...."

if [ -f "prot.pdb" ]; then
    echo "Protein file (prot.pdb) present."
else 
    echo "Protein file (prot.pdb) not present in directory. Add the file and rerun the script."
    exit 
fi
if [ -f "lig.mol2" -a -f "lig.frcmod" ]; then
    echo "Ligand files (lig.mol2 and lig.frcmod) present."
else 
    echo "Ligand files not found. You can continue if you analyze ligand-free system" 
fi


source ~/amber20/amber.sh || source ~/amber20_src/amber.sh


read -p 'Is ligand present? y/n: ' ligand_presence

if [ $ligand_presence = 'y' ]; then

read -p 'Set your grant name for CPU jobs: ' grantname
find .. -name "*.sh" -exec sed -i "s/grantid/$grantname/g" {} \;
echo $grantname set as default CPU grant
read -p 'Set your grant name for GPU jobs: ' grantnamegpu
find .. -name "*.sh" -exec sed -i "s/grantidgpu/$grantnamegpu/g" {} \;
echo $grantnamegpu set as default GPU grant
read -p 'Set number of cores for MM/GB(PB)SA : ' ncpus_short
find .. -name "*.sh" -exec sed -i "s/nodesnumber_short/$ncpus_short/g" {} \;
echo "$ncpus_short set as number of cores for MM/GB(PB)SA"

tleap -f ../MD_cfg/tleap.tleapin
ambpdb -p ../parms/topology.parm7 -c ../rst7s/coordinates.rst7 > input_complex.pdb
# read -p 'Set name of the ligand abbrv (UNL, MOL, UNK) : ' ligname
ligname=$(cat lig.mol2 | awk '//{print $2}' | tail -n 1)
#find .. -name "*.py" -exec sed -i "s/DEF/$ligname/g" {} \;
ligand_index="$(grep -i $ligname input_complex.pdb | awk '//{print $5}' | uniq | head -n 1)"
atom_count="$(grep -i $ligname input_complex.pdb | awk '//{print $2}' | tail -n 2 | head -n 1)"
echo $ligname set as ligand name, $atom_count set as printed number of atoms
echo "Preparing input files..."
read -p "Set filename for results: " results_filename
find . -name "*.sh" -exec sed -i "s/producer/$results_filename/g" {} \;
echo "Preparing residue indexes in MM/GB(PB)SA and CPPTRAJ input files..."
protein_residues_index=$(($ligand_index-1))

echo "Set of changes for MMGBSA"
find ../MMGBSA/ -name "*.sh" -exec sed -i "s/complex/$ligand_index/g" {} \;
find ../MMGBSA/ -name "*.sh" -exec sed -i "s/protein/$protein_residues_index/g" {} \;
find ../MMGBSA/ -name "*.sh" -exec sed -i "s/inputname/$results_filename/g" {} \;
read -p 'Set igb for MMGB(PB)SA:  (8 for anything but phosphates)' igb
find .. -name "*.in" -exec sed -i "s/igbset/$igb/g" {} \;
read -p 'Set calculation frame interval for MMGB(PB)SA:  (Default 10)' interval
find .. -name "*.in" -exec sed -i "s/intervalset/$interval/g" {} \;
read -p 'Set number of cpus used for MMGB(PB)SA calculations:  (Default 10)' ncpu_long
find .. -name "*.sh" -exec sed -i "s/mmgbsacpu/$ncpu_long/g" {} \;
echo "MMGB(PB)SA features set: ncpus $ncpu_long, igb = $igb, interval = $interval"
find .. -name "*.sh" -exec sed -i "s/cluster-name/`basename ${PWD%/*}`/g" {} \;
find .. -name "mmgbsa_local.sh" -exec sed -i "s/inputname/`basename ${PWD%/*}`/g" {} \;

echo "Set of changes for CPPTRAJ"
find ../MD_cfg/ -name "*.in" -exec sed -i "s/complex/$ligand_index/g" {} \;
find ../MD_cfg/ -name "*.in" -exec sed -i "s/protein/$protein_residues_index/g" {} \;
find ../MD_cfg/ -name "*.in" -exec sed -i "s/ligandindex/$ligand_index/g" {} \;
find ../MD_cfg/ -name "*.in" -exec sed -i "s/directoryname/$results_filename/g" {} \;
find ../MD_cfg/ -name "*.in" -exec sed -i "s/clusname/$ligname/g" {} \;

echo "Set of changes for input files"
read -p "Set minimisation steps (default 20000): " min_steps
# read -p "Set heating steps (default 50000): " hit_steps
read -p "Set production simulation length in ns: " prod_length
read -p "Set equilibration period truncated from production simulations in ns:  " equilperiodraw
equilperiod=$(($equilperiodraw*100))
conj_grad=$(($min_steps/2))
# nstlim_istep2=(($hit_length*500000))
nstlim_prod=$(($prod_length*500000))
sed -i "s/equilperiod/$equilperiod/g" ../MD_cfg/cpptraj_prepare_and_analyze.in
sed -i "s/minsteps/$min_steps/g" ../MD_cfg/min.in
sed -i "s/maxcycby2/$conj_grad/g" ../MD_cfg/min.in
sed -i "s/atoms_written_to_trajectory/$atom_count/g" ../MD_cfg/heat.in
sed -i "s/atoms_written_to_trajectory/$atom_count/g" ../MD_cfg/prod.in
sed -i "s/time_of_simulation/$nstlim_prod/g" ../MD_cfg/prod.in

echo "Set another features"

read -p "How many times you want to repeat production simulations? " reps_input

reps=$(seq $reps_input)

sed -i "s/reps/$reps_input/g" ../_3/prod.sh

for i in $reps; do
cp ../_3/prod_sbatch.sh ../_3/prod_sbatch_"$i".sh
sed -i "s/index/$i/g" ../_3/prod_sbatch_"$i".sh
done

ante-MMPBSA.py -p ../parms/topology.parm7 -c ../parms/stripped.topology.parm7 -s ':WAT,:Na+,:Cl-'

echo "**Preparation finished**"

elif [ $ligand_presence = 'n' ]; then

read -p 'Set your grant name for CPU jobs: ' grantname
find .. -name "*.sh" -exec sed -i "s/grantid/$grantname/g" {} \;
echo $grantname set as default CPU grant
read -p 'Set your grant name for GPU jobs: ' grantnamegpu
find .. -name "*.sh" -exec sed -i "s/grantidgpu/$grantnamegpu/g" {} \;
echo $grantnamegpu set as default GPU grant

sed -i "s/lig = loadmol2 lig.mol2//g" ../MD_cfg/tleap.in
sed -i "s/loadamberparams lig.frcmod//g" ../MD_cfg/tleap.in
sed -i "s/com = combine {prot, lig}//g" ../MD_cfg/tleap.in
sed -i "s/com/prot/g" ../MD_cfg/tleap.in
tleap -f ../MD_cfg/tleap.in
ambpdb -p ../parms/topology.parm7 -c ../rst7s/coordinates.rst7 > input_complex.pdb
read -p "Set filename for results: " results_filename
end_resid=$(grep Na+ input_complex.pdb | awk '//{print $5}' | head -n 1)
if [ -z "$end_resid" ]
then
end_resid=$(grep Cl- input_complex.pdb | awk '//{print $5}' | head -n 1)
if [ -z "$end_resid" ]
then 
end_resid=$(grep WAT input_complex.pdb | awk '//{print $5}' | head -n 1)
fi
fi

last_residue_index=$(($end_resid-1))
last_resid_name="$(grep -i "  $last_residue_index  " input_complex.pdb | awk '//{print $4}' | tail -n 1) "
atom_count="$(grep -i "  $last_residue_index  " input_complex.pdb | awk '//{print $2}' | tail -n 1) "

echo $last_resid_name $last_residue_index identified as N-capping aminoacid, $atom_count set as printed number of atoms


echo "Set of changes for CPPTRAJ"
find ../MD_cfg/ -name "*.in" -exec sed -i "s/complex/$last_residue_index/g" {} \;
find ../MD_cfg/ -name "*.in" -exec sed -i "s/protein/$last_residue_index/g" {} \;
#find ../MD_cfg/ -name "*.in" -exec sed -i "s/ligandindex/$ligand_index/g" {} \;
find ../MD_cfg/ -name "*.in" -exec sed -i "s/directoryname/$results_filename/g" {} \;
#find ../MD_cfg/ -name "*.in" -exec sed -i "s/clusname/$ligname/g" {} \;

echo "Set of changes for input files"
read -p "Set minimisation steps (default 20000): " min_steps
# read -p "Set heating steps (default 50000): " hit_steps
read -p "Set production simulation length in ns: " prod_length
conj_grad=$(($min_steps/2))
# nstlim_istep2=(($hit_length*500000))
nstlim_prod=$(($prod_length*500000))
sed -i "s/minsteps/$min_steps/g" ../MD_cfg/min.in
sed -i "s/maxcycby2/$conj_grad/g" ../MD_cfg/min.in
sed -i "s/atoms_written_to_trajectory/$atom_count/g" ../MD_cfg/heat.in
sed -i "s/atoms_written_to_trajectory/$atom_count/g" ../MD_cfg/prod.in
sed -i "s/time_of_simulation/$nstlim_prod/g" ../MD_cfg/prod.in

echo "Set another features"



read -p "How many times you want to repeat production simulations? " reps_input

reps=$(seq $reps_input)

sed -i "s/reps/$reps_input/g" ../_3/prod.sh

for i in $reps; do
cp ../_3/prod_sbatch.sh ../_3/prod_sbatch_"$i".sh
sed -i "s/index/$i/g" ../_3/prod_sbatch_"$i".sh
done

echo "Cleaning..."

rm -r ../MMGBSA/
rm ../MD_cfg/cpptraj_cluster.in
rm ../postprocessing/cluster_local.sh
rm ../postprocessing/cluster_plgrid.sh

ante-MMPBSA.py -p ../parms/topology.parm7 -c ../parms/stripped.topology.parm7 -s ':WAT,:Na+,:Cl-'

echo "**Preparation finished**"

else
echo "incorrect answer, quitting..."
exit
fi








