# script to prepare a retroImage for oberon development

# start with a fresh copy of the standard retro image:
cp ~/vrx/retroImage .

# we will create a combined file with all the oberon stuff:
rx=`pwd`/.gen/noctlibs.rx

# combine all the retro files:
pushd ./targets/retro/
  cat noct.rx o07.rx Out.mod.rx System.mod.rx > $rx
popd

# add code to save the image and exit:
( echo ; echo "save" ; echo "bye" ) >> $rx

# invoke retro, executing this script
retro --with $rx || exit -1

# all done :)
echo "new retroImage created."
