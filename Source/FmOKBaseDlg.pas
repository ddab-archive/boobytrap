{
 * Base class for dialogue boxes with three main buttons, inc OK button.
 *
 * $Rev: 68 $
 * $Date: 2013-10-28 13:17:59 +0000 (Mon, 28 Oct 2013) $
 *
 * This file is licensed under the MIT license.
 *
 * Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
 * http://codedabbler.co.uk
}


unit FmOKBaseDlg;


interface


uses
  // Delphi
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls,
  // Project
  FmBaseDlg;

type
  // Base class for dialogue boxes OK, Cancel and Help buttons
  TOKBaseDlg = class(TBaseDlg)
    OKBtn: TButton;
    // Aligns controls, including OK button added in this class.
    procedure FormCreate(Sender: TObject);
  strict protected
    // Ensures dialogue box is wide enough to accommodate all three main
    // buttons.
    procedure AdjustWidth; override;
  end;


implementation


uses
  // Delphi
  Math;

{$R *.DFM}

{ TOKBaseDlg }

procedure TOKBaseDlg.FormCreate(Sender: TObject);
begin
  inherited;
  OKBtn.Left := CancelBtn.Left - OKBtn.Width - 4;
  OKBtn.Top := CancelBtn.Top;
end;

procedure TOKBaseDlg.AdjustWidth;
begin
  ClientWidth := Max(BodyPanel.Width + 16, 3 * CancelBtn.Width + 24);
end;

end.
