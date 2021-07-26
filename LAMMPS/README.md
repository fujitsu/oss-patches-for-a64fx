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

- Input files for execution (Included in the source code package)
  - CHUTE test: bench/in.chute.scaled
  - CHAIN test: bench/in.chain.scaled
  - LJ test: bench/in.lj

### Build procedure by cross compiler

The build procedure is different depending on the tests.

For CHUTE test:

```
  $ tar zxvf lammps-7Aug19.tar.gz
  $ cd lammps-7Aug19/src
  $ make yes-granular
  $ make yes-molecule
  $ make yes-kspace
  $ make yes-rigid
  $ make yes-manybody
  $ make yes-user-omp
  $ patch -p1 -i (somewhere)/lammps_7Aug19_CHUTE_aarch64_FCC.patch
  $ chmod 755 compile.sh
  $ ./compile.sh
```

For CHAIN test:

```
  $ tar zxvf lammps-7Aug19.tar.gz
  $ cd lammps-7Aug19/src
  $ make yes-granular
  $ make yes-molecule
  $ make yes-kspace
  $ make yes-rigid
  $ make yes-manybody
  $ make yes-user-omp
  $ make yes-user-intel
  $ patch -p1 -i (somewhere)/lammps_7Aug19_CHAIN_aarch64_FCC.patch
  $ chmod 755 compile.sh
  $ ./compile.sh
```

For LJ test:

```
  $ tar zxvf lammps-7Aug19.tar.gz
  $ cd lammps-7Aug19/src
  $ make yes-granular
  $ make yes-molecule
  $ make yes-kspace
  $ make yes-rigid
  $ make yes-manybody
  $ make yes-user-omp
  $ make yes-user-intel
  $ patch -p1 -i (somewhere)/lammps_7Aug19_LJ_aarch64_FCC.patch
  $ chmod 755 compile.sh
  $ ./compile.sh
```

You can see the tuning details for CHAIN and LJ in [here](https://www.hpci-office.jp/invite2/documents2/meeting_A64FX_210427/lmp_tune_for_a64fx_27Apr2021_final.pdf).

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

  LANG_HOME=/opt/FJSVxtclanga/tcsds-1.2.31
  export OPAL_PREFIX=${LANG_HOME}
  export PATH=${LANG_HOME}/bin:${PATH}
  export LD_LIBRARY_PATH=${LANG_HOME}/lib64:${LD_LIBRARY_PATH}

  export PARALLEL=1
  export OMP_NUM_THREADS=${PARALLEL}
  export OMP_STACKSIZE=32m

  # For CHUTE test
  LD="../src/lmp_fj_fjmpi_clang_O3 -sf omp -pk omp ${PARALLEL}"
  IN="-in in.chute.scaled"
  # For CHAIN and LJ test
  LD="../src/lmp_fj_fjmpi_clang_O3 -sf intel -pk intel 0 omp ${PARALLEL} mode double"
  IN="-in in.chain.scaled"
  IN="-in in.lj"

  mpiexec ${LD} ${ARG}
  ===
  $ vi in.chute.scaled
    - Change variable x and y from 1 to 20
  $ vi in.chain.scaled
    - Change variable x, y and z from 1 to 4
  $ vi in.lj
    - Change variable x, y and z from 1 to 4
  $ pjsub ./go.sh
```

## License
The contents in this directory are distributed under the GPLv2.
