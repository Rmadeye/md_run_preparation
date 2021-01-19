#!/usr/bin/bash

read -p 'Directory name: ' dirname

mkdir $dirname

cd $dirname
mkdir parms rst7s

cp -r ~/bash/MD_prep/_1 ~/bash/MD_prep/_2 ~/bash/MD_prep/_3 ~/bash/MD_prep/MMGBSA/ ./
cp -r ~/bash/MD_prep/MD_cfg/ ./
cp -r ~/bash/MD_prep/python_scripts/ ./




