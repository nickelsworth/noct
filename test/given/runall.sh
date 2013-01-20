#!/bin/bash
################################################################
#
# USAGE:
#
#   ./runall.sh [ -i ]
#
# DESCRIPTION:
#
#   This script runs each of the *.mod example programs
#   under obc ( oxford oberon 2 compiler ) and generates
#   the corresponding ../expect/*.out file.
#
# COMMAND LINE OPTIONS:
#
#   -i   clear screen before each script, and wait for 
#        user to press enter afterwards ("interactive")
#
################################################################

gen=../../.gen  # directory for generated junk files
out=../expect   # directory for expected output (which we want to keep)
mkdir -p $gen $out

for each in *.mod ; do
    m=${each/\.mod/}
    if [ "$1" == "-i" ]; then clear; fi

    echo "compiling $m"
    echo "========================="

    # first time fails because obc misnames the .k file:
    obc -o $gen/$m $m.mod 2> /dev/null
    # so, correct the problem and compile again:
    mv $m.mod.k $m.k
    obc -o $gen/$m $m.mod
    # clean up the mess. keep a copy of the .k file for debugging:
    rm $m.mod.k
    mv $m.k $gen/

    echo "running $m"
    echo "-------------------------"

    $gen/$m > $out/$m.txt
    cat $out/$m.txt

    echo "-------------------------"
    if [ "$1" == "-i" ]; then 
	echo "[press enter]"
	read
    fi
done
