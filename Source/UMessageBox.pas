{
 * Implements a static class that can display message and confirmation dialogue
 * boxes at an appropriate position on screen.
 *
 * $Rev: 93 $
 * $Date: 2013-10-29 03:02:32 +0000 (Tue, 29 Oct 2013) $
 *
 * This file is licensed under the MIT license.
 *
 * Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
 * http://codedabbler.co.uk
}


unit UMessageBox;


interface


uses
  // Project
  Classes, Dialogs;


type

  // Static class that can display message and confirmation dialogue boxes at an
  // appropriate position on screen.
  TMessageBox = class(TObject)
  strict private
    // Displays a message in a customised dialogue box located over a form.
    // Returns a value that indicates which button was pressed.
    // Parameters:
    //   Parent [in] Component that dialogue box is aligned over. If nil then
    //     current active form is used.
    //   Msg [in] Message displayed in dialogue.
    //   MsgType [in] Type of dialogue box. Must not be mtCustom.
    //   Buttons [in] Set of buttons to display in dialogue box.
    class function Display(const Parent: TComponent; const Msg: string;
      const MsgType: TMsgDlgType; const Buttons: TMsgDlgButtons): Word;
  public
    // Displays given message in an information dialogue box aligned over given
    // parent component.
    class procedure Information(const Parent: TComponent; const Msg: string);
    // Displays given message in an error dialogue box aligned over given parent
    // component.
    class procedure Error(const Parent: TComponent; const Msg: string);
    // Displays given message in a confirmation dialogue box aligned over given
    // parent. Returns True if user confirms or False if user cancels.
    class function Confirm(const Parent: TComponent; const Msg: string):
      Boolean;
  end;


implementation


uses
  // Delphi
  Controls, Windows, Forms,
  // Project
  UDlgHelper;


{ TMessageBox }

class function TMessageBox.Confirm(const Parent: TComponent;
  const Msg: string): Boolean;
begin
  Result := Display(Parent, Msg, mtConfirmation, [mbYes, mbNo]) = mrYes;
end;

class function TMessageBox.Display(const Parent: TComponent; const Msg: string;
  const MsgType: TMsgDlgType; const Buttons: TMsgDlgButtons): Word;
var
  Dlg: TForm; // dialogue box instance

  // Aligns dialogue box over Parent
  procedure Align;
  var
    ParentForm: TCustomForm;  // reference to form that parents the dialogue box
    BoundsR: TRect;           // bounding rectangle of dialogue
    WorkArea: TRect;          // screen's work area
  begin
    // Get reference to parent form or alternative if parent is not form
    if Parent is TCustomForm then
      ParentForm := Parent as TCustomForm
    else
      ParentForm := Screen.ActiveCustomForm;
    if not Assigned(ParentForm) then
      ParentForm := Application.MainForm;
    if not Assigned(ParentForm) then
      Exit;
    // Initialise dialogue's bounding rectangle, positioned at (0,0) on screen
    BoundsR := Rect(0, 0, Dlg.Width, Dlg.Height);
    // centre dialogue over parent form
    OffsetRect(
      BoundsR,
      ParentForm.Left + (ParentForm.Width - Dlg.Width) div 2,
      ParentForm.Top + (ParentForm.Height - Dlg.Height) div 2
    );
    // Ensure dialogue fits in work area
    WorkArea := Screen.WorkAreaRect;
    if BoundsR.Right > WorkArea.Right then
      OffsetRect(BoundsR, WorkArea.Right - BoundsR.Right, 0);
    if BoundsR.Left < WorkArea.Left then
      OffsetRect(BoundsR, WorkArea.Left - BoundsR.Left, 0);
    if BoundsR.Bottom > WorkArea.Bottom then
      OffsetRect(BoundsR, 0, WorkArea.Bottom - BoundsR.Bottom);
    if BoundsR.Top < WorkArea.Top then
      OffsetRect(BoundsR, 0, WorkArea.Top - BoundsR.Top);
    // Set position of dialogue
    Dlg.Left := BoundsR.Left;
    Dlg.Top := BoundsR.Top;
  end;

begin
  Assert(MsgType <> mtCustom,                              // ** do not localise
    'TMessageBox.Display: MsgType is mtCustom');
  Dlg := CreateMessageDialog(Msg, MsgType, Buttons);
  try
    TDlgHelper.SetDlgParent(Dlg, Parent);
    Align;
    Result := Dlg.ShowModal;
  finally
    Dlg.Free;
  end;
end;

class procedure TMessageBox.Error(const Parent: TComponent; const Msg: string);
begin
  MessageBeep(MB_ICONERROR);
  Display(Parent, Msg, mtError, [mbOK]);
end;

class procedure TMessageBox.Information(const Parent: TComponent;
  const Msg: string);
begin
  Display(Parent, Msg, mtInformation, [mbOK]);
end;

end.
