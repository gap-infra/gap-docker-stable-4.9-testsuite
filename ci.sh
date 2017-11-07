#!/usr/bin/env bash

# running GAP tests suite

set -ex

SRCDIR=${SRCDIR:-$PWD}

# --quitonbreak makes sure any Error() immediately exits GAP with exit code 1.
GAP="bin/gap.sh --quitonbreak -q -A -x 80 -r -m 100m -o 1g -K 2g"
GAPAuto="bin/gap.sh --quitonbreak -q -x 80 -r -m 100m -o 1g -K 2g"

echo $TEST_SUITE
echo $GAPPKG

case ${GAPPKG} in
no)
    $GAP <(echo 'TestDirectory( [ DirectoriesLibrary( "tst/testbugfix" ) ], rec(exitGAP := true) ); FORCE_QUIT_GAP(1);')
    ;;
auto)
    $GAPAuto <(echo 'TestDirectory( [ DirectoriesLibrary( "tst/testbugfix" ) ], rec(exitGAP := true) ); FORCE_QUIT_GAP(1);')
    ;;
all )
    $GAP <(echo 'LoadAllPackages(); TestDirectory( [ DirectoriesLibrary( "tst/testbugfix" ) ], rec(exitGAP := true) ); FORCE_QUIT_GAP(1);')
    ;;    
esac;
