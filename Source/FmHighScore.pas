{
 * Implements a dialogue box that displays, and optionally restores, the high
 * score table.
 *
 * $Rev: 93 $
 * $Date: 2013-10-29 03:02:32 +0000 (Tue, 29 Oct 2013) $
 *
 * This file is licensed under the MIT license.
 *
 * Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
 * http://codedabbler.co.uk
}


unit FmHighScore;


interface


uses
  // Delphi
  StdCtrls, Controls, ExtCtrls, Classes,
  // Project units
  FmBaseDlg, ULevels;


type

  // Dialogue box that displays, and optionally restores, the high score table.
  THighScoreDlg = class(TBaseDlg)
    BodyBvl: TBevel;
    Bvl1C: TBevel;
    Bvl1E: TBevel;
    Bvl1H: TBevel;
    Bvl1M: TBevel;
    Bvl2C: TBevel;
    Bvl2E: TBevel;
    Bvl2H: TBevel;
    Bvl2M: TBevel;
    Bvl3C: TBevel;
    Bvl3E: TBevel;
    Bvl3H: TBevel;
    Bvl3M: TBevel;
    HeadingLbl1: TLabel;
    HeadingLbl2: TLabel;
    HeadingLbl3: TLabel;
    HeadingLbl4: TLabel;
    Level1CLbl: TLabel;
    Level1ELbl: TLabel;
    Level1HLbl: TLabel;
    Level1MLbl: TLabel;
    Level2ELbl: TLabel;
    Level2CLbl: TLabel;
    Level2HLbl: TLabel;
    Level2MLbl: TLabel;
    Level3CLbl: TLabel;
    Level3ELbl: TLabel;
    Level3HLbl: TLabel;
    Level3MLbl: TLabel;
    Name1CLbl: TLabel;
    Name1ELbl: TLabel;
    Name1HLbl: TLabel;
    Name1MLbl: TLabel;
    Name2CLbl: TLabel;
    Name2ELbl: TLabel;
    Name2HLbl: TLabel;
    Name2MLbl: TLabel;
    Name3CLbl: TLabel;
    Name3ELbl: TLabel;
    Name3HLbl: TLabel;
    Name3MLbl: TLabel;
    ResetBtn: TButton;
    Score1ELbl: TLabel;
    Score1MLbl: TLabel;
    Score2ELbl: TLabel;
    Score2MLbl: TLabel;
    Score3ELbl: TLabel;
    Score3MLbl: TLabel;
    Score1HLbl: TLabel;
    Score2HLbl: TLabel;
    Score3HLbl: TLabel;
    Score1CLbl: TLabel;
    Score2CLbl: TLabel;
    Score3CLbl: TLabel;
    // Initialises display for play level when form is activated.
    procedure FormActivate(Sender: TObject);
    // Positions Reset button when form is created.
    procedure FormCreate(Sender: TObject);
    // Resets high-score table for current skill level when Reset button is
    // clicked.
    procedure ResetBtnClick(Sender: TObject);
  strict private
    var
      // Stores value of Level property.
      fLevel: TLevel;
    // Returns a reference to the label component beginning with given name that
    // displays a name or score value at the given position in the leader board
    // for the given difficulty.
    function LabelRef(ADifficulty: TDifficulty; Position: Integer;
      TheName: string): TLabel;
    // Displays a name in appropriate position in leader board for the given
    // difficulty level.
    procedure SetName(ADifficulty: TDifficulty; Position: Integer;
      TheName: string); reintroduce; overload;
    // Displays a score in appropriate position in leader board for the given
    // difficulty level.
    procedure SetScore(ADifficulty: TDifficulty; Position: Integer;
      TheScore: string);
    // Updates high score table display with required table entries for current
    // skill level.
    procedure UpdateDisplay;
  strict protected
    // Ensures dialogue box is wide enough to accommodate Reset button in
    // addition to inherited main buttons.
    procedure AdjustWidth; override;
  public
    // Skill level for which high score table is required.
    property Level: TLevel read fLevel write fLevel;
  end;


implementation


uses
  // Delphi
  SysUtils, Math,
  // Project
  UHighScore, UMessageBox;

{$R *.DFM}


{ THighScoreDlg }

procedure THighScoreDlg.AdjustWidth;
begin
  ClientWidth := Max(BodyPanel.Width + 16, 3 * CancelBtn.Width + 24);
end;

procedure THighScoreDlg.FormActivate(Sender: TObject);
begin
  inherited;
  Caption := Format('High Scores (%s)', [fLevel.PlayAreaStr]);
  UpdateDisplay;
end;

procedure THighScoreDlg.FormCreate(Sender: TObject);
begin
  inherited;
  ResetBtn.Top := CancelBtn.Top;
  ResetBtn.Left := CancelBtn.Left - ResetBtn.Width - 4;
end;

function THighScoreDlg.LabelRef(ADifficulty: TDifficulty; Position: Integer;
  TheName: string): TLabel;
var
  FullName: string; // name of a label
const
  // character codes representing levels of difficulty that are part of label
  // names
  cDifficultyCodes: array[TDifficulty] of Char = ('E', 'M', 'H', 'C');
begin
  // Build label name
  FullName :=
    Format('%s%d%sLbl', [TheName, Position, cDifficultyCodes[ADifficulty]]);
  // Return reference to label with this name
  Result := FindComponent(FullName) as TLabel;
end;

procedure THighScoreDlg.ResetBtnClick(Sender: TObject);
var
  I: TDifficulty; // loops through difficulty levels
begin
  inherited;
  // Get user to confirm that high-scores are to be reset
  if TMessageBox.Confirm(
    Self,
    'Confirm you want to reset highscores'
  ) then
  begin
    // User accepted: loop through high score objects, resetting them
    for I := Low(TDifficulty) to High(TDifficulty) do
      fLevel.HighScores[I].Reset;
    // Update display using reset high-score objects: this will display empty
    // table
    UpdateDisplay;
  end;
end;

procedure THighScoreDlg.SetName(ADifficulty: TDifficulty; Position: Integer;
  TheName: string);
begin
  LabelRef(ADifficulty, Position, 'Name').Caption := TheName;
end;

procedure THighScoreDlg.SetScore(ADifficulty: TDifficulty; Position: Integer;
  TheScore: string);
begin
  LabelRef(ADifficulty, Position, 'Score').Caption := TheScore;
end;

procedure THighScoreDlg.UpdateDisplay;
var
  Difficulty: TDifficulty;    // loops through difficulty levels
  Position: Integer;          // loops through high scores for difficulty levels
  HighScore: THighScoreEntry; // reference to a high score object
begin
  // Loop thru all high score entries for each difficulty level
  for Difficulty := Low(TDifficulty) to High(TDifficulty) do
    for Position := 1 to CMaxHighScoreEntries do
    begin
      // Record reference to high score table object for this difficulty level
      // and table position
      HighScore := fLevel.HighScores[Difficulty][Position];
      // Set label captions of appropriate name and score labels
      SetName(Difficulty, Position, HighScore.Name);
      SetScore(Difficulty, Position, HighScore.Score);
    end;
end;

end.
