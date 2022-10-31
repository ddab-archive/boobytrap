{
 * Class that encapsulates the Booby Trap game. It extends the TSquareGrid class
 * that encapsulates the game board.
 *
 * $Rev: 93 $
 * $Date: 2013-10-29 03:02:32 +0000 (Tue, 29 Oct 2013) $
 *
 * This file is licensed under the MIT license.
 *
 * Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
 * http://codedabbler.co.uk
}


unit UGame;


interface


uses
  // Project units
  UGlobals, USquareGrid, USquare;

type
  // Prototype of parameter-less general game events.
  TGameEvent = procedure of object;

  // Prototype of game events that provide reference to a square along with its
  // co-ordinates on grid.
  TSquareEvent = procedure(Square: TSquare; Col, Row: Integer)
    of object;

  // Enumeration of possible game states:
  //   gsNotStarted:   Game has been created but user not made first move. Clock
  //                   starts when first move made
  //   gsInProgress:   Game is under-way. Clock is ticking.
  //   gsWon:          Game is over and user won. Clock has stopped
  //   gsLost:         Game is over and user lost. Clock has stopped
  TGameState = (gsNotStarted, gsInProgress, gsWon, gsLost);

  // Class that encapsulates the Booby Trap game.
  TGame = class(TSquareGrid)
  strict private
    var
      // Number of booby traps in game.
      fBoobyTraps: Integer;
      // Number of correctly placed flags in game.
      fCorrectFlags: Integer;
      // Time that game started and ended.
      fStartTime, fEndTime: TDateTime;
      // Value of State property.
      fState: TGameState;
      // Value of AvailableFlags property.
      fAvailableFlags: Integer;
      // Reference to any hander of OnReveal event.
      fOnReveal: TSquareEvent;
      // Reference to any hander of OnFlagChanged event.
      fOnFlagChanged: TSquareEvent;
      // Reference to any hander of OnGameStart event.
      fOnGameStart: TGameEvent;
      // Reference to any hander of OnGameEnd event.
      fOnGameEnd: TGameEvent;
    // Randomly sets the required number of booby traps for the game.
    procedure SetTraps;
    // Calculates the number of booby trapped squares adjacent to each square on
    // the grid and stores the result in the square object.
    procedure CalcNeighbouringTraps;
    // Records that user has won the game, reveals squares and ends game.
    procedure Win;
    // Records that user has won the game, reveals squares and ends game.
    procedure Loose;
    // Records that game has started, starts clock and trigger OnGameStart
    // event.
    procedure GameStarted;
    // Records that game has ended and triggers OnGameEnd event.
    procedure GameEnded;
    // Flags that the square at the given column and row has been revealed and
    // triggers OnReveal event.
    procedure RevealSquare(Col, Row: Integer);
    // Flags that the square at the given column and row has changed.
    procedure FlagChanged(Col, Row: Integer);
    // Read accessor for ElapsedTime property.
    function GetElapsedTime: Integer;
  public
    // Constructs a new game instance with the given number size and number of
    // booby traps.
    constructor Create(const Size: TDimensions; Traps: Integer);
    // Reveals the square at the given co-ordinates and acts on what we find
    // there.
    procedure Reveal(Col, Row: Integer);
    // Toggles the flagged state of the square at the given co-ordinates.
    procedure ToggleFlag(Col, Row: Integer);
    // Clears the flag on the square at the given co-ordinates.
    procedure ClearFlag(Col, Row: Integer);
    // Causes the game to be halted as lost.
    procedure Surrender;
    // Current state of game.
    property State: TGameState read fState;
    // Number of flags available for flagging squares.
    property AvailableFlags: Integer read fAvailableFlags;
    // Amount of time taken by the game. If the game is in progress this is the
    // amount of time since it started. If the game has ended the value is the
    // total time taken for the game.
    property ElapsedTime: Integer read GetElapsedTime;
    // Event triggered when game is started, i.e. when user selects first square
    // to be revealed.
    property OnGameStart: TGameEvent read fOnGameStart write fOnGameStart;
    // Event triggered when game ends.
    property OnGameEnd: TGameEvent read fOnGameEnd write fOnGameEnd;
    // Event triggered when a square is revealed.
    property OnReveal: TSquareEvent read fOnReveal write fOnReveal;
    // Event triggered when the state of a flag on a square is changed.
    property OnFlagChanged: TSquareEvent read fOnFlagChanged
      write fOnFlagChanged;
  end;


implementation


uses
  // Delphi
  SysUtils, Math;


{ TGame }

procedure TGame.CalcNeighbouringTraps;
var
  Col, Row: Integer;        // loops through all columns and rows on the grid
  AdjCol, AdjRow: Integer;  // loops through adjacent columns and rows
  NumTraps: Integer;        // counts number of adjacent booby trapped squares
begin
  // Loop through all columns and rows on game grid
  for Col := 0 to Dimensions.Cols - 1 do
    for Row := 0 to Dimensions.Rows - 1 do
    begin
      NumTraps := 0;
      for AdjCol := Max(0, Col - 1) to Min(Col + 1, Dimensions.Cols - 1) do
        for AdjRow := Max(0, Row - 1) to Min(Row + 1, Dimensions.Rows - 1) do
          if Squares[AdjCol, AdjRow].BoobyTrapped
            and not ((AdjCol = Col) and (AdjRow = Row)) then
            Inc(NumTraps);
      Squares[Col, Row].NeighbouringTraps := NumTraps;
    end;
end;

procedure TGame.ClearFlag(Col, Row: Integer);
var
  Sq: TSquare;  // reference to our square object
