#!/usr/bin/env bash

# running GAP tests suite

set -ex

SRCDIR=${SRCDIR:-$PWD}

# --quitonbreak makes sure any Error() immediately exits GAP with exit code 1.
GAP="bin/gap.sh --quitonbreak -A -x 80 -r -m 100m -o 1g -K 2g"
GAPAuto="bin/gap.sh --quitonbreak -x 80 -r -m 100m -o 1g -K 2g"

echo SRCDIR    : $SRCDIR
echo TEST_SUITE: $TEST_SUITE
echo GAPPKG    : $GAPPKG

cd /home/gap/inst/gap-stable-4.9/

case $TEST_SUITE in

testpackagesload)

    case ${GAPPKG} in
    single|singleonlyneeded)

        cd pkg
        # skip itc because it requires xgap package
        rm -rf itc*
        # skip linboxing because it hasn't compiled for years
        rm -rf linboxing*
        # skip pargap because it should be loaded in other way
        rm -rf pargap*
        # skip PolymakeInterface because of no polymake installed
        rm -rf PolymakeInterface*
        # skip xgap because it should be loaded in other way
        rm -rf xgap*
        cd ..

        # loading each package in an individual GAP session, with all needed
        # and suggested packages, or only with needed packages

        if [[ "$GAPPKG" = singleonlyneeded ]]
        then
            GAPOPTION=":OnlyNeeded"
        else
            GAPOPTION=""
        fi

        # Load GAP (without packages) and save workspace to speed up test
        # save names of all packages into a file to be able to iterate over them
        $GAP -b <<GAPInput
        SaveWorkspace("testpackagesload.wsp");
        PrintTo("packagenames", JoinStringsWithSeparator( SortedList(RecNames( GAPInfo.PackagesInfo )),"\n") );
        QUIT_GAP(0);
GAPInput
        for pkg in $(cat packagenames)
        do
            $GAP -b -L testpackagesload.wsp <<GAPInput
            Print("*** Loading $pkg ... \n");
            if LoadPackage("$pkg",false $GAPOPTION) = true then
              Print("OK\n");
            else
              Print("failed \n");
              AppendTo("fail.log", "Loading failed : ", "$pkg", "\n");
            fi;
GAPInput

        done

        if [[ -f fail.log ]]
        then
            echo "Some packages failed to load:"
            cat fail.log
            exit 1
        fi
        ;;

    all|allreversed)
        # Test of `LoadAllPackages()` and `LoadAllPackages(:reversed)`

        if [[ "$GAPPKG" = allreversed ]]
        then
            GAPOPTION=":reversed"
        else
            GAPOPTION=""
        fi

        $GAP <<GAPInput
            SetInfoLevel(InfoPackageLoading,4);
            LoadAllPackages($GAPOPTION);
            SetInfoLevel(InfoPackageLoading,0);
            ignore := [ "itc", "pargap", "xgap", # not loadable this way
                        "linboxing", "polymakeinterface" ];; # not built
            unloads:= Filtered( SortedList(RecNames( GAPInfo.PackagesInfo ) ), s -> LoadPackage(s) = fail );;
            Print("*** Packages that are not loadable: \n", unloads, "\n");
            unloads:= Filtered( unloads, s -> not s in ignore );;
            if Length(unloads)=0 then
              Print("*** Packages loading tests completed!\n");
              QUIT_GAP(0);
            else
              Print("*** Packages loading tests failed because of:\n", unloads, "\n");
              QUIT_GAP(1);
            fi;
GAPInput
        ;;
    esac
    ;;

*)

    case ${GAPPKG} in
    no)
        $GAP -q <<GAPInput
            TestDirectory( [ DirectoriesLibrary( "tst/${TEST_SUITE}" ) ], rec(exitGAP := true) );
            FORCE_QUIT_GAP(1);
GAPInput
    ;;

    auto)
        $GAPAuto -q <<GAPInput
            TestDirectory( [ DirectoriesLibrary( "tst/${TEST_SUITE}" ) ], rec(exitGAP := true) );
            FORCE_QUIT_GAP(1);
GAPInput
    ;;

    all)
        $GAP -q <<GAPInput
            LoadAllPackages();
            TestDirectory( [ DirectoriesLibrary( "tst/${TEST_SUITE}" ) ], rec(exitGAP := true) );
            FORCE_QUIT_GAP(1);
GAPInput
    ;;
    esac

esac