#!/usr/bin/bash

read -p 'Directory name: ' dirname

mkdir $dirname

cd $dirname
mkdir parms rst7s

cp -r ~/scripts/md_run_preparation/_0 ~/scripts/md_run_preparation/_1 ~/scripts/md_run_preparation/_2 ~/scripts/md_run_preparation/_3 ~/scripts/md_run_preparation/MMGBSA/ ~/scripts/md_run_preparation/postprocessing ./
cp -r ~/scripts/md_run_preparation/MD_cfg/ ./
cp -r ~/scripts/md_run_preparation/python_scripts/ ./




