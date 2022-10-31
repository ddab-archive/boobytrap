# BoobyTrap! Project makefile
#
# $Rev: 42 $
# $Date: 2013-10-28 00:09:13 +0000 (Mon, 28 Oct 2013) $
#
# This file is licensed under the MIT license.
#
# Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
# http://codedabbler.co.uk

BIN = ..\Bin
EXE = ..\Exe

# Check for required environment variables

!ifdef DELPHIXE
DELPHIROOT = $(DELPHIXE)
!endif
!ifndef DELPHIROOT
!error DELPHIROOT or DELPHIXE environment variable required.
!endif

# Define path to DelphiDabbler library code if specified for Delphi 2010
!ifdef DELPHIDABLIBDXE
DELPHIDABLIB = $(DELPHIDABLIBDXE);
!endif
!ifndef DELPHIDABLIB
!error DELPHIDABLIB or DELPHIDABLIBXE environment variable required.
!endif


# Define macros for required tools

DCC32 = "$(DELPHIROOT)\Bin\DCC32.exe"

BRCC32 = "$(DELPHIROOT)\Bin\BRCC32.exe"

!ifdef VIEDROOT
VIED = "$(VIEDROOT)\VIEd.exe" -makerc
!else
VIED = VIEd.exe -makerc
!endif

!ifdef INNOSETUP_U
INNOSETUP = $(INNOSETUP_U)
!endif
!ifdef INNOSETUP
ISCC = "$(INNOSETUP)\ISCC.exe"
!else
ISCC = ISCC.exe
!endif

!ifdef HHCROOT
HHC = "$(HHCROOT)\HHC.exe"
!else
HHC = HHC.exe
!endif

!ifdef ZIPROOT
ZIP = "$(ZIPROOT)\Zip.exe"
!else
ZIP = Zip.exe
!endif

# Implicit rules

# Delphi projects are assumed to contain required output and search path
# locations in the project options .cfg file.
.dpr.exe:
  @echo +++ Compiling Delphi Project $< +++
  @$(DCC32) $< -B -U"$(DELPHIDABLIB)"

# Resource files are compiled to the directory specified by BIN macro, which
# must have been set by the caller.
.rc.res:
  @echo +++ Compiling Resource file $< +++
  @$(BRCC32) $< -fo$(BIN)\$(@F)

# Version info files are compiled by VIEd. A temporary .rc file is left behind
.vi.rc:
  @echo +++ Compiling Version Info file $< +++
  @$(VIED) .\$<

# Explicit rules

# Default is to build everything and release
everything: config boobytrap help setup release

# Build BoobyTrap executable
boobytrap: resources pascal

# Builds BoobyTrap exe file + help
exes: boobytrap help

# Configure source folders
config:
  @echo Configuring BoobyTrap
  # Create build folders
  @cd ..
  @if exist Bin rmdir /S /Q Bin
  @if exist Exe rmdir /S /Q Exe
  @if exist Release rmdir /S /Q Release
  @mkdir Bin
  @mkdir Exe
  @mkdir Release
  @cd Source

# Compiles the resources and deletes intermediate file created by VIED
resources: Version.res Resource.res
  -@del Version.rc

# Builds BoobyTrap pascal files and links program
pascal: BoobyTrap.exe

# Builds help file
help:
  -1 @$(HHC) .\Help\BoobyTrap.chm

# Builds setup program
setup:
  @del $(EXE)\BoobyTrap-Setup-*
  @$(ISCC) Install.iss

# Build release files (.zip)
!ifndef RELEASEFILENAME
RELEASEFILENAME = dd-boobytrap
!endif
OUTFILE = Release\$(RELEASEFILENAME).zip
release:
  @echo.
  @echo Creating Release File
  @echo ---------------------
  @cd ..
  -@if exist $(OUTFILE) del $(OUTFILE)
  @$(ZIP) -j -9 $(OUTFILE) Exe\BoobyTrap-Setup-*.exe Docs\ReadMe.txt
  @cd Source

# Clean up unwanted files
clean:
  @cd ..
  # remove unwanted files: temps (~ or .~*), .dsk, .local, .identcache
  -@del /S *.~* 2>nul
  -@del /S ~* 2>nul
  -@del /S *.dsk 2>nul
  -@del /S *.local 2>nul
  -@del /S *.identcache 2>nul
  # remove __history folders
  -@for /F "usebackq" %i in (`dir /S /B /A:D ..\__history`) do @rmdir /S /Q %i
  @cd Source
