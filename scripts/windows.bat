@echo off

REM Checking for admin permissions.
echo Checking for admin permissions
net session > nul 2>&1
net session > NUL
if %errorlevel% == 0 (
    echo You are Administrator
) else (
	echo You are NOT Administrator, aborting
	exit /B 1
)

REM Install chocolatey.
powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))"
SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin

@echo on

REM Development stuff.
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

REM Tools.
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

REM Media.
cinst vlc
cinst spotify
cinst plex-home-theater

REM Games.
cinst steam
cinst battle.net
cinst origin
!cinst uplay
!cinst pinnaclegameprofiler

REM Other stuff.
cinst GoogleChrome
cinst Firefox
cinst Opera
cinst adobereader
cinst dropbox
cinst skype

REM Refresh the environment.
RefreshEnv

REM Dotfiles.
set home=%USERPROFILE%
set dotf=%USERPROFILE%\dotfiles
if not exist %df% (
	git clone git@github.com:MaienM/dotfiles.git %df%
	cd %df%
	git submodule update --init --recursive
) 
cd %df%

REM Create links.
mklink /J %dotf%\vim %home%\vimfiles
