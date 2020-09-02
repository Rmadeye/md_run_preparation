source ~/amber18/amber.sh

filename=`basename ${PWD%/*}`;


output="$filename"\_long.nc


pmemd.cuda -O -i ../MD_cfg/long.in -o long.out -p ../lig-prot-solv.parm7 -c ../_2/lig-prot-solv_heat.rst7 -r long.rst7 -inf info.inf -x "$output"

