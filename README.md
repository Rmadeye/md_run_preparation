# Script preparing inputs and bash scripts for Amber20 MDS and postprocessing

###### **Workflow**
1. Run prepare_md_dir.sh script and choose name for the directory
2. Activate amber environment (e.g. source ~/Amber20_src/amber.sh)
3. Prepare trajectory and input coordinates of the complex using tleap:
- Divide complex pdb into two files: protein.pdb and ligand.pdb and put them in main working directory.
- Protonate your structure using pdb2pqr server. **Remember to choose AMBER naming scheme**. Save it as prot.pqr 
- Calculate charges for your ligand using antechamber. Using default parameters and with neutral protonation state:\
*antechamber -i ligand.pdb -fi pdb -o lig.mol2 -fo mol2 -c bcc* && *parmchk2 -i lig.mol2 -f mol2 -o lig.frcmod*
- Create complex trajectory and input coordinates: tleap -f MD_cfg/tleap.in\
**Put lig-prot-solv.parm7 to parms directory and lig-prot-solv.rst7 to rst7s directory**
###### **Running simulations**
1. Run minimisation of the system using script from _1
2. After the minimisation script will ask you for simulation time (equilibration and production) and name for the results files
3. Run heat.sh from _2; if checked_confirmed.nc file appears, everything is all right
4. Run prod.sh from _3. This is you equilibration and production simulation. In default 10 ns of the trajectory is truncated.
5. In theory, the basic analysis of your production file is done and can be found in postprocessing dir.
6. To perform MM/GBSA analysis, use analyze script from MMGBSA directory
###### **Disclaimer**

This is a script I wrote for myself to speed up my work - I assume you have already read Amber tutorials and manuals and you are aware what you need to change to satisfy your needs.\
So far it wasn't thoroughly tested and may fail at several points - then it's up to you to apply changes or let me know what can be done for improvement.
The script automatically removes any water and ions from the trajectories to save disk space. If you want to have these molecules - change ntwprt to 0. 


Have fun! 