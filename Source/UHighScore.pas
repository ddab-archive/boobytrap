{
 * Classes that encapsulate the functionality of a high score table.
 *
 * $Rev: 93 $
 * $Date: 2013-10-29 03:02:32 +0000 (Tue, 29 Oct 2013) $
 *
 * This file is licensed under the MIT license.
 *
 * Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
 * http://codedabbler.co.uk
}


unit UHighScore;

interface

const
  // Maximum number of entries in high score table.
  CMaxHighScoreEntries = 3;

type
  // Class that encapsulates an entry in a high score table.
  THighScoreEntry = class(TObject)
  strict private
    var
      // Value of Name property.
      fName: string;
      // Value of Score property.
      fScore: Integer;
    // Read accessor for Score property.
    function GetScore: string;
  public
    // Create new high score entry instance for given name and score.
    constructor Create(Name: string; Score: Integer);
    // Create new high score entry instance from information stored in given
    // registry key.
    constructor CreateFromReg(Key: string);
    // Create new blank, dummy values, high score entry instance.
    constructor CreateBlank;
    // Saves information about this high score entry to registry under given
    // key.
    procedure SaveToReg(Key: string);
    // Checks if given score is better than this one.
    function BeatenBy(AScore: Integer): Boolean;
    // Name of person whose high score this is.
    property Name: string read fName;
    // The high score.
    property Score: string read GetScore;
  end;

  // Class that encapsulates a high score table.
  THighScore = class(TObject)
  strict private
    var
      // Values of Entries[] property.
      fEntries: array[1..CMaxHighScoreEntries] of THighScoreEntry;
    // Read accessor for Entries[] property.
    function GetEntry(I: Integer): THighScoreEntry;
  public
    // Constructs a new, empty high score table object.
    constructor Create;
    // Constructs a new high score table instance populated by values store in
    // registry under the given key.
    constructor CreateFromReg(Key: string);
    // Destroys current instance.
    destructor Destroy; override;
    // Saves content of high score table to regsitry under given key.
    procedure SaveToReg(Key: string);
    // Resets high score table.
    procedure Reset;
    // Indexed list of high score table entries.
    property Entries[I: Integer]: THighScoreEntry read GetEntry; default;
    // Attempts to make an entry in high score table for the given user with the
    // given score. If the score sufficiently high an entry is created and its
    // 1-based index in high score table is returned. If the entry is rejected
    // the table remains unchanged and 0 is returned.
    function EnterScore(Name: string; Score: Integer): Integer;
    // Checks if the given score is good enough to be entered in the high score
    // table.
    function GoodEnough(Score: Integer): Boolean;
  end;


implementation


uses
  // Delphi
  SysUtils,
  // Project
  UGlobals, USettings;


{ THighScore }

constructor THighScore.Create;
var
  I: Integer; // loops through all rows of table
begin
  inherited Create;
  {Create empty (dummy valued) rows in table}
  for I := 1 to CMaxHighScoreEntries do
    fEntries[I] := THighScoreEntry.CreateBlank;
end;

constructor THighScore.CreateFromReg(Key: string);
var
  I: Integer; // loops through all rows in table
begin
  inherited Create;
  for I := 1 to CMaxHighScoreEntries do
    fEntries[I] := THighScoreEntry.CreateFromReg(
      Format('%s\Entry %d', [Key, I]));
end;

destructor THighScore.Destroy;
var
  I: Integer; // loops through all table rows
begin
  for I := 1 to CMaxHighScoreEntries do
    fEntries[I].Free;
end;

function THighScore.EnterScore(Name: string; Score: Integer): Integer;
var
  I: Integer; // loops through all table rows
begin
  // set default "not good enough" result.
  Result := 0;
  // scan table entries checking if given score beats any of the current values:
  // record index in table of value that is "beaten".
  for I :=  1 to CMaxHighScoreEntries do
    if fEntries[I].BeatenBy(Score) then
    begin
      Result := I;
      Break;
    end;
  if Result > 0 then
  begin
    // beaten a score: add new entry and delete last entry in table
    fEntries[CMaxHighScoreEntries].Free;
    for I := CMaxHighScoreEntries downto Result + 1 do
      fEntries[I] := fEntries[I - 1];
    fEntries[Result] := THighScoreEntry.Create(Name, Score);
  end;
end;

function THighScore.GetEntry(I: Integer): THighScoreEntry;
begin
  Result := fEntries[I];
end;

function THighScore.GoodEnough(Score: Integer): Boolean;
var
  I: Integer; // loops through all table rows
begin
  Result := False;
  for I :=  1 to CMaxHighScoreEntries do
    if fEntries[I].BeatenBy(Score) then
    begin
      Result := True;
      Break;
    end;
end;

procedure THighScore.Reset;
var
  I: Integer; // loops through all table rows
begin
  for I := 1 to CMaxHighScoreEntries do
  begin
    fEntries[I].Free;
    fEntries[I] := THighScoreEntry.CreateBlank;
  end;
end;

procedure THighScore.SaveToReg(Key: string);
var
  I: Integer; // loops through all table rows
begin
  for I := 1 to CMaxHighScoreEntries do
    fEntries[I].SaveToReg(Format('%s\Entry %d', [Key, I]));
end;

{ THighScoreEntry }

function THighScoreEntry.BeatenBy(AScore: Integer): Boolean;
begin
  Result := (fScore > AScore);
end;

constructor THighScoreEntry.Create(Name: string; Score: Integer);
begin
  inherited Create;
  fName := Name;
  fScore := Score;
end;

constructor THighScoreEntry.CreateBlank;
begin
  Create('', DummyHighScore);
end;

constructor THighScoreEntry.CreateFromReg(Key: string);
begin
  Create(
    Settings.ReadStr(Key, 'Name', ''),
    Settings.ReadInt(Key, 'Score', DummyHighScore)
  );
end;

function THighScoreEntry.GetScore: string;
begin
  if fScore = DummyHighScore then
    Result := ''
  else
    Result := IntToStr(fScore);
end;

procedure THighScoreEntry.SaveToReg(Key: string);
begin
  Settings.WriteStr(Key, 'Name', fName);
  Settings.WriteInt(Key, 'Score', fScore);
end;

end.
