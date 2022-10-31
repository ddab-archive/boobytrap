;===============================================================================
; BoobyTrap! install file generation script for use with Inno Setup 5.
;
; $Rev: 95 $
; $Date: 2013-10-29 11:19:36 +0000 (Tue, 29 Oct 2013) $
;
; This file is licensed under the MIT license.
;
; Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
; http://codedabbler.co.uk
;===============================================================================


; Deletes "Release " from beginning of S
#define DeleteToVerStart(str S) \
  /* assumes S begins with "Release " followed by version as x.x.x */ \
  Local[0] = Copy(S, Len("Release ") + 1, 99), \
  Local[0]

; The following defines use these macros that are predefined by ISPP:
;   SourcePath - path where this script is located
;   GetStringFileInfo - gets requested version info string from an executable
;   GetFileProductVersion - gets product version info string from an executable

#define AppPublisher "DelphiDabbler"
#define AppName "BoobyTrap!"
#define AppFileName "BoobyTrap"
#define ExeFile AppFileName + ".exe"
#define HelpFile AppFileName + ".chm"
#define ReadmeFile "ReadMe.txt"
#define LicenseFile "License.rtf"
#define LicenseTextFile "License.txt"
#define ShortcutFile AppFileName + ".url"
#define ChangeLogFile "ChangeLog.txt"
#define InstDocsDir "Docs"
#define InstUninstDir "Uninstall"
#define OutDir SourcePath + "..\Exe"
#define SrcExePath SourcePath + "..\Exe\"
#define SrcDocsPath SourcePath + "..\Docs\"
#define ExeProg SrcExePath + ExeFile
#define Company "DelphiDabbler.com"
#define AppVersion DeleteToVerStart(GetFileProductVersion(ExeProg))
#define Copyright GetStringFileInfo(ExeProg, LEGAL_COPYRIGHT)
#define WebAddress "www.delphidabbler.com"
#define WebURL "http://" + WebAddress + "/"
#define AppURL WebURL + "software/boobytrap"

[Setup]
AppID={{95E387C2-4E55-40BF-B512-E68142494F2D}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppPublisher} {#AppName} {#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#WebURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}
AppReadmeFile={app}\{#InstDocsDir}\{#ReadmeFile}
AppCopyright={#Copyright} ({#WebAddress})
AppComments=
AppContact=
DefaultDirName={pf}\{#AppPublisher}\BoobyTrap
DefaultGroupName={#AppPublisher} {#AppName}
AllowNoIcons=true
LicenseFile={#SrcDocsPath}{#LicenseFile}
Compression=lzma/ultra
SolidCompression=true
InternalCompressLevel=ultra
OutputDir={#OutDir}
OutputBaseFilename=BoobyTrap-Setup-{#AppVersion}
VersionInfoVersion={#AppVersion}
VersionInfoCompany={#Company}
VersionInfoDescription=Installer for {#AppName}
VersionInfoTextVersion={#AppVersion}
VersionInfoCopyright={#Copyright}
MinVersion=0,5.0
TimeStampsInUTC=true
ShowLanguageDialog=yes
RestartIfNeededByRun=false
PrivilegesRequired=admin
UsePreviousAppDir=true
UsePreviousGroup=true
UsePreviousSetupType=false
UsePreviousTasks=false
UninstallFilesDir={app}\{#InstUninstDir}
UpdateUninstallLogAppName=true
UninstallDisplayIcon={app}\{#ExeFile}
UserInfoPage=false

[Dirs]
Name: {app}\{#InstDocsDir}; Flags: uninsalwaysuninstall
Name: {app}\{#InstUninstDir}; Flags: uninsalwaysuninstall

[Files]
; Executable files
Source: {#SrcExePath}{#ExeFile}; DestDir: {app}; Flags: uninsrestartdelete
Source: {#SrcExePath}{#HelpFile}; DestDir: {app}; Flags: ignoreversion
; Documentation
Source: {#SrcDocsPath}{#LicenseTextFile}; DestDir: {app}\{#InstDocsDir}; Flags: ignoreversion
Source: {#SrcDocsPath}{#ReadmeFile}; DestDir: {app}\{#InstDocsDir}; Flags: ignoreversion
Source: {#SrcDocsPath}{#ChangeLogFile}; DestDir: {app}\{#InstDocsDir}; Flags: ignoreversion

[INI]
; Short-cut to BoobyTrap home page
Filename: {app}\{#ShortcutFile}; Section: InternetShortcut; Key: URL; String: {#AppURL}

[Icons]
Name: {group}\{#AppName}; Filename: {app}\{#ExeFile}
Name: {group}\{cm:ProgramOnTheWeb,{#AppName}}; Filename: {app}\{#ShortcutFile}
Name: {group}\{cm:UninstallProgram,{#AppName}}; Filename: {uninstallexe}

[Run]
Filename: {app}\{#InstDocsDir}\{#ReadMeFile}; Description: "View the README file"; Flags: nowait postinstall skipifsilent shellexec skipifsilent
Filename: {app}\{#ExeFile}; Description: {cm:LaunchProgram,{#AppPublisher} {#AppName}}; Flags: nowait postinstall skipifsilent

[UninstallDelete]
; Specify this short-cut since it is created by installer rather than copied
Type: files; Name: {app}\{#ShortcutFile}

[Messages]
; Brand installer
BeveledLabel={#Company}

