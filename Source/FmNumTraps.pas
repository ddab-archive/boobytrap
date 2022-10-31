{
 * Implements a dialogue box which gets custom number of booby traps from user.
 *
 * $Rev: 93 $
 * $Date: 2013-10-29 03:02:32 +0000 (Tue, 29 Oct 2013) $
 *
 * This file is licensed under the MIT license.
 *
 * Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
 * http://codedabbler.co.uk
}


unit FmNumTraps;


interface


uses
  // Delphi
  StdCtrls, Controls, ExtCtrls, Classes,
  // Project
  FmOKBaseDlg;


type
  // Dialogue box which gets custom number of booby traps for a given skill
  // level from user.
  TNumTrapsDlg = class(TOKBaseDlg)
    NumTrapsLbl: TLabel;
    NumTrapsEdit: TEdit;
    // OnKeyPress event handler for edit control. Allows only digits or
    // backspace to be entered.
    procedure NumTrapsEditKeyPress(Sender: TObject; var Key: Char);
    // OK button click event handler. Validates input and returns entered value
    // in NumTraps property if OK.
    procedure OKBtnClick(Sender: TObject);
    // Initialises controls when form is activated.
    procedure FormActivate(Sender: TObject);
  strict private
    // Value of NumTraps property.
    fNumTraps: Integer;
    // Value of LowerLimit property.
    fLowerLimit: Integer;
    // Value of UpperLimit property.
    fUpperLimit: Integer;
  public
    // Number of traps. Set to current value before dialogue box displayed and
    // returns new value if user clicks OK.
    property NumTraps: Integer read fNumTraps write fNumTraps;
    // Lowest acceptable number of booby traps.
    property LowerLimit: Integer read fLowerLimit write fLowerLimit;
    // Highest acceptable number of booby traps.
    property UpperLimit: Integer read fUpperLimit write fUpperLimit;
  end;


implementation


uses
  // Delphi
  SysUtils,
  // Project
  UMessageBox;


{$R *.DFM}

procedure TNumTrapsDlg.FormActivate(Sender: TObject);
begin
  NumTrapsLbl.Caption := Format('Number of booby traps [%d..%d]:',
    [fLowerLimit, fUpperLimit]);
  NumTrapsEdit.Text := IntToStr(NumTraps);
  NumTrapsEdit.SelectAll;
  NumTrapsEdit.SetFocus;
end;

procedure TNumTrapsDlg.NumTrapsEditKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

procedure TNumTrapsDlg.OKBtnClick(Sender: TObject);
var
  NumTraps: Integer;  // number of traps per edit control
begin
  inherited;
  NumTraps := StrToIntDef(NumTrapsEdit.Text, 0);
  if (NumTraps < fLowerLimit) or (NumTraps > fUpperLimit) then
  begin
    ModalResult := mrNone;
    TMessageBox.Error(
      Self,
      Format(
        'Number of booby traps must be in range %0:d to %d',
        [fLowerLimit, fUpperLimit]
      )
    );
    NumTrapsEdit.SetFocus;
  end
  else
    fNumTraps := NumTraps;
end;

end.
