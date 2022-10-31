{
 * Class encapsulating the game-related properties of the game grid.
 *
 * $Rev: 82 $
 * $Date: 2013-10-28 16:05:45 +0000 (Mon, 28 Oct 2013) $
 *
 * This file is licensed under the MIT license.
 *
 * Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
 * http://codedabbler.co.uk
}


unit USquareGrid;


interface


uses
  // Delphi
  Classes, Generics.Collections,
  // Project unit
  UGlobals, USquare;


type
  // Class encapsulating the properties of the game grid.
  TSquareGrid = class(TObject)
  strict private
    type
      // Type of list of squares in a row.
      TRowList = TObjectList<TSquare>;
      // Type of list of rows in a column.
      TColList = TObjectList<TRowList>;
    var
      // List of columns of the grid. Each column contains a list squares in
      // each row.
      FColList: TColList;
      // Value of Dimensions property.
      FDimensions: TDimensions;
    // Read accessor for Squares[] property.
    function GetSquare(Col, Row: Integer): TSquare;
  strict protected
    // Size of game grid.
    property Dimensions: TDimensions read FDimensions;
    // Matrix of squares on the game board.
    property Squares[Col, Row: Integer]: TSquare read GetSquare;
  public
    // Constructs a new game grid with the given number of rows and columns.
    constructor Create(const Size: TDimensions);
    // Destroys this object instance.
    destructor Destroy; override;
  end;


implementation


constructor TSquareGrid.Create(const Size: TDimensions);
var
  RowList: TRowList;  // references list squares in each row
  Col, Row: Integer;  // loop through rows and columns of grid
begin
  inherited Create;
  FDimensions := Size;
  FColList := TColList.Create(True);
  for Col := 0 to Pred(FDimensions.Cols) do
  begin
    RowList := TRowList.Create(True);
    FColList.Add(RowList);
    for Row := 0 to Pred(FDimensions.Rows) do
      RowList.Add(TSquare.Create);
  end;
end;

destructor TSquareGrid.Destroy;
begin
  FColList.Free;  // Frees owned objects
  inherited Destroy;
end;

function TSquareGrid.GetSquare(Col, Row: Integer): TSquare;
begin
  Result := FColList[Col][Row];
end;

end.
