#!/bin/bash

source ~/amber20/amber.sh || source /opt/apps/amber20/amber.sh || module load amber/22.1-intel-2021b-ambertools-22.3-updated-cpptraj

help() {
    echo "Usage: $0 <filename> <extension> <charge>"
}

if [[ $# < 2 ]]; then
    help
    exit 1
fi

filename=$1
extension=$2
charge=$3

g1="%nproc=24"
g2="%chk=molecule"
g3="%mem=2gb"
g4="#HF\/6-31G* SCF=tight Test NoSymm Pop=MK  iop(6\/33=2,6\/42=6,6\/50=1)"

filename_base=`basename $filename ."$extension"`

antechamber -i $filename -fi $extension -o $filename_base.com -fo gcrt -gv 1 -ge $filename_base.gesp -nc $charge

sed -i "1d" $filename_base.com
sed -i "1s/.*/$g1/g" $filename_base.com
sed -i "2s/.*/$g2/g" $filename_base.com
sed -i "3s/.*/$g3/g" $filename_base.com
sed -i "4s/.*/$g4/g" $filename_base.com
sed -i "5s/.*//g" $filename_base.com