begin
  Sq := Squares[Col, Row];
  if Sq.Flagged then
  begin
    Sq.Flagged := False;
    Inc(fAvailableFlags);
    FlagChanged(Col, Row);
    if Sq.BoobyTrapped then
      // we've un-flagged a booby trapped square, so there is one less correctly
      // flagged square
      Dec(fCorrectFlags);
  end
end;

constructor TGame.Create(const Size: TDimensions; Traps: Integer);
begin
  inherited Create(Size);
  fBoobyTraps := Traps;
  fAvailableFlags := Traps;
  fState := gsNotStarted;
  SetTraps;
  CalcNeighbouringTraps;
end;

procedure TGame.FlagChanged(Col, Row: Integer);
begin
  if Assigned(fOnFlagChanged) then
    fOnFlagChanged(Squares[Col, Row], Col, Row);
end;

procedure TGame.GameEnded;
begin
  fEndTime := Time;
  if Assigned(fOnGameEnd) then
    fOnGameEnd;
end;

procedure TGame.GameStarted;
begin
  fState := gsInProgress;
  fStartTime := Time;
  if Assigned(fOnGameStart) then
    fOnGameStart;
end;

function TGame.GetElapsedTime: Integer;
var
  Dummy1, Dummy4: Word; // unused values required for procedure call
  Mins, Secs: Word;     // elapsed minutes and seconds
begin
  case fState of
    gsNotStarted :
      Result := 0;
    gsInProgress :
    begin
      DecodeTime(Time - fStartTime, Dummy1, Mins, Secs, Dummy4);
      Result := 60 * Mins + Secs;
    end;
    gsWon, gsLost :
    begin
      DecodeTime(fEndTime - fStartTime, Dummy1, Mins, Secs, Dummy4);
      Result := 60 * Mins + Secs;
    end;
    else
      raise Exception.Create('Unexpected TGameState value for fState');
  end;
end;

procedure TGame.Loose;
var
  Col, Row: Integer;  // loop through all columns and rows on game grid
begin
  fState := gsLost;
  // reveal all booby trapped and flagged squares.
  for Col := 0 to Dimensions.Cols - 1 do
    for Row := 0 to Dimensions.Rows - 1 do
      if Squares[Col, Row].BoobyTrapped or Squares[Col, Row].Flagged then
        RevealSquare(Col, Row);
  GameEnded;
end;

procedure TGame.Reveal(Col, Row: Integer);
var
  Sq: TSquare;              // reference to square object we're revealing
  AdjCol, AdjRow: Integer;  // columns and rows adjacent to our square
begin
  Sq := Squares[Col, Row];
  if Sq.Revealed then
    Exit; // can't reveal an already revealed square
  if fState = gsNotStarted then
    GameStarted;  // 1st reveal starts game
  if Sq.Flagged then
    ClearFlag(Col, Row);  // revealed squares are not flagged, so clear it
  RevealSquare(Col, Row);
  if not Sq.BoobyTrapped then
  begin
    // if this square has no adjacent booby traps, reveal all neighbouring
    // squares recursively
    if Sq.NeighbouringTraps = 0 then
    begin
      // this process should never reveal a booby trapped square - we will
      // encounter a square with adjacent booby traps first!}
      for AdjCol := Max(0, Col - 1) to Min(Col + 1, Dimensions.Cols - 1) do
        for AdjRow := Max(0, Row - 1) to Min(Row + 1, Dimensions.Rows - 1) do
          if (AdjCol <> Col) or (AdjRow <> Row) then
            Reveal(AdjCol, AdjRow);
    end;
  end
  else
    // revealed square is booby trapped
    Loose;
end;

procedure TGame.RevealSquare(Col, Row: Integer);
begin
  Squares[Col, Row].Revealed := True;
  if Assigned(fOnReveal) then
    fOnReveal(Squares[Col, Row], Col, Row);
end;

procedure TGame.SetTraps;
var
  Col, Row: Integer;    // row and column where a trap is to be set
  TrapsToLay: Integer;  // number of traps still to be laid
begin
  Randomize;
  TrapsToLay := fBoobyTraps;
  while TrapsToLay > 0 do
  begin
    Col := Random(Dimensions.Cols);
    Row := Random(Dimensions.Rows);
    if not Squares[Col, Row].BoobyTrapped then
    begin
      Squares[Col, Row].BoobyTrapped := True;
      Dec(TrapsToLay);
    end;
  end;
end;

procedure TGame.Surrender;
begin
  if fState = gsInProgress then
    Loose;
end;

procedure TGame.ToggleFlag(Col, Row: Integer);
var
  Sq: TSquare;  // reference to the square object at given co-ordinates
begin
  Sq := Squares[Col, Row];
  if Sq.Revealed then
    Exit; // can't flag a revealed square
  if Sq.Flagged then
    // un-flag flagged square
    ClearFlag(Col, Row)
  else if fAvailableFlags > 0 then
  begin
    // we can only flag a square if it is not revealed and there are some flags
    // available
    Sq.Flagged := True;
    if Sq.BoobyTrapped then
      Inc(fCorrectFlags);
    Dec(fAvailableFlags);
    FlagChanged(Col, Row);
    if fCorrectFlags = fBoobyTraps then
      Win;
  end;
end;

procedure TGame.Win;
var
  Col, Row: Integer;  // loop through all columns and rows on game grid
begin
  fState := gsWon;
  // Reveal all non-booby trapped, un-revealed squares
  for Col := 0 to Dimensions.Cols - 1 do
    for Row := 0 to Dimensions.Rows - 1 do
      if not Squares[Col, Row].BoobyTrapped
        and not Squares[Col, Row].Revealed then
        RevealSquare(Col, Row);
  GameEnded;
end;

end.
