{
 * Visual component that displays and controls the Booby Trap game grid.
 *
 * $Rev: 93 $
 * $Date: 2013-10-29 03:02:32 +0000 (Tue, 29 Oct 2013) $
 *
 * This file is licensed under the MIT license.
 *
 * Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
 * http://codedabbler.co.uk
}


unit CmpGameGrid;


interface


uses
  // Delphi
  Controls, Classes,
  // Project unit
  CmpGameSquare, UGlobals;

type
  // Visual component that displays and controls the Booby Trap game grid.
  // Uses the custom TTrapSquare component.
  // This component is not intended for installation on VCL component palette.
  TGameGrid = class(TCustomControl)
  strict private
    type
      // Type of event handler for OnMouseClick event. Passes co-ordinates of
      // square that was clicked in Col and Row, along with information about
      // mouse action in Button and Shift.
      TSquareClickEvent = procedure(Sender: TObject; Col, Row: Integer;
        Button: TMouseButton; Shift: TShiftState) of object;
    var
      // Value of Dimensions property.
      fDimensions: TDimensions;
      // Reference to any OnSquareClick event handler.
      fOnSquareClick: TSquareClickEvent;
    // On click event handler for handling OnCLick events of owned TTrapSquare
    // components.
    procedure SquareClickHandler(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    // Read accessor for Squares[] property.
    function GetSquare(Col, Row: Integer): TTrapSquare;
  public
    // Sets size of game grid to given number of Columns and Rows.
    procedure SetSize(const Size: TDimensions);
    // Reset game grid squares to clear state.
    procedure Reset;
    // Dimensions of game grid.
    property Dimensions: TDimensions read fDimensions;
    // 2D array of squares in game grid
    property Squares[Cols, Rows: Integer]: TTrapSquare read GetSquare;
    // OnSquareClick event triggered whenever user clicks a square on game grid.
    property OnSquareClick: TSquareClickEvent
      read fOnSquareClick write fOnSquareClick;
  end;


implementation


{ TGameGrid }

function TGameGrid.GetSquare(Col, Row: Integer): TTrapSquare;
begin
  Result := (Controls[Col * Dimensions.Rows + Row]) as TTrapSquare;
end;

procedure TGameGrid.Reset;
var
  I, J: Integer;  // loop through columns and rows
begin
  for I := 0 to Dimensions.Cols - 1 do
    for J := 0 to Dimensions.Rows - 1 do
      Squares[I, J].State := msClear;
end;

procedure TGameGrid.SetSize(const Size: TDimensions);
var
  I, J: Integer;    // loop across all columns and rows of game grid
  Sq: TTrapSquare;  // reference to each trap square belonging to grid
begin
  fDimensions := Size;
  // Free any existing child controls: these can only be TTrapSquare components.
  for I := ControlCount - 1 downto 0 do
    Controls[I].Free;
  // Set up new grid by creating a new child TTrapSquare component for each
  // position in the new grid.
  for I := 0 to Dimensions.Cols - 1 do
    for J := 0 to Dimensions.Rows - 1 do
    begin
      Sq := TTrapSquare.Create(Owner);
      Sq.Parent := Self;
      Sq.Left := I * CSquareSize;
      Sq.Top := J * CSquareSize;
      Sq.OnMouseDown := SquareClickHandler;
    end;
  Width := Dimensions.Cols * CSquareSize;
  Height := Dimensions.Rows * CSquareSize;
end;

procedure TGameGrid.SquareClickHandler(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  I: Integer;         // loops through all child controls
  ControlId: Integer; // index of clicked square control
  Row, Col: Integer;  // row and column ids of clicked square control
begin
  ControlId := -1;
  for I := 0 to ControlCount - 1 do
    if Controls[I] = Sender then
    begin
      ControlId := I;
      Break;
    end;
  Assert(ControlID <> -1);
  // Calculate column and row references from position in control array.
  Col := ControlId div Dimensions.Rows;
  Row := ControlId mod Dimensions.Rows;
  if Assigned(fOnSquareClick) then
    fOnSquareClick(Self, Col, Row, Button, Shift);
end;

end.
