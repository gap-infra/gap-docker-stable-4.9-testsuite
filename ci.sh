#!/usr/bin/env bash

# running GAP tests suite

set -ex

SRCDIR=${SRCDIR:-$PWD}

# --quitonbreak makes sure any Error() immediately exits GAP with exit code 1.
GAP="bin/gap.sh --quitonbreak -q -A -x 80 -r -m 100m -o 1g -K 2g"
GAPAuto="bin/gap.sh --quitonbreak -q -x 80 -r -m 100m -o 1g -K 2g"

echo SRCDIR    : $SRCDIR
echo TEST_SUITE: $TEST_SUITE
echo GAPPKG    : $GAPPKG

cd /home/gap/inst/gap-master/

case ${GAPPKG} in
no)
    $GAP <<GAPInput
        TestDirectory( [ DirectoriesLibrary( "tst/${TEST_SUITE}" ) ], rec(exitGAP := true) );
        FORCE_QUIT_GAP(1);
GAPInput
    ;;
auto)
    $GAPAuto <<GAPInput
        TestDirectory( [ DirectoriesLibrary( "tst/${TEST_SUITE}" ) ], rec(exitGAP := true) );
        FORCE_QUIT_GAP(1);
GAPInput
    ;;
all)
    $GAP <<GAPInput
        LoadAllPackages();
        TestDirectory( [ DirectoriesLibrary( "tst/${TEST_SUITE}" ) ], rec(exitGAP := true) );
        FORCE_QUIT_GAP(1);
GAPInput
    ;;    
esac;
