# Aliases that (attempt to) unify package managers into simple commands.
if [[ -n $(which apt-get) && $? == 0 ]]; then
    alias PMi='sudo apt-get install'
    alias PMr='sudo apt-get remove'
    alias PMs='apt-cache search'
elif [[ -n $(which zypper) && $? == 0 ]]; then
    alias PMi='sudo zypper in'
    alias PMr='sudo zypper rm'
    alias PMs='zypper se'
else
    echo "Unable to detect package manager. Some aliases will be unavailable."
fi