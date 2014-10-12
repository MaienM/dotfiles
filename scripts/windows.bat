@echo off

# Checking for admin permissions.
echo Checking for admin permissions
net session > nul 2>&1
net session > NUL
if %errorlevel% == 0 (
    echo You are Administrator
) else (
	echo You are NOT Administrator, aborting
	exit /B 1
)

# Install chocolatey.
powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))"
SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

@echo on

# Development stuff.
cinst python
cinst python2
cinst pip
cinst jdk8
cinst jdk7

!cinst vim
cinst VisualStudio2013Ultimate -InstallArguments "/Features:'Blend'"
cinst intellijidea-community

cinst git
cinst ctags

# Tools.
cinst winscp
cinst autohotkey
cinst 7zip
cinst teamviewer
cinst keepass
cinst launchy
cinst ontopreplica
cinst TeraCopy
!cinst whatpulse
!cinst puttytray

# Media.
cinst vlc
cinst spotify
cinst plex-home-theater

# Games.
cinst steam
cinst battle.net
cinst origin
!cinst uplay
!cinst pinnaclegameprofiler

# Other stuff.
cinst GoogleChrome
cinst Firefox
cinst Opera
cinst adobereader
cinst dropbox
cinst skype

# Refresh the environment.
RefreshEnv

# Dotfiles.
set home=%USERPROFILE%
set dotf=%USERPROFILE%\dotfiles
if not exist %df% (
	git clone git@github.com:MaienM/dotfiles.git %df%
) 
cd %df%

# Create links.
mklink /J %dotf%\vim %home%\vimfiles
