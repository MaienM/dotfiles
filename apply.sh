#!/bin/bash

# An alias for ln to direct it to a file.
function ln()
{
  echo ln $@ >> cmds
}
function cmd()
{
  echo $@ >> cmds
}

# Ask a question.
function ask()
{
  D=${1//[abcdefghijklmnopqrstuvwxyz]} # [a-z] didn't work as it also matched
                                       # uppercase letters.
  if [[ ${#D} -gt 1 ]]
  then
    echo "There are multiple defaults specified in this ask sequence: $1."
    return
  fi

  A='-'
  while [[ ${1,,} != *${A,,}* ]]
  do
    read -n1 A &> /dev/null
  done

  if [[ -z $A ]]
  then
    if [[ ${#D} -eq 1 ]]
    then
      A=$D
    else
      ask "$1"
    fi
  fi
  echo 
  A=${A,,}
}

# Compare two files/folders.
function inode()
{
  echo $(stat -L -c%i "$1")
}
function cmp()
{
  [[ $(inode "$1") == $(inode "$2") ]] && echo 1
}

# Compare the age of two files/folders.
function lastmod()
{
  echo $(stat -L -c%Z "$1")
}


# Traverse into a directory.
function traverse()
{
  for FILE in "$1/"*[^~]
  do
    process "$FILE"
  done
}

function process()
{
  OF="$1"
  NF=$(echo ~/.$1)

  if [[ $(grep -cE "^$OF$" .applyignore) -gt 0 ]]
  then
    continue
  fi
 
  if [[ -d $OF ]]
  then
    D=$(grep -cE "^$OF$" .virtualdirs)
  fi

  if [[ -e $NF ]]
  then
    if [[ -d $NF && -d $OF ]]
    then
      if [[ $D -gt 0 ]]
      then
        traverse "$OF"
      else
        if [[ $(cmp "$OF" "$NF") -eq 1 ]]
        then
          :
        else
          echo "Directories $OF and $NF aren't the same. We don't do anything about this"
          echo "automatically (yet), but you should look at it."
        fi
      fi
    elif [[ -f $NF && -f $OF ]]
    then
      if [[ $(cmp "$OF" "$NF") -eq 1 ]]
      then
        :
      elif [[ -z $(diff -q "$OF" "$NF") ]]
      then
        ln -f "$OF" "$NF"
      else
        echo "The file $NF already exists."
        if [[ $(lastmod "$NF") -lt $(lastmod "$OF") ]]
        then
          echo "$NF has been changed more recently than $OF."
        else
          echo "$OF has been changed more recently than $NF."
        fi

        echo "What do you want to do?"
        echo "[m]ove $NF to $OF and create a link, [r]emove $NF and link $OF to $NF, show [D]iff, [i]gnore conflict."
        ask 'mrDi'
          
        if [[ $A == 'd' ]]
        then
          vimdiff "$OF" "$NF"
          echo "What do you want to do?"
          echo "[m]ove $NF to $OF and create a link, [r]emove $NF and link $OF to $NF, [i]gnore conflict."
          ask 'mri'
        fi

        if [[ $A == 'm' ]]
        then
          cmd mv "$NF" "$OF"
          ln "$OF" "$NF"
        elif [[ $A == 'r' ]]
        then
          ln -f "$OF" "$NF"
        fi
      fi
    else
      echo "The types (file or directory) of $OF and $NF don't match. Not sure what to do with this."
    fi
  else
    if [[ -d $OF ]]
    then
      if [[ $D -gt 0 ]]
      then
        cmd mkdir "$NF"
        traverse "$OF"
      else
        ln -s "$OF" "$NF"
      fi
    else
      ln "$OF" "$NF"
    fi
  fi
}

echo > cmds
for FILE in ${@:-*[^~]}
do
  process "$FILE"
done
echo rm cmds >> cmds
