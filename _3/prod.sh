source ~/amber20_src/amber.sh

filename=`basename ${PWD%/*}`;

for i in {1..10}; do

echo 'Job number being done:' $i
output="$filename"\_$i.nc

pmemd.cuda -O -i ../MD_cfg/prod.in -o prod.out -p ../parms/lig-prot-solv.parm7 -c ../rst7s/lig-prot-solv_heat.rst7 -r lig-prot-solv_"$i".rst7 -inf info.inf -x "$output"

done

cpptraj -i ../MD_cfg/cpptraj_prepare_and_analyze.in
