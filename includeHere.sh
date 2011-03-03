#!/bin/bash

echo > cmds
for FNAME in $@
do 
 
  if [[ -h $FNAME ]]
  then
    echo $FNAME seems to be a symbolic link.
    rm cmds
    exit 0
  fi

  BASENAME="$(basename $FNAME)"
  NEWNAME="${BASENAME#.}"
  echo mv "$FNAME" "$NEWNAME" >> cmds

  if [[ -d $FNAME ]]
  then
    echo ln -s "$NEWNAME" "${FNAME%/}" >> cmds
  else
    echo ln "$NEWNAME" "$FNAME" >> cmds
  fi
done
echo rm cmds >> cmds

echo Please confirm the following commands are correct:
head -n-1 cmds
echo
echo To execute these commands type . cmds
