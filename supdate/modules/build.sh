if [[ -z $MAKE_JOBS || $MAKE_JOBS -le 0 ]]
then
  MAKE_JOBS=1
fi

CMDS[apply]='
if [[ -x ./Build ]]
then 
  debug 1 "Running the Build script for $NAME"
  ./Build
  N=0
  return
fi

if [[ -x ./bootstrap ]]
then
  debug 1 "bootstrap found for $NAME, running it"
  ./bootstrap
fi

if [[ -x ./Configure ]]
then 
  debug 1 "Configure script found for $NAME, running it"
  ./Configure
elif [[ -x ./configure ]]
then
  debug 1 "Running configure for $NAME"
  ./configure
else
  debug 0 "Are you sure build is correct for this site?"
  debug 0 "There does not seem to be a configure file or anything of the sort"
  N=-1
  return
fi

make -j$MAKE_JOBS
N=0
'
