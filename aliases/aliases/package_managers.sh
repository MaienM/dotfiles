# Aliases that (attempt to) unify package managers into simple commands.
if /usr/bin/which -s apt-get; then
    # Debian/Ubuntu
    alias PMi='sudo apt-get install'
    alias PMr='sudo apt-get remove'
    alias PMs='apt-cache search'
elif /usr/bin/which -s zypper; then
    # openSUSE
    alias PMi='sudo zypper in'
    alias PMr='sudo zypper rm'
    alias PMs='zypper se'
elif /usr/bin/which -s pacman; then
    # Arch
    alias PMi='sudo pacman -S'
    alias PMr='sudo pacman -R'
    alias PMs='pacman -Ss'
elif /usr/bin/which -s brew; then
    # OSx
    alias PMi='brew install'
    alias PMr='brew uninstall'
    alias PMs='brew search'
else
    echo "Unable to detect package manager. Some aliases will be unavailable."
fi
