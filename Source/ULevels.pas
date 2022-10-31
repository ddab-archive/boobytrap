{
 * Classes that encapsulate information about game grids and difficulty levels.
 *
 * $Rev: 93 $
 * $Date: 2013-10-29 03:02:32 +0000 (Tue, 29 Oct 2013) $
 *
 * This file is licensed under the MIT license.
 *
 * Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
 * http://codedabbler.co.uk
}


unit ULevels;


interface


uses
  // Delphi
  Classes,
  // Project
  UGlobals, UHighScore;


type
  // Levels of difficulty for each play area.
  TDifficulty = (ldEasy, ldMedium, ldHard, ldCustom);

  // Class that encapsulates a play level, i.e. the area of the game grid and
  // the difficulty levels for that grid size.
  TLevel = class(TObject)
  strict private
    var
      // Number of booby traps for the custom difficulty level.
      FCustomTraps : Integer;
      // Value of HighScores[] property.
      FHighScores : array[TDifficulty] of THighScore;
      // Value of PlayArea property.
      FPlayArea : TDimensions;
    // Read accessor for Traps[] property.
    function GetTraps(I : TDifficulty) : Integer;
    // Read accessor for HighScores[] property.
    function GetHighScore(I : TDifficulty) : THighScore;
    // Read accessor for PlayAreaStr property.
    function GetPlayAreaStr : string;
  public
    // Constructs a new instance with the given dimensions.
    constructor Create(PlayArea : TDimensions);
    // Constructs a new instance with dimensions and custom traps read from the
    // given registry key.
    constructor CreateFromReg(Key : string);
    // Destroys object instance.
    destructor Destroy; override;
    // Saves information about this level to the registry usung the given
    // registry key.
    procedure SaveToReg(Key : string);
    // Area of the game grid for this play level.
    property PlayArea : TDimensions read FPlayArea write FPlayArea;
    // Area of the game grid as a string value in form 'XX × YY'.
    property PlayAreaStr : string read GetPlayAreaStr;
    // The number of booby traps at each difficulty level.
    property Traps[I : TDifficulty] : Integer read GetTraps;
    // References to high-score objects for each difficulty level.
    property HighScores[I : TDifficulty] : THighScore read GetHighScore;
    // Sets the number of booby traps for the custom difficulty level.
    procedure SetCustomTraps(NumTraps : Integer);
  end;

  // Class that maintains a list of play level objects.
  TLevels = class(TObject)
  strict private
    var
      // Values of Levels[] property.
      FLevels : TList;
      // Value of CurrentDifficulty property.
      FCurrentDifficulty : TDifficulty;
      // Value of CurrentLevelIndex property.
      FCurrentLevelIndex : Integer;
    // Read accessor for Levels[] property.
    function GetLevel(I : Integer) : TLevel;
    // Read accessor for NumLevels property.
    function GetNumLevels : Integer;
    // Read accessor for CurrentLevel property.
    function GetCurrentLevel : TLevel;
  public
    // Constructs a new instance initialised by data read from registry.
    constructor Create;
    // Persists play level info to registry then destroys object instance.
    destructor Destroy; override;
    // Adds a new play level to list which is created from given play area
    // dimensions.
    procedure Add(PlayArea : TDimensions);
    // Deletes play area object at given index in list.
    procedure Delete(Index : Integer);
    // Indexed list of play levels.
    property Levels[I : Integer] : TLevel read GetLevel; default;
    // Number of play levels in list.
    property NumLevels : Integer read GetNumLevels;
    // Reference to current play level object.
    property CurrentLevel : TLevel read GetCurrentLevel;
    // Specifies index of the current play level object in list.
    property CurrentLevelIndex : Integer read FCurrentLevelIndex
      write FCurrentLevelIndex;
    // Current difficulty level.
    property CurrentDifficulty : TDifficulty
      read FCurrentDifficulty write FCurrentDifficulty;
  end;


implementation


uses
  // Delphi
  SysUtils,
  // Project
  USettings;


{ TLevels }

constructor TLevels.Create;
var
  I : Integer;            // loops through all play areas
  NumPlayAreas : Integer; // number of play areas per registry
begin
  inherited Create;
  FLevels := TList.Create;
  NumPlayAreas := Settings.ReadInt('', 'NumPlayAreas', 0);
  for I := 0 to NumPlayAreas - 1 do
    FLevels.Add(TLevel.CreateFromReg(Format('PlayLevel %d', [I])));
  // if no play areas found, then create default play area
  if FLevels.Count = 0 then
    Add(TDimensions.Create(TDimensions.DefCols, TDimensions.DefRows));
  // set current play area from registry
  FCurrentLevelIndex := Settings.ReadInt('', 'CurrentPlayLevel', 0);
  if FCurrentLevelIndex >= FLevels.Count then
    FCurrentLevelIndex := 0;  // adjust current level if it is invalid
  FCurrentDifficulty :=
    TDifficulty(Settings.ReadInt('', 'CurrentDifficulty', 0));
