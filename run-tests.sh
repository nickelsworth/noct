#!/bin/bash
#
# test suite for noct
#
# The Makefile runs this from the project root.

gen=.gen
test=test
expect=$test/expect
err=$gen/err.txt

# choose a language backend to test

case "$1" in
  haxe)   ext=hx   ;;
  retro)  ext=rx   ;;
  #java)   ext=java ;;
  #pascal) ext=pas  ;;
  #oberon) ext=mod  ;;
  *)
    echo "usage: $0 BACKEND"
    echo
    echo "Available Backends:"
    echo
    echo "   haxe      retro"
    #echo "   oberon    pascal"
    #echo "   java      javascript"
    echo
    exit 1
    ;;
esac

# reset 'expected' directory to whatever's checked into git:
rm -f $expect/*
git checkout -- $expect
rm -rf $err

# run the test suite
for f in $test/given/*.mod ; do

  # strip the path and extension:
  name=${f/$test\/given\//}
  name=${name/\.mod/}

  # let make figure out how to compile it
  echo make $gen/$name.$ext
  echo -e "\e[33m" # brown
  make $gen/$name.$ext  | tail -n +2 || exit -1
  echo -e "\e[0m" # normal
  echo '[ press enter to run, ^C to terminate ]' ; read

  echo -e "\e[36m" # cyan
  # now invoke it:
  case $1 in
     haxe)  haxe -cp $gen -cp targets/haxe/neko -x $name
            mv -f $name.n $gen
        ;;
    retro)  retro --with $gen/$name.rx
        ;;
        *)  echo "sorry, don't know how to run $1 yet."
        ;;
  esac
  echo -e "\e[0m" # normal
done
