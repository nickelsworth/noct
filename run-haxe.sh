#!/bin/bash

# NOTE: this is run from the parent directory by the makefile.
test=test
gen=.gen
ext=hx

# reset 'expected' directory to whatever's checked into git:
rm -f $test/expect/*
git checkout -- test/expect
rm -rf err.txt

# run the test suite
for f in $test/given/*.mod ; do

  # strip the path and extension:
  name=${f/$test\/given\//} ; name=${name/\.mod/} ;
  make $gen/$name.$ext

  haxe -cp $gen -cp targets/haxe/neko -x $name
  mv -f $name.n $gen
  echo '[press enter]'
  read
done
