**Minimisation input**
>&cntrl
>imin=1, | perform minimisation
> ntx=1, | read coordinates from rst7; 1  - formatted (default), 2 - unformatted
> ntc=1, | SHAKE algorithm to constrain bond distances. 1 - not performed
> ntf=1, | Force evaluation (1 - complete and thorough, 8 - ommit everything)
> ntb=1, | Periodic boundary (1 - constant volume, 2 - constant pressure). Dependant on ntp!
> ntp=0, | Constant pressure when ntb=2. 0 - no scaling, 1 - isotropic, (...)
> ntpr=100, | Print info to info.inf every n steps
> cut=9.0, | Nonbonded cutoff
> maxcyc=minsteps, | Steps of minimisation
> ncyc=maxcycby2,  | Steps of conjugate gradients
>/
**Heating input**
&cntrl
>imin=0,  | No minimisation
>ntx=1,   | Read coordinates from rst7
>ntb=1,   | Periodic boundary - constant volume
>cut=9.0, | Nonbonded cutoff
>ntp=0,   | No pressure scaling - constant volume conditions at ntb
>ntwprt=atoms_written_to_trajectory, | Save n atoms to trajectory file
>ntc=2, | SHAKE algorithm. 2 - only hydrogens
>ntf=2, | Evaluate all forces excluding hydrogens (NTC=2)
>ntt=3, | Thermostat of Langevin with collision frequency at gamma_ln
>gamma_ln=1.0, |  1ps
>nstlim=50000, | Steps of simulations. nstlim/1000*dt = n ns
>dt=0.002, | Timestep
>iwrap=1,  | Postprocessing nc and rst7 files to look better. Set 0 for diffusion processes
>ntpr=100, | Print info to info.inf every n steps
>ntwx=1000,| Write coordinates every n steps to .nc file
>ntwr=50000, | Write rst7 file every n steps
>ntr=1, | Use restraints, basing on structure from --ref flag
>restraint_wt=4.0, | Restraint force
>restraintmask='@CA,C,N', | Restraint mask
>ig=-1, | Stochastic simulation
>nmropt=1, | Read NMR restraints and weight changes
>/
>&wt type='TEMP0', istep1=0, istep2=half_of_nstlim, value1=50.0, value2=300.0 / | Change temp from 50 to 300 in steps
>&wt type='END' / | end changes
**Simulation input**
>imin=0,  | No minimisation
>ntx=1,   | Read coordinates from rst7
>irest=0, | Do not restart simulation from input rst7 file
>ntwprt=atoms_written_to_trajectory, | Save n atoms to trajectory file
>ntb=2,   | Periodic boundary - constant pressure
>ntp=1,   | Isotropic scaling pressure
>barostat=2, | MC barostat - only when temperature equilibrated
>cut=9.0, | Nonbonded cutoff
>ntc=2,   | SHAKE hydrogens
>ntf=2,   | Evaluate all forces except hydrogens
>ntt=3,   | Langevin thermostat
>temp0=300.0, | Initial temp in K
>tempi=300.0, | Final temp in K
>gamma_ln=2.0,| Collision frequency
>nstlim=time_of_simulation, | Steps of simulations. nstlim/1000*dt = n ns
>dt=0.002, | Timestep in ps
>iwrap=1,  | Postprocessing nc and rst7 files to look better. Set 0 for diffusion processes
>ioutfm=1, | Trajectory file in binary nc format
>ntpr=5000,| Print info to info.inf every n steps
>ntwx=5000,| Write coordinates every n steps to .nc file
>ntwr=5000,| Write rst7 file every n steps
>ntr=0,    | Non-restraint MD
>nmropt=0, | No NMR weight changes
>ig=-1     | Stochastic simulation
>/