{
 * Base class for all program's dialogue box forms.
 *
 * $Rev: 93 $
 * $Date: 2013-10-29 03:02:32 +0000 (Tue, 29 Oct 2013) $
 *
 * This file is licensed under the MIT license.
 *
 * Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
 * http://codedabbler.co.uk
}


unit FmBaseDlg;


interface


uses
  // Delphi
  Controls, ExtCtrls, Classes, StdCtrls, Forms;


type
  // Base class for all dialogue box forms.
  TBaseDlg = class(TForm)
    CancelBtn: TButton;
    HelpBtn: TButton;
    BodyPanel: TPanel;
    // Handles form's OnCreate event: Sizes form and positions components
    // according to size of body panel.
    procedure FormCreate(Sender: TObject);
    // Form's OnShow event handler. Sets dialogue box parent windows and aligns
    // dialogue to that parent.
    procedure FormShow(Sender: TObject);
    // Displays help topic associated with form when help button is clicked.
    procedure HelpBtnClick(Sender: TObject);
    // Handles OnKeyDown events on form. Displays help when F1 is pressed.
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  strict protected
    // Aligns dialogue box to owner window.
    procedure AlignDlgBox; virtual;
    // Adjusts dialogue box width as necessary to accommodate all main buttons.
    // NOTE: Override this method in dialogue boxes with more that two main
    // buttons.
    procedure AdjustWidth; virtual;
    // Displays help for dialogue box using an A-link based on form's name.
    procedure DisplayHelp;
  end;


implementation


uses
  // Delphi
  Windows, Math,
  // Project
  UDlgHelper, UHelpManager;


{$R *.DFM}

procedure TBaseDlg.AdjustWidth;
begin
  ClientWidth := Max(BodyPanel.Width + 16, 2 * CancelBtn.Width + 20);
end;

procedure TBaseDlg.AlignDlgBox;
var
  OwnerForm: TForm;     // form that owns this dialogue box
  WorkArea: TRect;      // work area rectangle (excludes task bars)
  BoundsR: TRect;       // bounds rectangle of this form
begin
  if not (Owner is TForm) then
    Exit;
  OwnerForm := Owner as TForm;

  // Initialise bounding rectangle, positioned at (0,0) on screen
  BoundsR := Rect(0, 0, Self.Width, Self.Height);

  // Offset dialogue box over owner form
  if (OwnerForm.BorderStyle in [bsDialog, bsSizeToolWin, bsToolWindow]) then
    // we're centring over another dialogue box: just offset down and left a bit
    OffsetRect(BoundsR, OwnerForm.Left + 40, OwnerForm.Top + 40)
  else
    // we're probably centring over a main window: we centre dialogue over form
    OffsetRect(
      BoundsR,
      OwnerForm.Left + (OwnerForm.Width - Self.Width) div 2,
      OwnerForm.Top + (OwnerForm.Height - Self.Height) div 2
    );

  // Try to ensure form fits in work area
  WorkArea := Screen.WorkAreaRect;
  if BoundsR.Right > WorkArea.Right then
    OffsetRect(BoundsR, WorkArea.Right - BoundsR.Right, 0);
  if BoundsR.Left < WorkArea.Left then
    OffsetRect(BoundsR, WorkArea.Left - BoundsR.Left, 0);
  if BoundsR.Bottom > WorkArea.Bottom then
    OffsetRect(BoundsR, 0, WorkArea.Bottom - BoundsR.Bottom);
  if BoundsR.Top < WorkArea.Top then
    OffsetRect(BoundsR, 0, WorkArea.Top - BoundsR.Top);

  // Set position
  Self.Left := BoundsR.Left;
  Self.Top := BoundsR.Top;
end;

procedure TBaseDlg.DisplayHelp;
begin
  THelpManager.ShowALink(Self.Name);
end;

procedure TBaseDlg.FormCreate(Sender: TObject);
begin
  AdjustWidth;
  CancelBtn.Top := BodyPanel.Height + 16;
  HelpBtn.Top := CancelBtn.Top;
  ClientHeight := CancelBtn.Top + CancelBtn.Height + 4;
  HelpBtn.Left := ClientWidth - 8 - HelpBtn.Width;
  if HelpBtn.Visible then
    CancelBtn.Left := HelpBtn.Left - CancelBtn.Width - 4
  else
    CancelBtn.Left := HelpBtn.Left;
  BodyPanel.Left := (ClientWidth - BodyPanel.Width) div 2;
end;

procedure TBaseDlg.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_F1) and (Shift = []) then
  begin
    // F1 pressed with no modifier: display help
    DisplayHelp;
    Key := 0;
  end;
end;

procedure TBaseDlg.FormShow(Sender: TObject);
begin
  TDlgHelper.SetDlgParentToOwner(Self);
  AlignDlgBox;
end;

procedure TBaseDlg.HelpBtnClick(Sender: TObject);
begin
  DisplayHelp;
end;

end.
