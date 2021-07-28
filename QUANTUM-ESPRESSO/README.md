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
- elpa-2016.11.001.pre
  - https://github.com/fujitsu/elpa (ELPA 2016.11.001.pre. is not available now. Please download the archive file [here](https://github.com/fujitsu/oss-patches-for-a64fx/wiki/elpa-2016.11.001.pre.tar.gz).)
- FUJITSU Software Compiler Package or Fujitsu Development Studio


### Build procedure by cross compiler

1. Setup environment variables

	```
	export LANG_HOME="Path to the root directory of Fujitsu cross compiler for AArch64"
	export FFTW3_LIB="Path to the library path of FFTW 3.3.8 for AArch64"
	export ELPA_LIB="Path to the library path of elpa-2016.11.001.pre"
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
## Notes
In our benchmarks, we have seen a slight speedup when using the sve-dev branch of fftw3.
- https://github.com/fujitsu/fftw3/tree/sve-dev
- If you use the sve-dev branch, the fftw3 must be built with the option to specify double precision. See the fujitsu/fftw3 pages for detail.

## License

The contents in this directory are distributed under GPLv2 .
