#!/bin/bash

# -----------------------------------------------------------------------------
# setup environment
# -----------------------------------------------------------------------------
QE_VERSION=6.4.1
BUILD_HOME=`realpath -s $0`
BUILD_HOME=`dirname ${BUILD_HOME}`
BUILD_DIR=${BUILD_HOME}/q-e-qe-${QE_VERSION}

DFLT_LANG_HOME=""
DFLT_FFTW3_LIB=""

if [ -z "${LANG_HOME}" ]; then
  LANG_HOME=${DFLT_LANG_HOME}
fi
if [ -z "${FFTW3_LIB}" ]; then
  FFTW3_LIB=${DFLT_FFTW3_LIB}
fi

if [ -z "${LANG_HOME}" -o -z "${FFTW3_LIB}" ]; then
  if [ -z "${LANG_HOME}" ]; then
    echo "Please setup environment variable: export LANG_HOME=\"Path to the root directory of Fujitsu cross compiler for AArch64\""
  fi
  if [ -z "${FFTW3_LIB}" ]; then
    echo "Please setup environment variable: export FFTW3_LIB=\"Path to the root directory of FFTW 3.3.8 for AArch64\""
  fi
  exit
fi

export PATH=${LANG_HOME}/bin:${PATH}
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${LANG_HOME}/lib64

timestamp=`date "+%Y%m%d-%H%M%S"`
logfile=${BUILD_HOME}/`basename $0`.log.${timestamp}


echo "LANG_HOME = ${LANG_HOME}" >> ${logfile}
echo "FFTW3_LIB = ${FFTW3_LIB}" >> ${logfile}

# -----------------------------------------------------------------------------
# download and unpack the source files
# -----------------------------------------------------------------------------
cd ${BUILD_HOME}
#wget https://gitlab.com/QEF/q-e/-/archive/qe-${QE_VERSION}/q-e-qe-${QE_VERSION}.tar.gz  >> ${logfile} 2>&1
tar -zxvf q-e-qe-${QE_VERSION}.tar.gz  >> ${logfile} 2>&1


# -----------------------------------------------------------------------------
# patch for source code
# -----------------------------------------------------------------------------
#patch -p0 < ${BUILD_HOME}/qe-${QE_VERSION}_profile.patch  >> ${logfile} 2>&1
patch -p0 < ${BUILD_HOME}/qe-${QE_VERSION}_a64fx_omp_ssl2-lib.patch  >> ${logfile} 2>&1
patch -p0 < ${BUILD_HOME}/qe-${QE_VERSION}_fftw3-planflag.patch  >> ${logfile} 2>&1


# -----------------------------------------------------------------------------
# move to build directory
# -----------------------------------------------------------------------------
cd ${BUILD_DIR}


# -----------------------------------------------------------------------------
# build post-configuration
# -----------------------------------------------------------------------------
./configure ARCH=aarch64 \
  DFLAGS="-D__FFTW3 -D__MPI -D__SCALAPACK -D_OPENMP -I${FFTW3_LIB}/include" \
  MPIF90="mpifrtpx" F90="frtpx" F77="frtpx" CC="fccpx" \
  FFLAGS="-Kocl -Kregion_extension -Knolargepage -Kfast -Kopenmp -Koptmsg=2 -Nlst=t -I${FFTW3_LIB}/include" \
  F90FLAGS="-Cpp -Kocl -Kregion_extension -Knolargepage -Kfast -Kopenmp -Koptmsg=2 -Nlst=t -I${FFTW3_LIB}/include" \
  LD_LIBS="-Kopenmp" \
  BLAS_LIBS="-SSL2BLAMP" \
  LAPACK_LIBS="-SSL2BLAMP" \
  SCALAPACK_LIBS="-SCALAPACK" \
  FFT_LIBS="${FFTW3_LIB}/lib64/libfftw3_omp.a ${FFTW3_LIB}/lib64/libfftw3.a" \
  >> ${logfile} 2>&1


# -----------------------------------------------------------------------------
# make
# -----------------------------------------------------------------------------
date +"make all: S %Y/%m/%d %H:%M:%S" >> ${logfile} 2>&1
make all >> ${logfile} 2>&1
date +"make all: E %Y/%m/%d %H:%M:%S" >> ${logfile} 2>&1


# -----------------------------------------------------------------------------
# make internal tests
# -----------------------------------------------------------------------------


# -----------------------------------------------------------------------------
# make other tests
# -----------------------------------------------------------------------------

