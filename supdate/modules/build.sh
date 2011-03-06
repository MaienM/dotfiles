if [[ -z $MAKE_JOBS || $MAKE_JOBS -le 0 ]]
then
  MAKE_JOBS=1
fi

# If there is a Build script, we run that and end. A Build script is supposed
# to configure, make, etc, the whole bunch. Else, we start to run bootstrap,
# autogen.sh, Configure and configure, in order. Configure is supposed to JUST
# run configure with custom parameters to use.
CMDS[apply]='
if [[ -x ./Build ]];
then 
  debug $D_MESSAGE "Running the Build script for $NAME." &&
  ./Build &&
  N=-$? &&
  return;
fi &&

FILES=(bootstrap autogen.sh Configure:@:2 qmake:-e *.pro:1 configure) &&
for FILE in ${FILES[@]};
do 
  if [[ $S -gt 0 ]];
  then
    continue;
  fi &&
  FILE=($(IFS=":" && echo $FILE)) &&
  F=${FILE[0]} &&
  C=$(IFS="@" && C=(${FILE[1]}) && echo ${C[0]:=-x $F}) &&
  S=${FILE[2]:=0} &&
  echo -e "$F\t$C\t$S" &&
  if test "$C";
  then
    debug $D_MESSAGE "Running $F for $NAME." && 
    ./$F;
    if [[ $? -ne 0 ]];
    then
      N=$E_FAIL &&
      return;
    fi;
  fi;
done &&

debug $D_MESSAGE "Running make for $NAME." &&
make -j$MAKE_JOBS &&
O=$? &&
if [[ $O -eq 2 ]];
then
  debug $D_ERROR "No makefile found. Are you sure this is a buildable project?" &&
  N=$E_FAIL;
elif [[ $O -eq 0 ]];
then
  debug $D_MESSAGE "Make completed successfully.";
  N=$R_SUCCESS;
else
  N=$E_FAIL;
fi'
