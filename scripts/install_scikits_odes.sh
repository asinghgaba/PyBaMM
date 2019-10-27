#!/bin/bash

SUNDIALS_URL=https://github.com/LLNL/sundials/archive/v3.1.1.tar.gz
SUNDIALS_NAME=sundials-3.1.1.tar.gz
CURRENT_DIR=`pwd`
TMP_DIR=$CURRENT_DIR/tmp
mkdir $TMP_DIR
INSTALL_DIR=$CURRENT_DIR/sundials

cd $TMP_DIR
wget $SUNDIALS_URL -O $SUNDIALS_NAME
tar -xvf $SUNDIALS_NAME
mkdir build-sundials-3.1.1
cd build-sundials-3.1.1/
cmake -DLAPACK_ENABLE=ON -DSUNDIALS_INDEX_TYPE=int32_t -DBUILD_ARKODE:BOOL=OFF -DEXAMPLES_ENABLE:BOOL=OFF -DCMAKE_INSTALL_PREFIX=$INSTALL_DIR ../sundials-3.1.1/
if [ "$(uname)" == "Darwin" ]; then
    # Mac OS X platform        
    NUM_OF_CORES=$(sysctl -n hw.cpu)
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # GNU/Linux platform
    NUM_OF_CORES=$(cat /proc/cpuinfo | grep processor | wc -l)
fi
make clean
make -j$NUM_OF_CORES install
cd $CURRENT_DIR
rm -rf $TMP_DIR
export LD_LIBRARY_PATH=$INSTALL_DIR/lib:$LD_LIBRARY_PATH # For Linux
export DYLD_LIBRARY_PATH=$INSTALL_DIR/lib:$DYLD_LIBRARY_PATH # For Mac
export SUNDIALS_INST=$INSTALL_DIR
pip install scikits.odes

