{
 * Main BoobyTrap! project file.
 *
 * $Rev: 91 $
 * $Date: 2013-10-29 01:51:43 +0000 (Tue, 29 Oct 2013) $
 *
 * This file is licensed under the MIT license.
 *
 * Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
 * http://codedabbler.co.uk
}


program BoobyTrap;


uses
  SysUtils,
  Windows,
  Forms,
  FmBaseDlg in 'FmBaseDlg.pas' {BaseDlg},
  FmHighScore in 'FmHighScore.pas' {HighScoreDlg},
  FmInputBox in 'FmInputBox.pas' {InputBoxDlg},
  FmMain in 'FmMain.pas' {MainForm},
  FmNumTraps in 'FmNumTraps.pas' {NumTrapsDlg},
  FmOKBaseDlg in 'FmOKBaseDlg.pas' {OKBaseDlg},
  FmPlayArea in 'FmPlayArea.pas' {PlayAreaDlg},
  FmSkillLevel in 'FmSkillLevel.pas' {SkillLevelDlg},
  CmpGameGrid in 'CmpGameGrid.pas',
  CmpGameSquare in 'CmpGameSquare.pas',
  UDlgHelper in 'UDlgHelper.pas',
  UGame in 'UGame.pas',
  UHelpManager in 'UHelpManager.pas',
  UHighScore in 'UHighScore.pas',
  ULevels in 'ULevels.pas',
  UMessageBox in 'UMessageBox.pas',
  UGlobals in 'UGlobals.pas',
  USettings in 'USettings.pas',
  USquare in 'USquare.pas',
  USquareGrid in 'USquareGrid.pas';

{$Resource Resource.res}  // contains all program resource except version info
{$Resource Version.res}   // contains program's version information

resourcestring
  sOSError = 'BoobyTrap! cannot start. Windows 2000 or later is required';
  sErrMessageTitle = 'CodeSnip';

begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  Application.MainFormOnTaskBar := True;
  Application.Initialize;
  if Win32MajorVersion < 5 then
  begin
    MessageBox(0, PChar(sOSError), PChar(sErrMessageTitle), MB_OK);
    Application.Terminate;
    Exit;
  end;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

