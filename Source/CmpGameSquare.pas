{
 * Implements a graphic control component that encapsulates one square of game
 * grid.
 *
 * $Rev: 93 $
 * $Date: 2013-10-29 03:02:32 +0000 (Tue, 29 Oct 2013) $
 *
 * This file is licensed under the MIT license.
 *
 * Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
 * http://codedabbler.co.uk
}


unit CmpGameSquare;


interface


uses
  // Delphi
  Controls, Classes, Generics.Collections, Windows, Graphics;


{$Include Resource.inc} // bitmap resource identifiers


const
  // Size of a game square in pixels
  cSquareSize = 16;

  // Square display state identifiers: used to determine how square appears
  msFlag = -3;            // Covered square: Flagged
  msQuery = -2;           // Covered square: Queried - displays ?
  msClear = -1;           // Covered square: No markings
  msEmpty = 0;            // Revealed square: No adjacent traps
  {1..8}                  // Revealed square: Number of adjacent traps
  msNoTrap = 9;           // Revealed square: X => no trap where we flagged one
  msExplodedTrap = 10;    // Revealed square: Trap that we landed on
  msTrap = 11;            // Revealed square: Trap not landed on
  msFlaggedTrap = 12;     // Revealed square: Flagged trap not landed on

type
  // Range of square state identifiers.
  TTrapSquareState = msFlag..msFlaggedTrap;

  // Graphic control component that encapsulates one square of game grid. This
  // component is not for installation on VCL palette.
  TTrapSquare = class(TGraphicControl)
  strict private
    class var
      // List of images used to display squares in various states.
      // NOTE: we don't use TImageList because it draws too slowly.
      fImgList: TObjectList<TBitmap>;
    var
      // Value of State property.
      fState: TTrapSquareState;
      // Write accessor for State property.
    procedure SetState(AState: TTrapSquareState);
  public
    // Class constructor: loads required square images
    class constructor Create;
    // Class destructor: frees square images.
    class destructor Destroy;
    // Constructs and initialises new component instance.
    constructor Create(AOwner: TComponent); override;
    // Override of inherited SetBounds method that prevents square size from
    // being changed.
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    // Paints the square according to its state.
    procedure Paint; override;
    // Sets or gets the display state of the square.
    property State: TTrapSquareState read fState write SetState;
    // Inherited property made public
    property OnMouseDown;
  end;


implementation


{ TTrapSquare }

constructor TTrapSquare.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Default display state is clear: uncovered with no markers
  fState := msClear;
end;

class constructor TTrapSquare.Create;
var
  I: Integer;     // iterates through all images in resource file
  Bmp: TBitmap;   // used to create bitmap from image
begin
  fImgList := TObjectList<TBitmap>.Create(True);
  // Add bitmap to list for each image in resource file
  for I := FIRST_BMP to LAST_BMP do
  begin
    Bmp := TBitmap.Create;
    Bmp.Handle := LoadBitmap(HInstance, MakeIntResource(I));
    fImgList.Add(Bmp);
  end;
end;

class destructor TTrapSquare.Destroy;
begin;
  fImgList.Free;  // frees owned object
end;

procedure TTrapSquare.Paint;
begin
  Canvas.Draw(0, 0, fImgList[BMP_OFFSET + fState]);
end;

procedure TTrapSquare.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, CSquareSize, CSquareSize);
end;

procedure TTrapSquare.SetState(AState: TTrapSquareState);
begin
  if fState <> AState then
  begin
    fState := AState;
    Invalidate;
  end;
end;

end.
