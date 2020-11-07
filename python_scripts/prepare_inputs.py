#!/usr/bin/env python3
import numpy as np
import sys

def find_ligand_residue_number(file: str) -> int:
    resn = ['UNL', 'UNK', 'LIG']
    with open(file, "r") as ligfile:
        for line in ligfile:
            line = line.split()
            if line[3] in resn:
                return int(line[4])

def set_ntwprt_number(file: str) -> int:
    atom_count = []
    resn = ['UNL', 'UNK', 'LIG']
    with open(file, "r") as ligfile:
        for line in ligfile:
            line = line.split()
            if line[0] == "ATOM":
                if line[3] in resn:
                    atom_count.append(line[1])
    return int(max(atom_count))

def apply_residue_index_to_config_files(resi: int) -> int:
    outputdf_name = input("Set the name for results file: ")
    with open('../MMGBSA/default-input.sh', 'r') as file:
        print(f"Ligand residue index: {resi}")
        try:
            text = file.read().replace('protein',str(resi-1)).replace('complex',str(resi))
        except:
            print("No inputs modified")

    with open('../MD_cfg/cpptraj_generate_pdb_and_check_traj.in', 'r') as file:
        cpin = file.read().replace('complex',str(resi))

    with open('../MD_cfg/cpptraj_prepare_and_analyze.in', 'r') as file:
        cpan = file.read().replace('complex',str(resi)
                                   ).replace('ligandindex', str(resi)
                                             ).replace('directoryname',outputdf_name)

    with open('../MMGBSA/analyze.sh', 'w') as output_file:
        output_file.write(text)

    with open('../MD_cfg/check_2.in', 'w') as output_cpptrajcheck:
        output_cpptrajcheck.write(cpin)

    with open('../MD_cfg/analyze_cpptraj.in', 'w') as output_cpptraj_input_instructions:
        output_cpptraj_input_instructions.write(cpan)

def apply_atom_count_to_md_inputs_and_production_length(atom_count: int) -> int:
    time_of_simulation = int(input("Set simulation time in nanoseconds: "))*500000
    print(f"Warning! nstlim variable set to {time_of_simulation}")
    with open('../MD_cfg/heat_sample.in', 'r') as file:
        print(f"Input atom count: {atom_count}")
        try:
            heating = file.read().replace('atoms_written_to_trajectory',
                                       str(atom_count))
        except Exception as e:
            print(e)
    with open('../MD_cfg/prod_sample.in', 'r') as file:
        try:
            production = file.read().replace('atoms_written_to_trajectory',
                                       str(atom_count)).replace('time_of_simulation',str(time_of_simulation))
        except Exception as e:
            print(e)
    with open('../MD_cfg/heat.in', 'w') as heating_cfg:
        heating_cfg.write(heating)
    with open('../MD_cfg/prod.in', 'w') as production_cfg:
        production_cfg.write(production)
        
    return 0

if __name__ == '__main__':
    apply_residue_index_to_config_files(find_ligand_residue_number('../_1/integrity_check.pdb'))
    apply_atom_count_to_md_inputs_and_production_length(set_ntwprt_number('../_1/integrity_check.pdb'))