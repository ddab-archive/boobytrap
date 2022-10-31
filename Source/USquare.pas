{
 * Class encapsulating the game-related properties of a square in the game grid.
 *
 * $Rev: 80 $
 * $Date: 2013-10-28 15:27:40 +0000 (Mon, 28 Oct 2013) $
 *
 * This file is licensed under the MIT license.
 *
 * Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
 * http://codedabbler.co.uk
}


unit USquare;


interface


type
  // Class encapsulating the game-related properties of a square in the game
  // grid.
  TSquare = class(TObject)
  strict private
    var
      // Value of BoobyTrapped property.
      FBoobyTrapped : Boolean;
      // Value of Revealed property.
      FRevealed : Boolean;
      // Value of NeighbouringTraps property.
      FNeighbouringTraps : Integer;
      // Value of Flagged property.
      FFlagged : Boolean;
  public
    // Flag that indicates if square is booby-trapped.
    property BoobyTrapped : Boolean read FBoobyTrapped write FBoobyTrapped;
    // Flag that indicates if square has been revealed.
    property Revealed : Boolean read FRevealed write FRevealed;
    // Number of neighbouring squares that are booby-trapped.
    property NeighbouringTraps : Integer read FNeighbouringTraps
      write FNeighbouringTraps;
    // Flag that indicates if square has been flagged as suspected of being
    // booby-trapped.
    property Flagged : Boolean read FFlagged write FFlagged;
  end;

implementation

end.
