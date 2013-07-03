#!/usr/bin/env bash
#
# test suite for noct
#

gen=.gen
test=test
expect=$test/expect
err=$gen/err.txt

# force a 4-second limit on retro's runtime during the tests
# (because if we generate invalid syntax, it can mess retro up,
#  and retro will sit around waiting for more input )
timelimit="timelimit -t2 -T2"

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

  # now invoke it:
  clear
  echo -e "\e[36m" # cyan
  case $1 in
     haxe)  haxe -cp $gen -cp targets/haxe/neko -x $name
            mv -f $name.n $gen
        ;;
    retro)  $timelimit retro --with $gen/$name.rx
        ;;
        *)  echo "sorry, don't know how to run $1 yet."
        ;;
  esac
  echo -e "\e[0m" # normal
  echo "[ end of $name.$ext source was: ]"
  echo -e "\e[33m" # brown
  cat $gen/$name.$ext
  echo -e "\e[0m" # normal
  echo '[ press enter to continue, ^C to terminate ]' ; read
done
