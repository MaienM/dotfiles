@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))"
SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

# Development stuff.
cinst VisualStudio2013Ultimate -InstallArguments "/Features:'Blend'"
cinst git
cinst ctags
cinst python
cinst python2
cinst pip

# Tools.
cinst winscp
cinst autohotkey
cinst PuttyTray
cinst javaruntime
cinst 7zip
cinst teamviewer
cinst keepass
cinst launchy
cinst ontopreplica
cinst TeraCopy

# Media.
cinst vlc
cinst spotify
cinst plex-home-theater

# Games.
cinst steam
cinst battle.net
cinst origin

# Other stuff.
cinst GoogleChrome
cinst Firefox
cinst Opera
cinst adobereader
cinst dropbox
cinst skype

# Not available through cinst.
@echo "Install vim, pinnacle, whatpulse"
