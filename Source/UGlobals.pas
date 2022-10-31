{
 * Definition of some global types and constants.
 *
 * $Rev: 58 $
 * $Date: 2013-10-28 11:18:59 +0000 (Mon, 28 Oct 2013) $
 *
 * This file is licensed under the MIT license.
 *
 * Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
 * http://codedabbler.co.uk
}


unit UGlobals;

interface

type
  // Dimensions of game grid
  TDimensions = record
    const
      // Maximum number of rows and columns allowed in game grid
      MaxCols = 32;
      MaxRows = 18;
      // Minimum number of rows and columns allowed in game grid
      MinCols = 6;
      MinRows = 6;
      // Default number of columns and rows in game grid
      DefCols = 12;
      DefRows = 8;
    var
      Cols: Integer;
      Rows: Integer;
    constructor Create(ACols, ARows: Integer);
  end;

const
  // Minimum number of booby traps allowed in custom difficulty level
  MinTraps = 2;

  // Dummy, value for a high-score, that should be greater than any we will
  // encounter.
  DummyHighScore = 99999;


implementation

{ TDimensions }

constructor TDimensions.Create(ACols, ARows: Integer);
begin
  Cols := ACols;
  Rows := ARows;
end;

end.
