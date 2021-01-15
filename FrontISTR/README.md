# FrontISTR

## Description
FrontISTR is an open source large scale parallel FEM program for nonlinear structural analysis that are released under the MIT License.
See [FrontISTR home](https://www.frontistr.com/) for detail.

This is a set of scripts and documentations in order to build and execute faster this application on A64FX microprocessor with Fujitsu compiler.

## How to build 

The followings are build procedure by Fujitsu native and cross compiler.

### Requirements

- FUJITSU Software Compiler Package or Fujitsu Development Studio
- cmake 2.8.0 or later
  - https://cmake.org/download/
- metis 5.1.0
  - http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/metis-5.1.0.tar.gz
- FrontISTR v5.0
  - https://www.frontistr.com/download/link.php?https://gitlab.com/FrontISTR-Commons/FrontISTR/-/archive/v5.0/FrontISTR-v5.0.tar.gz
- REVOCAP_Refiner 1.1.04
  - https://www.frontistr.com/download/link.php?REVOCAP_Refiner-1.1.04.tar.gz

### Build procedure by native compiler


#### 1. Setup environment variables

1-1. Setup commands and options

```
LANGDIR="Path to the root directory of Fujitsu compiler"
export PATH=${LANGDIR}/bin:$PATH
export LD_LIBRARY_PATH=${LANGDIR}/lib64:$LD_LIBRARY_PATH
export CC=mpifcc
export CXX=mpiFCC
export FC=mpifrt
export OMPFLAGS="-Kopenmp -Kparallel"
export CFLAGS="${OMPFLAGS} -Kcmodel=large -Nlst=t -Kocl -Kfast -Kzfill -Koptmsg=2 -V"
export CXXFLAGS="${OMPFLAGS} -Kcmodel=large -Nlst=t -Kocl -Kfast -Kzfill -Koptmsg=2 -V"
export FCFLAGS="${OMPFLAGS} -Kcmodel=large -Nlst=t -Kocl -Kfast -Kzfill -Koptmsg=2 -V"
export BLAS="-SSL2BLAMP"
export LAPACK="-SSL2BLAMP"
export SCALAPACK="-SCALAPACK"
export LINKER_FLAGS="--linkfortran ${OMPFLAGS}"
```

1-2. Setup target directory
```
export METISDIR=~/metis-5.1.0
export REFINERDIR=~/REVOCAP_Refiner-1.1.04
export FISTRDIR=~/FrontISTR-v5.0
```

#### 2. Build metis-5.1.0
```
tar xzvf metis-5.1.0.tar.gz
cd metis-5.1.0
make config prefix=${METISDIR} cc=${CC} openmp=1
make install
cd ..
```

#### 3. Build REVOCAP_Refiner-1.1.04.tar.gz
```
tar xzvf REVOCAP_Refiner-1.1.04.tar.gz
cd REVOCAP_Refiner-1.1.04
cp -f ../MakefileConfig.in.refiner.fujitsu MakefileConfig.in
make Refiner
mkdir -p ${REFINERDIR}/include ${REFINERDIR}/lib
cp Refiner/rcapRefiner.h ${REFINERDIR}/include
cp lib/kei/libRcapRefiner.a ${REFINERDIR}/lib
cd ..
```

#### 4. Build FrontISTR-v5.0.tar.gz

4-1. Extract FrontSTR archive file
```
tar xzvf FrontISTR-v5.0.tar.gz
cd FrontISTR-v5.0
```

4-2. Apply tuning patch (optional)

If you try Fujitsu tuned FrontISTR, apply "tune.patch" to FrontISTR source code.
```
patch -p1 < ../tune.patch
```

4-3. Build FrontISTR

```
mkdir build
cd build
source ../../cmakecommand_for_fistr.sh
make install
cd ../../
```

### Build procedure by cross compiler

Add "px" to CC, CXX and FC at the step 1-1 of the build procedure by native compiler. 
```
export CC=mpifccpx
export CXX=mpiFCCpx
export FC=mpifrtpx
```
Other procedures are the same as the procedure by native compiler.


## How to execute

```
cd input_file_directory
${FISTRDIR}/bin/hecmw_part1
export OMP_NUM_THREADS=1
mpiexec -n 48 ${FISTRDIR}/bin/fistr1
```

## License
The contents in this directory are released under the MIT License. See License.txt in detail.
