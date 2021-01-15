# SPECFEM3D GLOBE

## Description

SPECFEM3D_GLOBE simulates global and regional (continental-scale) seismic wave propagation.
This application is a software that is released under the GPLv3.

See [SPECFEM3D GLOBE Home](https://geodynamics.org/cig/software/specfem3d_globe/) for detail.

This is a set of scripts and documentations in order to build and execute faster this application on A64FX microprocessor with Fujitsu compiler.

## How to build 

The followings are build procedure by Fujitsu native compiler.

### Requirements

- FUJITSU Software Compiler Package or Fujitsu Development Studio
- SPECFEM3D GLOBE v7.0.2 source
  - https://github.com/geodynamics/specfem3d_globe

- Input files
  - TestCaseC in PRACE Benchmark suite
  - https://repository.prace-ri.eu/git/UEABS/ueabs/

### Build procedure by native compiler

```
  $ unzip specfem3d_globe-master.zip
  $ cd specfem3d_globe-master
  $ patch -p1 -i (somewhere)/specfem3d_globe-master-01tune.patch
  $ cd ..
  $ mv specfem3d_globe-master specfem3d_globe
  $ cd ${your_work_directory}
  $ cp -p (somewhere)/ueabs-master.tar.gz
  $ tar zxvf ueabs-master.tar.gz
  $ cd ueabs-master
  $ patch -p1 -i (somewhere)/ueabs-master-00orig.patch
  $ cd specfem3d
  $ vi compile.sh
    - line 14: Modify the compiler path
    - line 49: Specify the directory of source code
  $ vi env/env_a64fx
    - line 3 : Specify the directory of source code
  $ pjsub ./compile.sh
```

## How to execute

```
  $ cd benchmarks/a64fx/specfem3d_globe/31octobre/TestCaseC/specfem3d_globe
  $ vi go.sh
  ===
  #!/bin/bash -x
  #PJM -N specfem3d
  #PJM -L rscgrp=def_grp
  #PJM -L rscunit=rscunit_ft01
  #PJM -L node=1
  #PJM --mpi proc=4
  #PJM -L elapse=0:15:00
  #PJM --no-stging
  #PJM -j

  cd ${PJM_O_WORKDIR:-'.'}

  export UTOFU_USE_DD=0
  export UTOFU_WA_IDATA=1

  export LANG=C

  LANG_HOME=/opt/FJSVxtclanga/tcsds-1.1.10
  export OPAL_PREFIX=${LANG_HOME}
  export PATH=${LANG_HOME}/bin:${PATH}
  export LD_LIBRARY_PATH=${LANG_HOME}/lib64:${LD_LIBRARY_PATH}

  export MESHER_EXE=./bin/xmeshfem3D
  export SOLVER_EXE=./bin/xspecfem3D

  export PARALLEL=12
  export OMP_NUM_THREADS=${PARALLEL}
  export OMP_STACKSIZE=32m

  # backup files used for this simulation
  cp DATA/Par_file OUTPUT_FILES/
  cp DATA/STATIONS OUTPUT_FILES/
  cp DATA/CMTSOLUTION OUTPUT_FILES/

  mpiexec ${MESHER_EXE}
  mpiexec ${SOLVER_EXE}

  date
  ===
  $ pjsub ./go.sh
```

## License
The contents in this directory are distributed under the GPLv3.
