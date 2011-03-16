#!/bin/bash

function inode()
{
  echo $(stat -L -c%i $1)
}
function cmp()
{
  [[ $(inode $1) == $(inode $2) ]] && echo 1
}

function process()
{
  OF="$1"
  NF=$(echo ~/.$1)
  SF=0

  if [[ $(grep -cE "^$OF$" .applyignore) -gt 0 ]]
  then
    continue
  fi

  if [[ -e $NF && $(cmp "$OF" "$NF") -eq 1 ]]
  then
    SF=1
  elif [[ -d $OF ]]
  then
    for FILE in $OF/*[^~]
    do
      process "$FILE"
    done
    SF=-1
  fi

  if [[ $SF -eq 0 ]]
  then
    echo "$NF isn't linked to $OF."
  fi
}

for FILE in ${@:-*[^~]}
do
  process "$FILE"
done
