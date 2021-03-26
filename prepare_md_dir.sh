#!/usr/bin/bash

read -p 'Directory name: ' dirname

mkdir $dirname

cd $dirname
mkdir parms rst7s

cp -r ~/scripts/MD_prep/_0 ~/scripts/MD_prep/_1 ~/scripts/MD_prep/_2 ~/scripts/MD_prep/_3 ~/scripts/MD_prep/MMGBSA/ ~/scripts/MD_prep/postprocessing ./
cp -r ~/scripts/MD_prep/MD_cfg/ ./
cp -r ~/scripts/MD_prep/python_scripts/ ./




