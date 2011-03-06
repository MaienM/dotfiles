#!/bin/bash

function ln()
{
  echo ln $@ >> cmds
}

function ask()
{
  D=${1//[abcdefghijklmnopqrstuvwxyz]} # [a-z] didn't work as it also matched
                                       # uppercase letters.
  if [[ ${#D} -ne 1 ]]
  then
    echo "There either are multiple or no default specified in this ask sequence: $1."
    return
  fi

  A='-'
  while [[ ${1,,} != *${A,,}* ]]
  do
    read -n1 A &> /dev/null
  done

  if [[ -z $A ]]
  then
    A=$D
  fi
  A=${A,,}
}

function process()
{
  OF="$1"
  NF=$(echo ~/.$1)

  if [[ $(grep -cE "^$OF$" .applyignore) -gt 0 ]]
  then
    continue
  fi

  if [[ -e $NF ]]
  then
    if [[ -d $NF ]]
    then
      if [[ $(ls -1 "$NF"/*[^~] | wc -l) -gt 0 ]]
      then
        echo "The directory $NF already exists, and it's not empty. What do you want to do?"
        echo "[o]verwrite it, [T]raverse into it."
        ask 'oT'
        if [[ $A == 'o' ]]
        then
          ln -sf "$OF" "$NF"
        elif [[ $A == 't' ]]
        then
          for FILE in $OF/*[^~]
          do
            process "$FILE"
          done
        fi
      fi
    else
      echo "The file $NF already exists. Overwite it? [y/N]"
      ask 'yN'
      if [[ $A == 'y' ]]
      then
        ln -f "$OF" "$NF"
      fi
    fi
  elif [[ -d $OF ]]
  then
    ln -s "$OF" "$NF"
  elif [[ ! -x $OF ]]
  then
    ln "$OF" "$NF"
  fi
}

echo > cmds
for FILE in *[^~]
do
  process "$FILE"
done
