# MPAS Atmosphere

## Description

The atmospheric component of MPAS, as with all MPAS components, uses an unstructured centroidal Voronoi mesh (grid, or tessellation) and C-grid staggering of the state variables as the basis for the horizontal discretization in the fluid-flow solver.
MPAS license can be seen in [MPAS Home](https://mpas-dev.github.io/).
(MPAS Home -> License Information)

See [MPAS Home](https://mpas-dev.github.io/) for detail.

This is a set of scripts and documentations in order to build and execute faster this application on A64FX microprocessor with Fujitsu compiler.

## How to build 

The followings are build procedure by Fujitsu cross compiler.

### Requirements

- FUJITSU Software Compiler Package or Fujitsu Development Studio
- MPAS Atmosphere version 6.2 source
  - https://github.com/MPAS-Dev/MPAS-Model/releases
- MPAS-Data-master.zip
  - https://github.com/MPAS-Dev/MPAS-Data
- NetCDF C version 4.3.3 or later
  - https://www.unidata.ucar.edu/downloads/netcdf/
- NetCDF Fortran version 4.3.3 or later
  - https://www.unidata.ucar.edu/downloads/netcdf/
- Parallel-NetCDF version 1.6.0 or later
  - http://cucis.ece.northwestern.edu/projects/PnetCDF/download.html
- ParallelIO version 2.4.0 or later
  - http://ncar.github.io/ParallelIO

- Input files for execution
  - Jablonowski and Williamson baroclinic wave
  - https://mpas-dev.github.io/

### Build procedure by cross compiler

```
  $ tar zxvf MPAS-Model-6.2.tar.gz
  $ cd MPAS-Model-6.2
  $ patch -p1 -i (somewhere)/MPAS-atomosphere_6.2_AArch64_frt.patch
  $ cd ..
  $ unzip MPAS-Data-master.zip
  $ cp -rp MPAS-Data-master/atmosphere/physics_wrf/files MPAS-Model-6.2/src/core_atmosphere/physics/physics_wrf/
  $ cp -rp MPAS-Model-6.2 init
  $ cd init
  $ ./compile.sh
  $ cd ..
  $ cp -rp MPAS-Model-6.2 model
  $ cd model
  $ vi compile.sh
    - Comment out make command for init
    - Add following make command for model
      make frt CORE=atmosphere PIO=${PIO} NETCDF=${NETCDFF} PNETCDF=${PNETCDF} OPENMP=true USE_PIO2=true
  $ ./compile.sh
```

## How to execute

```
$ mkdir run
  $ cd run
  $ cp (somewhere)/jw_baroclinic_wave.tar.gz
  $ tar zxvf jw_baroclinic_wave.tar.gz
  $ cd jw_baroclinic_wave
  $ patch -p1 -i (somewhere)/jw_for_mpas_v6.2.patch
  $ cp (somewhere)/init_atmosphere_model
  $ cp (somewhere)/atmosphere_model
  $ vi go_init.sh
  ===
  #!/bin/bash -x
  #PJM -L rscgrp=def_grp
  #PJM -L rscunit=rscunit_ft01
  #PJM -L node=1
  #PJM --mpi proc=1
  #PJM -L elapse=10:00
  #PJM --no-stging
  #PJM -j

  cd ${PJM_O_WORKDIR:-'.'}

  LANG_HOME=/opt/FJSVxtclanga/tcsds-1.2.23/
  export OPAL_PREFIX=${LANG_HOME}
  export PATH=${LANG_HOME}/bin:${PATH}
  export LD_LIBRARY_PATH=${LANG_HOME}/lib64:${LD_LIBRARY_PATH}

  LIBdir=/fefs01/oss/kenta-w/work/lib
  NETCDFC=${LIBdir}/netcdf-4.6.1
  NETCDFF=${LIBdir}/netcdf-fortran-4.4.4
  PNETCDF=${LIBdir}/parallel-netcdf-1.8.1
  PIO=${LIBdir}/PIO

  export LD_LIBRARY_PATH=${NETCDFF}/lib:${NETCDFC}/lib:${LD_LIBRARY_PATH}

  export PARALLEL=1
  export OMP_NUM_THREADS=${PARALLEL}
  export OMP_STACKSIZE=32m

  LD="init_atmosphere_model"
  OUTPUT="./init.out"

  mpiexec ${LD} > ${OUTPUT} 2>&1

  exit
  ===
  $ pjsub ./go_init.sh
  $ vi go_model.sh
  ===
  #!/bin/bash -x
  #PJM -L rscgrp=def_grp
  #PJM -L rscunit=rscunit_ft01
  #PJM -L node=1
  #PJM --mpi proc=24
  #PJM -L elapse=09:00
  #PJM --no-stging
  #PJM -j

  cd ${PJM_O_WORKDIR:-'.'}

  LANG_HOME=/opt/FJSVxtclanga/tcsds-1.2.23
  export OPAL_PREFIX=${LANG_HOME}
  export PATH=${LANG_HOME}/bin:${PATH}
  export LD_LIBRARY_PATH=${LANG_HOME}/lib64:${LD_LIBRARY_PATH}

  LIBdir=/fefs01/oss/kenta-w/work/lib
  NETCDFC=${LIBdir}/netcdf-4.6.1
  NETCDFF=${LIBdir}/netcdf-fortran-4.4.4
  PNETCDF=${LIBdir}/parallel-netcdf-1.8.1
  PIO=${LIBdir}/PIO

  export LD_LIBRARY_PATH=${NETCDFF}/lib:${NETCDFC}/lib:${LD_LIBRARY_PATH}

  export PARALLEL=2
  export OMP_NUM_THREADS=${PARALLEL}
  export OMP_STACKSIZE=128m

  LD="./atmosphere_model"

  mpiexec ${LD}

  exit
  ===
  $ pjsub ./go_model.sh
```

## License
The contents in this directory are distributed under MPAS license.
