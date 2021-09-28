#!/usr/bin/bash
module load plgrid/apps/amber/20 || source ~/amber20_src/amber.sh || source ~/amber20/amber.sh
ambpdb -p ../parms/lig-prot-solv.parm7 -c ../rst7s/lig-prot-solv.rst7 > input_complex.pdb
#ante-MMPBSA.py -p ../parms/lig-prot-solv.parm7 -c ../parms/stripped.lig-prot-solv.parm7 -s ':WAT,:Na+,:Cl-'
read -p 'Set your grant name for CPU jobs: ' grantname
find .. -name "*.sh" -exec sed -i "s/grantid/$grantname/g" {} \;
echo $grantname set as default CPU grant
read -p 'Set your grant name for GPU jobs: ' grantnamegpu
find .. -name "*.sh" -exec sed -i "s/grantidgpu/$grantnamegpu/g" {} \;
echo $grantnamegpu set as default GPU grant
read -p 'Set number of cores for MM/GB(PB)SA : ' ncpus_short
find .. -name "*.sh" -exec sed -i "s/nodesnumber_short/$ncpus_short/g" {} \;
echo "$ncpus_short set as number of cores for MM/GB(PB)SA"

read -p 'Is ligand present? y/n: ' ligand_presence
if [ $ligand_presence = 'y' ]; then
# read -p 'Set name of the ligand abbrv (UNL, MOL, UNK) : ' ligname
ligname=$(cat lig.mol2 | awk '//{print $2}' | tail -n 1)
#find .. -name "*.py" -exec sed -i "s/DEF/$ligname/g" {} \;
ligand_index="$(grep -i $ligname input_complex.pdb | awk '//{print $5}' | uniq | head -n 1)"
atom_count="$(grep -i $ligname input_complex.pdb | awk '//{print $2}' | tail -n 2 | head -n 1)"
echo $ligname set as ligand name, $atom_count set as printed number of atoms
echo "Preparing input files..."
read -p "Set filename for results: " results_filename
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



elif [ $ligand_presence = 'n' ]; then
echo "dupa"
else
echo "incorrect answer, quitting..."
fi








