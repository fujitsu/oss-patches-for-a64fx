<a href="https://www.quantum-espresso.org/"><img src="https://www.quantum-espresso.org/project/logos/Quantum_espresso_logo.jpg" width=430></a>

# QUANTUM ESPRESSO


## Description
QUANTUM ESPRESSO is an integrated suite of Open-Source computer codes for electronic-structure calculations and materials modeling at the nanoscale.
It is based on density-functional theory, plane waves, and pseudopotentials. <br>
QUANTUM ESPRESSO is open source software that are released under the GPLv2 . <br>
See [QUANTUM ESPRESSO Home](https://www.quantum-espresso.org/) for detail. <br><br>
This is a set of scripts and documentations in order to build and execute faster this application on A64FX microprocessor with Fujitsu compiler.


## How to build

The followings are build procedure by Fujitsu cross compiler.


### Requirements

- QUANTUM ESPRESSO 6.4.1
  - https://github.com/QEF/q-e/archive/qe-6.4.1.tar.gz
- FFTW 3.3.8 for AArch64
  - https://github.com/fujitsu/fftw3
- FUJITSU Software Compiler Package or Fujitsu Development Studio


### Build procedure by cross compiler

1. Setup environment variables

	```
	export LANG_HOME="Path to the root directory of Fujitsu cross compiler for AArch64"
	export FFTW3_LIB="Path to the root directory of FFTW 3.3.8 for AArch64"
	```

2. Build QUANTUM ESPRESSO 6.4.1

	- "as is"

		```
		./build_qe-6.4.1_mpi-omp_ssl2-scalapack_fftw3_a64fx.sh
		```

	- "tuned"

		```
		./build_qe-6.4.1_mpi-omp_ssl2-scalapack_fftw3_a64fx_tune.sh
		```


## License

The contents in this directory are distributed under GPLv2 .
