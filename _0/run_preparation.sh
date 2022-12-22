#!/usr/bin/bash

source ~/amber18/amber.sh || source /opt/apps/amber18/amber.sh

help() {
    echo "Usage: $1 <ligand presence (y/n)< $2 <output filename> $3 <MM/GBSA igb (5/8)>
     $4 <minimisation steps (default 20000)> $5 <simulation length (in ns)> $6 <equilibration period (in ns)>
     $7 <number of simulations (repetitions)>"
    }

if [[ $# < 7 ]]; then
    help
    exit 1
fi

echo "Prepare meta files"


if [ -f "prot.pdb" ]; then
    echo "Protein file (prot.pdb) present."
else 
    echo "Protein file (prot.pdb) not present in directory. Add the file and rerun the script."
    exit
fi 

ligand_presence=$1
output_filename=$2
igb=$3
min_steps=$4
declare -i prod_length=$5
equilperiodraw=$6
reps_input=$7

if [ $ligand_presence = 'y' ]; then
if [ -f "lig.mol2" -a -f "lig.frcmod" ]; then
    echo "Ligand files (lig.mol2 and lig.frcmod) present."
else 
    echo "Ligand files not found"
    exit 
fi

tleap -f ../MD_cfg/tleap.tleapin
parmed -i ../MD_cfg/parmed
ambpdb -p ../parms/topology.parm7 -c ../rst7s/coordinates.rst7 > input_complex.pdb
ligname=$(cat lig.mol2 | awk '//{print $2}' | tail -n 1)
ligand_index="$(grep -i $ligname input_complex.pdb | awk '//{print $5}' | uniq | head -n 1)"
protein_residues_index=$(($ligand_index-1))
if [ $(grep -i $ligname input_complex.pdb | awk '//{print $1}' | tail -n 1) = 'TER' ]; then
atom_count="$(grep -i $ligname input_complex.pdb | awk '//{print $2}' | tail -n 2 | head -n 1)"
else
atom_count="$(grep -i $ligname input_complex.pdb | awk '//{print $2}' | tail -n 1)"
fi
echo $ligname set as ligand name, $atom_count set as printed number of atoms
echo "Preparing input files..."
find .. -name "*.sh" -exec sed -i "s/producer/$output_filename/g" {} \;
echo "Set of changes for MMGBSA"

sed -i "s/complex/$ligand_index/g" ../MMGBSA/mmgbsa-input.sh 
sed -i "s/rmsfresidues/$ligand_index/g" ../python_scripts/basic_validation.py
sed -i "s/protein/$protein_residues_index/g" ../MMGBSA/mmgbsa-input.sh 
sed -i "s/inputname/$output_filename/g" ../MMGBSA/mmgbsa-input.sh 
find .. -name "*.in" -exec sed -i "s/igbset/$igb/g" {} \;
find .. -name "*.in" -exec sed -i "s/intervalset/10/g" {} \;
echo "MMGB(PB)SA features set:igb = $igb, interval = every 10th frame"
find .. -name "*.sh" -exec sed -i "s/clusteroutname/`basename ${PWD%/*}`/g" {} \;
sed -i "s/inputname/`basename ${PWD%/*}`/g" ../MMGBSA/mmgbsa-input.sh 
echo "Set of changes for CPPTRAJ"
find ../MD_cfg/ -name "*.in" -exec sed -i "s/complex/$ligand_index/g" {} \;
find ../MD_cfg/ -name "*.in" -exec sed -i "s/protein/$protein_residues_index/g" {} \;
find ../MD_cfg/ -name "*.in" -exec sed -i "s/ligandindex/$ligand_index/g" {} \;
find ../MD_cfg/ -name "*.in" -exec sed -i "s/directoryname/$output_filename/g" {} \;
find ../MD_cfg/ -name "*.in" -exec sed -i "s/clusname/$ligname/g" {} \;
echo "Set of changes for input files"
equilperiod=$(($equilperiodraw*100))
conj_grad=$(($min_steps/2))

nstlim_prod=$(($prod_length*500000))
sed -i "s/equilperiod/$equilperiod/g" ../MD_cfg/cpptraj_prepare_and_analyze.in
sed -i "s/minsteps/$min_steps/g" ../MD_cfg/min.in
sed -i "s/maxcycby2/$conj_grad/g" ../MD_cfg/min.in
sed -i "s/atoms_written_to_trajectory/$atom_count/g" ../MD_cfg/heat.in
sed -i "s/atoms_written_to_trajectory/$atom_count/g" ../MD_cfg/prod.in
sed -i "s/time_of_simulation/$nstlim_prod/g" ../MD_cfg/prod.in
reps=$(seq $reps_input)

for i in $reps; do
cp ../_3/prod_sbatch.sh ../_3/prod_sbatch_"$i".sh
sed -i "s/index/$i/g" ../_3/prod_sbatch_"$i".sh
done

ante-MMPBSA.py -p ../parms/topology.parm7 -c ../parms/stripped.topology.parm7 -s ':WAT,:Na+,:Cl-' -c ../parms/com.parm7 -m ":1-$protein_residues_index" -r ../parms/prot.parm7 -l ../parms/lig.parm7 --radii=mbondi2
#ante-MMPBSA.py -p ../parms/stripped.topology.parm7 -s "!(:1-"$ligand_index")" -c ../MMGBSA/com.parm7 -m ":1-"$protein_residues_index"" -r ../MMGBSA/prot.parm7 -l ../MMGBSA/lig.parm7 --radii=mbondi2

echo "**Preparation finished**"
elif [ $ligand_presence = 'n' ]; then

sed -i "s/lig = loadmol2 lig.mol2//g" ../MD_cfg/tleap.tleapin
sed -i "s/loadamberparams lig.frcmod//g" ../MD_cfg/tleap.tleapin
sed -i "s/com = combine {prot, lig}//g" ../MD_cfg/tleap.tleapin
sed -i "s/com/prot/g" ../MD_cfg/tleap.tleapin
sed -i "s/rms ligand_rmsd :ligandindex&!:H= ref [min] out directoryname.csv//g"
sed -i "s/surf SASA :ligandindex out directoryname.csv/''/g"
equilperiod=$(($equilperiodraw*100))
sed -i "s/equilperiod/$equilperiod/g" ../MD_cfg/cpptraj_prepare_and_analyze.in
pdb4amber -f prot.pdb -o prot_4amber.pdb -y 
mv prot.pdb prot_b4amber.pdb
mv prot_4amber.pdb prot.pdb
tleap -f ../MD_cfg/tleap.tleapin
#parmed -i ../MD_cfg/parmed
ambpdb -p ../parms/topology.parm7 -c ../rst7s/coordinates.rst7 > input_complex.pdb
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
last_resid_name=$(awk -v var=$last_residue_index '$5 ==var {print $4}' input_complex.pdb | head -n 1)
if [ $(grep -i $last_resid_name input_complex.pdb | awk '//{print $1}' | tail -n 1) = 'TER' ]; then
atom_count="$(grep -i $last_resid_name input_complex.pdb | awk '//{print $2}' | tail -n 2 | head -n 1)"
else
atom_count="$(grep -i $last_resid_name input_complex.pdb | awk '//{print $2}' | tail -n 1)"
fi
echo $last_resid_name $last_residue_index identified as N-capping aminoacid, $atom_count set as printed number of atoms
sed -i "s/atoms_written_to_trajectory/$atom_count/g" ../MD_cfg/heat.in
sed -i "s/atoms_written_to_trajectory/$atom_count/g" ../MD_cfg/prod.in
sed -i "s/:clusname/:1-$last_residue_index@C,CA,N,O"


echo "Set of changes for CPPTRAJ"
find ../MD_cfg/ -name "*.in" -exec sed -i "s/complex/$last_residue_index/g" {} \;
find ../MD_cfg/ -name "*.in" -exec sed -i "s/protein/$last_residue_index/g" {} \;
#find ../MD_cfg/ -name "*.in" -exec sed -i "s/ligandindex/$ligand_index/g" {} \;
find ../MD_cfg/ -name "*.in" -exec sed -i "s/directoryname/$output_filename/g" {} \;
find ../MD_cfg/ -name "*.in" -exec sed -i "s/clusname/$ligname/g" {} \;

echo "Set of changes for input files"
conj_grad=$(($min_steps/2))
# nstlim_istep2=(($hit_length*500000))
nstlim_prod=$(($prod_length*500000))  # 
sed -i "s/minsteps/$min_steps/g" ../MD_cfg/min.in
sed -i "s/maxcycby2/$conj_grad/g" ../MD_cfg/min.in
sed -i "s/atoms_written_to_trajectory/$atom_count/g" ../MD_cfg/heat.in
sed -i "s/atoms_written_to_trajectory/$atom_count/g" ../MD_cfg/prod.in
sed -i "s/time_of_simulation/$nstlim_prod/g" ../MD_cfg/prod.in

echo "Set another features"

reps=$(seq $reps_input)

for i in $reps; do
cp ../_3/prod_sbatch.sh ../_3/prod_sbatch_"$i".sh
cp ../_3/ares_run.sh ../_3/ares_run_"$i".sh
sed -i "s/index/$i/g" ../_3/prod_sbatch_"$i".sh
sed -i "s/index/$i/g" ../_3/ares_run_"$i".sh
done

echo "Cleaning..."
rm ../_3/prod_sbatch.sh
rm ../_3/ares_run.sh
rm -r ../MMGBSA/
rm ../MD_cfg/cpptraj_cluster.in
rm ../postprocessing/cluster_plgrid.sh

ante-MMPBSA.py -p ../parms/topology.parm7 -c ../parms/com.parm7 -s ':WAT,:Na+,:Cl-,:K+'

echo "**Preparation finished**"
fi

