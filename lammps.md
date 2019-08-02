# LAMMPS Review

## Typical LAMMPS project structure

- each sim must be run in a new dir
- typical input files include:
  - structure.dat
    - size of system
    - num atoms
    - num atom types
    - masses
    - init positions/vel
  - in.filename
    - instructions of the tasks to perform
    - parameters
    - can also contain position of atoms
  - pot.mod
    - potential file
    - contains info on which potential to use

## Typical data file (SiO2.dat)

```python
# initial config of silica glass
3000 atoms
2 atom types

0.0 35.1 xlo xhi
...

Masses
1 28.0855 # Si
2 15.9994 # O

Atoms
# atom_num atom_type partial_charge x y z
1 1 partial_charge x y z
2 1 partial_charge x y z
2 2 partial_charge x y z
```

## Typical input file (in.glass)

```python
units           metal
dimension       3
processors      * * *
boundary        p p s

# read data
atom_style      charge # each atom has a charge
read_data       SiO2.dat # data file of the system

# potential -> link to valid potential file
include         pot.mod # what potentials are you using

# outputs
# information regarding the entire system
# request thermodynamic info every 100 steps
thermo          100
# what are the information you want about the system?
# custom I believe is a customly defined prop -> not that important
# lx -> size of system of x-axis
thermo_style    custom step temp pe press vol lx density
# generate dump files
# contains information for each atom (defined after id)
# in this case, for every 100 steps
dump            2 all custom 1000 md.lammpstrj id type x y z

# initial minimization
# energy minimization
minimize 1.0e-10 1.0e-10 100000 100000

# initial mixing
# do MD simulation in NVT ensemble (canonical)
# start at 5000K, finishes at 5000K
# damping factor of 100 -> 100 * dt (timestep)
# defines how often lammps adjusts the temp
# call the fix 1 which I think 'acts on all'
# each step is 1fs I believe (or whatever you define)
# use 'timestep dt' to define timestep
fix             1 all nvt temp 5000 5000 100
run             2000000
unfix           1

# here we are also keeping the pressure at 0
# pressure damping factor of 1000
fix             1 all npt temp 5000 5000 100 iso 0 0 1000
run             1000000
unfix           1

# cooling at 1 K/ps
fix             1 all npt temp 5000 300 100 iso 0 0 1000
run             1000000
unfix           1

# final relaxation
fix             1 all npt temp 300 300 100 iso 0 0 1000
run             1000000
unfix           1

# this is used to save the final configuration of the system
# saves the final positions of the atoms
# with the same conditions
# so you don't have to redo the simulation over again
# restart file is similar, but contains more information
# about the system
write_data      S300K.dat
write_restart   S300K.rest
```

## Energy minimization

- for all the atoms, lammps will figure out where to move them so that their energy is minimized
- at least a local minimum

## Typical Potential File (pot.mod)

```python
# BKS potential
# what type of potential we use
# last two numbers are cutoffs for the potentials
# distance-wise I believe
# if the distance is larger than these values, the potential is
# set to 0 to save computational time
# the buckingham pot contains multiple types of potentials
# inside: Coulomb and Buck
# we specify two cutoffs for each inner pot
pair_style      buck/coul/long 5.5 10.0

# what are the parameters used for the interactions
# specifically between specific particles
pair_coeff      1 1 0.0           1.0        0.0        # Si-Si
pair_coeff      1 2 414612.50     0.20520    3075.278   # Si-O
pair_coeff      2 2 31982.360     0.36231    4030.1136  # O-O

# MD parameters
# these were not covered in the lecture I watched
# timestep defines the integration timestep
# needs to be small enough so the numerical integration is correct
# 1[fs]
kspace_style    ewald 1.0e-5
neighbour       2.0 bin
neigh_modify    every 1 check yes
timestep        1.0
```

## Running simulations

```
lammps <in.filename> out.filename
```
