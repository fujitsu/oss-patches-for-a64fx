# Build Apprications with Spack on A64FX

## Spack
Spack is a package manager for supercomputers. See [Spack About](https://spack.io/about/) for detail.
With Spack, following apprications and their dependencies can be easily built on A64FX.
- FrontISTR
- LAMMPS
- MPAS
- OpenFOAM
- Quantum Espresso
- SPECFEM3D
- SALMON
- ABINIT

## How to use Spack on A64FX

1. Clone Spack from Github and setup environment variables.

```sh
git clone https://github.com/spack/spack.git
. spack/share/spack/setup-env.sh
```
If you use Fujitsu Compiler and MPI, edit compilers.yaml and packages.yaml in ~/.spack. See "Examples" section for detail.


2. Install applications
```
spack install [appname]@[version] %fj
```

3. Load package and execute applications
```
spack load [appname]
mpiexec -np [n_processes] [app_module]
```

## Notes
### zlib issue on FX700
If zlib is included in dependencies and built in clang mode, mpiexec may cause error on FX700. 
This is because Spack sets LD_LIBRARY_PATH to user-built zlib and makes mpiexec linked with it, while mpiexec of Fujitsu MPI must be linked with system zlib. 
To avoid this error, please unload zlib or load package with --only package option as follows:
```
spack load [appname]
spack unload zlib
```
or
```
spack load --only package [appname]
```
We are now requesting a countermeasure to this issue with Fujitsu MPI team.

## Examples

### yaml files settings

Replace {COMPILER_PATH} to the compiler root path of your environment such as "/opt/FJSVxtclanga/tcsds-1.2.28".

compilers.yaml:
```
- compiler:
    spec: fj@4.3.0
    paths:
      cc: {COMPILER_PATH}/bin/fcc
      cxx: {COMPILER_PATH}/bin/FCC
      f77: {COMPILER_PATH}/bin/frt
      fc: {COMPILER_PATH}/bin/frt
    flags:
      cflags: -Nclang
      cxxflags: -Nclang
    operating_system: rhel8
    target: aarch64
    modules: []
    environment:
      append_path:
        LD_LIBRARY_PATH: {COMPILER_PATH}/lib64
    extra_rpaths: []
```
packages.yaml:
```
packages:
  all:
    compiler: [fj, gcc, clang]
    providers:
      mpi: [fujitsu-mpi]
  mpi:
    buildable: false
  fujitsu-mpi:
    buildable: false
    externals:
    - prefix: {COMPILER_PATH}
      spec: "fujitsu-mpi@4.0.0%fj@4.3.0 arch=linux-rhel8-aarch64"
```
If you use Fujitsu SSL2, add the following to packages.yaml.
```
  all:
    providers:
      scalapack: [fujitsu-ssl2]
      blas: [fujitsu-ssl2]
      lapack: [fujitsu-ssl2]
  lapack:
    buildable: false
  blas:
    buildable: false
  scalapack:
    buildable: false
  fujitsu-ssl2:
    buildable: false
    externals:
    - prefix: {COMPILER_PATH}
      spec: "fujitsu-ssl2@1.0~parallel%fj@4.3.0 arch=linux-rhel8-aarch64"
```

### Installation commands
```
# SALMON
spack install salmon-tddft+mpi@1.2.1 %fj
# SPECFEM3D
spack install specfem3d-globe@7.0.2 fflags=-Kopenmp cflags=-Kopenmp %fj
# LAMMPS
spack install lammps@20190807 %fj
# FrontISTR
spack install frontistr@5.0 ^mumps@5.2.0 ^hdf5@1.8.21 ^boost@1.66.0 ^openblas ldflags=-L${LANG_HOME}/lib64 ldlibs='-lfj90i -lfj90f -lfjsrcinfo -lelf' %fj
# MPAS
spack install mpas-model@7.0 ^parallelio+pnetcdf ^hdf5@1.8.21 %fj
# OpenFOAM
spack install openfoam@1812 ^boost@1.66.0 ^cgal@4.9.1 %fj
# ABINIT(SSL2ver)
spack install abinit@8.10.2 %fj
# QE(SSL2ver)
spack install quantum-espresso@6.4.1 %fj 
```

### Installation and Execution flow of LAMMPS
Install LAMMPS:
```
. spack/share/spack/setup-env.sh
spack install lammps @20190807 %fj
```
Execute LAMMPS:
```
spack load --only package lammps
mpiexec -np 48 lmp -in in.lj
```
You can get the input file in.lj with spack stage command, which expands downloaded archive.
```
spack stage -p [PATH] lammps @20190807 %fj
```

