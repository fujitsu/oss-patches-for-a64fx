# OpenFOAM

## Description

OpenFOAM is the free, open source CFD software that are released under the GPLv3.
See [OpenFOAM Home](https://www.openfoam.com/) for detail.

This is a set of scripts and documentations in order to build and execute faster this application on A64FX microprocessor with Fujitsu compiler.

<!--
## Verification environment
Operations of the contents have been verified in the following environment.

- FX1000
  - Operating System: Red Hat Enterprise Linux release 8.1 (Ootpa)
  - Compiler: Fujitsu Compiler 4.3.0 20201030
  - MPI: Fujitsu MPI Library 4.0.1 cd3275a957
- FX700
  - Operating System: Red Hat Enterprise Linux release 8.1 (Ootpa)
  - Compiler: Fujitsu Compiler 4.2.1 20200821
  - MPI: Fujitsu MPI Library 4.0.1 5489784f3b
-->

## How to build 

The followings are build procedure by Fujitsu both native and cross compiler.

### Requirements

- FUJITSU Software Compiler Package or Fujitsu Development Studio
- cmake 3.19.2 or later
  - https://cmake.org/download/
- flex 2.6.1 or later
  - https://github.com/westes/flex/releases
- OpenFOAM v1812
  - https://sourceforge.net/projects/openfoam/files/v1812/OpenFOAM-v1812.tgz
- ThirdParty v1812
  - https://sourceforge.net/projects/openfoam/files/v1812/ThirdParty-v1812.tgz

### Build procedure by native compiler

<!--
1. Download OpenFOAM
```
wget https://sourceforge.net/projects/openfoam/files/v1812/OpenFOAM-v1812.tgz
wget https://sourceforge.net/projects/openfoam/files/v1812/ThirdParty-v1812.tgz
```
-->

#### 1. Unzip the files
```
tar -xzvf OpenFOAM-v1812.tgz
tar -xzvf ThirdParty-v1812.tgz
```
#### 2. Apply the patch files for tuning
```
patch -p1 < patch_OpenFOAM-v1812_aarch64_fcc_tune/OpenFOAM-v1812_aarch64_fcc_DICPreconditioner.C.patch
patch -p1 < patch_OpenFOAM-v1812_aarch64_fcc_tune/OpenFOAM-v1812_aarch64_fcc_DICPreconditioner.H.patch
patch -p1 < patch_OpenFOAM-v1812_aarch64_fcc_tune/OpenFOAM-v1812_aarch64_fcc_lduMatrixATmul.C.patch
patch -p1 < patch_OpenFOAM-v1812_aarch64_fcc_tune/OpenFOAM-v1812_aarch64_fcc_GaussSeidelSmoother.C.patch
patch -p1 < patch_OpenFOAM-v1812_aarch64_fcc_tune/OpenFOAM-v1812_aarch64_fcc_symGaussSeidelSmoother.C.patch
```
#### 3. Apply the patch files for compilation
```
patch -p1 < patch_OpenFOAM-v1812_aarch64_fcc_native/OpenFOAM-v1812_aarch64_fcc.patch
patch -p1 < patch_OpenFOAM-v1812_aarch64_fcc_native/scotch.Makefile.inc.OpenFOAM-Linux.shlib.patch
```
#### 4. Build OpenFOAM by Fujitsu native-compiler (FCC)

After setting the PATH to Fujitsu native-compiler (FCC), Execute the following command.
```
source etc/bashrc
./Allwmake
```

### Build procedure by cross compiler

<!--
1. Download OpenFOAM
```
wget https://sourceforge.net/projects/openfoam/files/v1812/OpenFOAM-v1812.tgz
wget https://sourceforge.net/projects/openfoam/files/v1812/ThirdParty-v1812.tgz
```
-->

#### 1. Unzip files
```
tar -xzvf OpenFOAM-v1812.tgz
tar -xzvf ThirdParty-v1812.tgz
```

#### 2. Apply the patch files for tuning
```
patch -p1 < patch_OpenFOAM-v1812_aarch64_fcc_tune/OpenFOAM-v1812_aarch64_fcc_DICPreconditioner.C.patch
patch -p1 < patch_OpenFOAM-v1812_aarch64_fcc_tune/OpenFOAM-v1812_aarch64_fcc_DICPreconditioner.H.patch
patch -p1 < patch_OpenFOAM-v1812_aarch64_fcc_tune/OpenFOAM-v1812_aarch64_fcc_lduMatrixATmul.C.patch
patch -p1 < patch_OpenFOAM-v1812_aarch64_fcc_tune/OpenFOAM-v1812_aarch64_fcc_GaussSeidelSmoother.C.patch
patch -p1 < patch_OpenFOAM-v1812_aarch64_fcc_tune/OpenFOAM-v1812_aarch64_fcc_symGaussSeidelSmoother.C.patch
```

#### 3. Apply the patch files for compilation
```
patch -p1 < patch_OpenFOAM-v1812_aarch64_fcc_native/OpenFOAM-v1812_aarch64_fcc.patch
patch -p1 < patch_OpenFOAM-v1812_aarch64_fcc_native/scotch.Makefile.inc.OpenFOAM-Linux.shlib.patch
```

#### 4. Divide the scripts for cross-compilation
```
patch -p1 < patch_OpenFOAM-v1812_aarch64_fcc_cross/OpenFOAM-v1812_aarch64_fcc_wmake-tool.patch
chmod u+x OpenFOAM-v1812/Allwmake_OpenFOAM
chmod u+x OpenFOAM-v1812/Allwmake_ThirdParty
chmod u+x OpenFOAM-v1812/CompileToolwmake
```

#### 5. Build ThirdParty-v1812 by Fujitsu native-compiler (FCC)

After setting the PATH to the Fujitsu native-compiler (FCC), Execute the following command.
```
source etc/bashrc
./CompileToolwmake
./Allwmake_ThirdParty
```

#### 6. Build OpenFOAM-v1812 by Fujitsu cross-compiler (FCCpx)

6-1 Apply the patch files for cross-compilation.
```
cd OpenFOAM-v1812
patch -p2 < ../patch_OpenFOAM-v1812_aarch64_fcc_cross/OpenFOAM-v1812_aarch64_fcc_etc-bashrc-Fcc2Gcc.patch
source etc/bashrc
./CompileToolwmake
patch -p2 < ../patch_OpenFOAM-v1812_aarch64_fcc_cross/OpenFOAM-v1812_aarch64_fcc_etc-bashrc-Gcc2Fcc.patch
cp -pr wmake/platforms/linux64Gcc/ wmake/platforms/linux64Fcc
patch -p2 < ../patch_OpenFOAM-v1812_aarch64_fcc_cross/OpenFOAM-v1812_aarch64_fcc_cross.patch
```
6-2 After setting the PATH to the Fujitsu cross-compiler (FCCpx), Execute the following command.
```
source etc/bashrc
./Allwmake_OpenFOAM
```
6-3 Execute the following command after cross-compiling OpenFOAM-v1812.
```
cd platforms/
mkdir -p linuxARM64FccDPInt32Opt/lib/ linuxARM64FccDPInt32Opt/bin/
cp -pr linux64FccDPInt32Opt/lib/* linuxARM64FccDPInt32Opt/lib/
cp -pr linux64FccDPInt32Opt/bin/* linuxARM64FccDPInt32Opt/bin/
rm -r linux64FccDPInt32Opt/
```

## How to execute

After setting the PATH to Fujitsu compiler, execute `source etc/bashrc` and setting OpenFOAM environment variables.

After that, each module of OpenFOAM becomes executable.

Reference: [OpenFOAM tutorial-guide](https://www.openfoam.com/documentation/tutorial-guide/)


## License

The contents in this directory are released under the GPLv3 license.