end;

destructor TLevels.Destroy;
var
  I : Integer;  // loops through all play levels
begin
  Settings.WriteInt('', 'CurrentPlayLevel', FCurrentLevelIndex);
  Settings.WriteInt('', 'CurrentDifficulty', Ord(FCurrentDifficulty));
  Settings.WriteInt('', 'NumPlayAreas', FLevels.Count);
  for I := 0 to FLevels.Count - 1 do
  begin
    Levels[I].SaveToReg(Format('PlayLevel %d', [I]));
    Levels[I].Free;
  end;
  FLevels.Free;
  inherited Destroy;
end;

procedure TLevels.Add(PlayArea : TDimensions);
begin
  FLevels.Add(TLevel.Create(PlayArea));
end;

procedure TLevels.Delete(Index : Integer);
begin
  GetLevel(Index).Free;
  FLevels.Delete(Index);
end;

function TLevels.GetLevel(I : Integer) : TLevel;
begin
  Result := TLevel(FLevels[I]);
end;

function TLevels.GetNumLevels : Integer;
begin
  Result := FLevels.Count;
end;

function TLevels.GetCurrentLevel : TLevel;
begin
  Result := Levels[FCurrentLevelIndex];
end;

{ TLevel }

constructor TLevel.Create(PlayArea : TDimensions);
var
  I : TDifficulty;  // loops through all difficulty levels
begin
  inherited Create;
  FPlayArea := PlayArea;
  for I := Low(TDifficulty) to High(TDifficulty) do
    FHighScores[I] := THighScore.Create;
end;

constructor TLevel.CreateFromReg(Key : string);
var
  I : TDifficulty;  // loops thru all difficulty levels
begin
  inherited Create;
  FPlayArea := TDimensions.Create(
    Settings.ReadInt(Key, 'Cols', TDimensions.DefCols),
    Settings.ReadInt(Key, 'Rows', TDimensions.DefRows)
  );
  FCustomTraps := Settings.ReadInt(Key, 'CustomTraps', 0);
  // create a high score table for each difficulty level
  for I := Low(TDifficulty) to High(TDifficulty) do
    FHighScores[I] := THighScore.CreateFromReg(
      Format('%s\Difficulty %d', [Key, Ord(I)]));
end;

destructor TLevel.Destroy;
var
  I : TDifficulty;  // loops through all difficulty levels
begin
  for I := Low(TDifficulty) to High(TDifficulty) do
    FHighScores[I].Free;
  inherited Destroy;
end;

procedure TLevel.SaveToReg(Key : string);
var
  I : TDifficulty;  // loops through all difficulty levels
begin
  Settings.WriteInt(Key, 'Cols', FPlayArea.Cols);
  Settings.WriteInt(Key, 'Rows', FPlayArea.Rows);
  Settings.WriteInt(Key, 'CustomTraps', FCustomTraps);
  for I := Low(TDifficulty) to High(TDifficulty) do
    FHighScores[I].SaveToReg(Format('%s\Difficulty %d', [Key, Ord(I)]));
end;

procedure TLevel.SetCustomTraps(NumTraps : Integer);
begin
  FCustomTraps := NumTraps;
end;

function TLevel.GetTraps(I : TDifficulty) : Integer;
const
  // multipliers used to calculate number of booby traps for easy, medium and
  // hard difficulty levels: these are based on number of bombs used per grid
  // size in a on an old Psion series 5 palm-top computer
  CMultipliers : array[ldEasy..ldHard] of Single = (0.125, 0.164, 0.195);
begin
  if I = ldCustom then
    // We're looking for number of custom traps: if we have no recorded value
    // then return number of booby traps for medium difficulty level.
    if FCustomTraps = 0 then
      Result := GetTraps(ldMedium)
    else
      Result := FCustomTraps
  else
    // We're looking for easy, medium or hard difficulty - multiply area of grid
    // by appropriate multiplier to get result.
    Result := Round(CMultipliers[I] * PlayArea.Cols * PlayArea.Rows);
end;

function TLevel.GetHighScore(I : TDifficulty) : THighScore;
begin
  Result := FHighScores[I];
end;

function TLevel.GetPlayAreaStr : string;
begin
  Result := Format('%d × %d', [PlayArea.Cols, PlayArea.Rows]);
end;

end.
