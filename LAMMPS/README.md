# LAMMPS

## Description

LAMMPS is a classical molecular dynamics code with a focus on materials modeling. It's an acronym for Large-scale Atomic/Molecular Massively Parallel Simulator.
This application is a software that is released under the GPLv2.

See [LAMMPS Home](https://lammps.sandia.gov/) for detail.

This is a set of scripts and documentations in order to build and execute faster this application on A64FX microprocessor with Fujitsu compiler.

## How to build 

The followings are build procedure by Fujitsu cross compiler.

### Requirements

- FUJITSU Software Compiler Package or Fujitsu Development Studio
- LAMMPS version 7Aug19 source: lammps-7Aug19.tar.gz
  - https://lammps.sandia.gov/tars/

- Input files for execution
  - CHUTE test: bench/in.chute.scaled (Included in source code package)

### Build procedure by cross compiler

```
  $ tar zxvf lammps-7Aug19.tar.gz
  $ cd lammps-7Aug19/src
  $ make yes-granular
  $ make yes-molecule
  $ make yes-kspace
  $ make yes-rigid
  $ make yes-manybody
  $ make yes-user-omp
  $ patch -p1 -i (somewhere)/lammps_7Aug19_aarch64_FCC.patch
  $ chmod 755 compile.sh
  $ ./compile.sh
```

## How to execute

```
  $ cd bench
  $ vi go.sh
    - Specify appropriate compiler path
  ===
  #!/bin/bash -x
  #PJM -N lmp
  #PJM -L rscgrp=48node-2
  #PJM -L rscunit=rscunit_ft01
  #PJM -L node=1
  #PJM --mpi proc=48
  #PJM -L elapse=0:10:00
  #PJM --no-stging
  #PJM -j
  #PJM -S

  cd ${PJM_O_WORKDIR:-'.'}

  export LANG=C

  LANG_HOME=/opt/FJSVxtclanga/tcsds-1.2.27a
  export OPAL_PREFIX=${LANG_HOME}
  export PATH=${LANG_HOME}/bin:${PATH}
  export LD_LIBRARY_PATH=${LANG_HOME}/lib64:${LD_LIBRARY_PATH}

  export PARALLEL=1
  export OMP_NUM_THREADS=${PARALLEL}
  export OMP_STACKSIZE=32m

  LD="../src/lmp_fj_fjmpi_clang_O3 -sf omp -pk omp ${PARALLEL}"
  IN="-in in.chute.scaled"

  mpiexec ${LD} ${ARG}
  ===
  $ vi in.chute.scaled
    - Change variable x and y from 1 to 20
  $ pjsub ./go.sh
```

## License
The contents in this directory are distributed under the GPLv2.
