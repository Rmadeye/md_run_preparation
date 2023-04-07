# Script preparing inputs and bash scripts for Amber20 MDS and postprocessing

###### **Workflow**
1. Activate amber environment (e.g. source ~/Amber20_src/amber.sh)
2. In directory *_0* prepare files containing receptor (prot.pdb) and, if required, ligand (lig.mol2 and lig.frcmod)
- For protein it can be pdb file that voids ligands and, preferably, missing residues. 
- It's advised to either protonate structure using some server (e.g. pdb2pqr) or remove all hydrogens and let AMBER do the work
- Calculate charges for your ligand using antechamber. Using default parameters and with neutral protonation state:\
'antechamber -i ligand.pdb -fi pdb -o lig.mol2 -fo mol2 -c bcc && parmchk2 -i lig.mol2 -f mol2 -o lig.frcmod'
or use respgeninput for RESP charges generation.
gesp files you can convert using:
'''antechamber -i ligand.gesp -fi gesp -o lig.mol2 -fo mol2 -c resp -nc 0 && parmchk2 -i lig.mol2 -f mol2 -o lig.frcmod'''
Of course always check the lig.mol2 for potential artifacts.
3. Run run_preparation.sh and follow instructions.
- in default, protein/complex is put in octahedric box with 12A of boundary.
###### **Running simulations**
1. Run minimisation of the system using script from _1
3. Run heat.sh from _2; if checked_confirmed.nc file appears, everything is all right
4. Run prod.sh from _3. This is you equilibration and production simulation. In default 10 ns of the trajectory is truncated.
5. In theory, the basic analysis of your production file is done and can be found in postprocessing dir.
6. To perform MM/GBSA analysis, use scripts from MMGBSA directory
###### **Disclaimer**

This is a script I wrote for myself to speed up my work - I assume you have already read Amber tutorials and manuals and you are aware what you need to change to satisfy your needs. I take no responsibility for any failures :) \
So far it wasn't thoroughly tested and may fail at several points - then it's up to you to apply changes or let me know what can be done for improvement.
The script automatically removes any water and ions from the trajectories to save disk space. If you want to have these molecules - change ntwprt to 0. 
If you intend to use these script at computational cloud with SLURM, make sure that sbatch files are formatted correctly.


Have fun! 
RM