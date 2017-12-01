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

# Get the full path of a file.
function fullpath()
{
  echo "$PWD/$1"
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

  if [[ $(grep -cE "^$OF$" scripts/config/ignore) -gt 0 ]]
  then
    return
  fi
 
  if [[ -d $OF ]]
  then
    D=$(grep -cE "^$OF$" scripts/config/virtualdirs)
  fi

  # If a file does not exist, but yet it is a symbolic link (what) it is a broken symbolic link.
  if [[ ! -e $NF && -h $NF ]]
  then
    echo "Removing broken symblic link $NF."
    cmd rm "$NF"
  fi

  if [[ -e $NF ]]
  then
    # Directory.
    if [[ -d $NF && -d $OF ]]
    then
      # If it is a virtual directory (that is, we don't link the directory itself, but it's contents)
      if [[ $D -gt 0 ]]
      then
        traverse "$OF"
      else
        if [[ $NF -ef $OF ]]
        then
          :
        else
          echo "Directories $OF and $NF aren't the same. We don't do anything about this"
          echo "automatically (yet), but you should look at it."
        fi
      fi

    # File
    elif [[ -f $NF && -f $OF ]]
    then
      if [[ $NF -ef $OF ]]
      then
        :
      elif [[ -z $(diff -q "$OF" "$NF") ]]
      then
        ln -f "$OF" "$NF"
      else
        echo "The file $NF already exists."
        [[ $NF -nt $OF ]] \
          && echo "$NF has been changed more recently than $OF." \
          || echo "$OF has been changed more recently than $NF."

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
        ln -s "$(fullpath "$OF")" "$NF"
      fi
    else
      ln "$OF" "$NF"
    fi
  fi
}

function processLinks()
{
  cat scripts/config/links | while read line
  do
    line=($line)
    source=$(realpath -sm ${line[0]})
    target=$(realpath -sm $HOME/${line[1]})
    if [[ $source -ef $target ]]
    then
      :
    else
      if [[ ! -d $(dirname $target) ]]
      then
        cmd mkdir -p $(dirname $target)
      fi
      if [[ -f $source ]]
      then
        ln -f $source $target
      elif [[ -d $source ]]
      then
        ln -sf $source $target
      else
        echo "File does not exists: $source."
        echo "Invalid link entry: $source $target."
        echo
      fi
    fi
  done
}

# Go to the dotfiles directory.
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# Clear commands file.
echo > cmds

# Process file links into commands file.
for FILE in ${@:-*[^~]}
do
  process "$FILE"
done

# Process links.
processLinks

# Add a cleanup line to the commands file.
echo rm cmds >> cmds

echo Please confirm the following commands are correct:
head -n-1 cmds
echo
echo To execute these commands type "'"source $(realpath cmds)"'"

#vim:et:sw=2
