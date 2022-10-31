{
 * Implements a dialogue box that allows user to choose a game grid and
 * difficulty level. Also manages addition and deletion of new game grids.
 *
 * $Rev: 93 $
 * $Date: 2013-10-29 03:02:32 +0000 (Tue, 29 Oct 2013) $
 *
 * This file is licensed under the MIT license.
 *
 * Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
 * http://codedabbler.co.uk
}


unit FmSkillLevel;


interface


uses
  // Delphi
  StdCtrls, Controls, ExtCtrls, Classes,
  // Project
  FmBaseDlg, ULevels;


type
  // Dialogue box that allows user to choose a game grid and difficulty level.
  // Also manages addition and deletion of new game grids.
  TSkillLevelDlg = class(TBaseDlg)
    PlayAreaList: TListBox;
    PlayAreaLbl: TLabel;
    AddBtn: TButton;
    DeleteBtn: TButton;
    DifficultyCombo: TComboBox;
    DifficultyLbl: TLabel;
    NumTrapsLbl: TLabel;
    // OnChange event handler for Difficulty combo box. Stores selected
    // difficulty level and update controls.
    procedure DifficultyComboChange(Sender: TObject);
    // OnClick event handler for PlayArea list box. Makes newly selected list
    // item the current play level.
    procedure PlayAreaListClick(Sender: TObject);
    // Add button click event handler. Displays dialogue box where user can
    // enter a new play area. Adds the new play area to the list play area list
    // box.
    procedure AddBtnClick(Sender: TObject);
    // Delete button click event handler. Deletes currently highlighted play
    // area.
    procedure DeleteBtnClick(Sender: TObject);
    // Initialises controls when form is activated.
    procedure FormActivate(Sender: TObject);
  strict private
    var
      // Value of Levels object.
      fLevels: TLevels;
      // Index of currently selected play level.
      fCurLevelIdx: Integer;
    // Displays number of booby traps for current difficulty level and  play
    // area.
    procedure UpdateTrapsDisplay;
    // Gets number of booby traps to use in a custom play level from user.
    function GetCustomTraps: Integer;
    // Updates state of form's buttons depending on state of other controls.
    procedure UpdateButtons;
  public
    // Reference to object that stores information about game's skill levels.
    property Levels: TLevels read fLevels write fLevels;
  end;


implementation


uses
  // Delphi
  SysUtils,
  // Project
  FmNumTraps, FmPlayArea, UGlobals, UMessageBox;


{$R *.DFM}


procedure TSkillLevelDlg.AddBtnClick(Sender: TObject);
var
  Dlg: TPlayAreaDlg;  // instance of dialogue box that gets size of play area
  Index: Integer;     // index of new play area in Levels object and list box
begin
  Dlg := TPlayAreaDlg.Create(Self);
  try
    if Dlg.ShowModal = mrOK then
    begin
      Levels.Add(Dlg.PlayArea);
      Index := Levels.NumLevels - 1;
      PlayAreaList.Items.Add(Levels[Index].PlayAreaStr);
      PlayAreaList.ItemIndex := Index;
      Levels.CurrentLevelIndex := Index;
      UpdateTrapsDisplay;
      UpdateButtons;
    end;
  finally
    Dlg.Free;
  end;
end;

procedure TSkillLevelDlg.DeleteBtnClick(Sender: TObject);
var
  Index: Integer; // index of item being deleted
begin
  Index := PlayAreaList.ItemIndex;
  if TMessageBox.Confirm(
    Self,
    Format(
      'Are you sure you want to delete level %s?', [PlayAreaList.Items[Index]]
    )
  ) then
  begin
    Levels.Delete(Index);
    PlayAreaList.Items.Delete(Index);
    if Index = PlayAreaList.Items.Count then
      Dec(Index);
    PlayAreaList.ItemIndex := Index;
    Levels.CurrentLevelIndex := Index;
    UpdateTrapsDisplay;
    UpdateButtons;
  end;
end;

procedure TSkillLevelDlg.DifficultyComboChange(Sender: TObject);
begin
  Levels.CurrentDifficulty := TDifficulty(DifficultyCombo.ItemIndex);
  UpdateTrapsDisplay;
  // If custom level chosen, invite user to enter number of booby traps at this
  // difficulty level and record in Levels object.
  if Levels.CurrentDifficulty = ldCustom then
  begin
    Levels[Levels.CurrentLevelIndex].SetCustomTraps(GetCustomTraps);
    UpdateTrapsDisplay;
    UpdateButtons;
  end;
end;

procedure TSkillLevelDlg.FormActivate(Sender: TObject);
var
  I: Integer; // loops through all play areas
begin
  inherited;
  for I := 0 to Levels.NumLevels - 1 do
    PlayAreaList.Items.Add(Levels[I].PlayAreaStr);
  fCurLevelIdx := Levels.CurrentLevelIndex;
  PlayAreaList.ItemIndex := Levels.CurrentLevelIndex;
  DifficultyCombo.ItemIndex := Ord(Levels.CurrentDifficulty);
  UpdateTrapsDisplay;
  UpdateButtons;
end;

function TSkillLevelDlg.GetCustomTraps : Integer;
var
  Dlg: TNumTrapsDlg;  // instance of dialogue box that gets number from user
begin
  Result := Levels.CurrentLevel.Traps[ldCustom];
  Dlg := TNumTrapsDlg.Create(Self);
  try
    Dlg.LowerLimit := MinTraps;
    Dlg.UpperLimit :=
      Levels.CurrentLevel.PlayArea.Cols * Levels.CurrentLevel.PlayArea.Rows;
    Dlg.NumTraps := Levels.CurrentLevel.Traps[ldCustom];
    if Dlg.ShowModal = mrOK then
      Result := Dlg.NumTraps;
  finally
    Dlg.Free;
  end;
end;

procedure TSkillLevelDlg.PlayAreaListClick(Sender: TObject);
begin
  if PlayAreaList.ItemIndex > -1 then
  begin
    Levels.CurrentLevelIndex := PlayAreaList.ItemIndex;
    UpdateTrapsDisplay;
    UpdateButtons;
  end;
end;

procedure TSkillLevelDlg.UpdateButtons;
begin
  // Delete button is enabled only if a play level is highlighted, there is more
  // than one play area in list and currently selected play area isn't the
  // current one.
  DeleteBtn.Enabled := (PlayAreaList.ItemIndex > -1)
    and (Levels.NumLevels > 1)
    and (fCurLevelIdx <> PlayAreaList.ItemIndex);
end;

procedure TSkillLevelDlg.UpdateTrapsDisplay;
begin
  NumTrapsLbl.Caption := Format(
    '%d booby traps',
    [Levels.CurrentLevel.Traps[Levels.CurrentDifficulty]]
  );
end;

end.
