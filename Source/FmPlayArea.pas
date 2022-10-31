{
 * Implements a dialogue box that gets size of game grid from user.
 *
 * $Rev: 93 $
 * $Date: 2013-10-29 03:02:32 +0000 (Tue, 29 Oct 2013) $
 *
 * This file is licensed under the MIT license.
 *
 * Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
 * http://codedabbler.co.uk
}


unit FmPlayArea;


interface


uses
  // Delphi
  StdCtrls, Controls, ExtCtrls, Classes,
  // Project
  FmOKBaseDlg, UGlobals;


type
  // Dialogue box that gets size of game grid from user.
  TPlayAreaDlg = class(TOKBaseDlg)
    ColsLbl: TLabel;
    RowsLbl: TLabel;
    ColsEdit: TEdit;
    RowsEdit: TEdit;
    // OK button click event handler. Validates entries and updates PlayArea
    // property with entered values if all is OK.
    procedure OKBtnClick(Sender: TObject);
    // OnKeyPress event handler for both edit controls. Allows only digits or
    // backspace to be entered.
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    // Initialises controls when form is activated.
    procedure FormActivate(Sender: TObject);
  strict private
    // Value of PlayArea property.
    fPlayArea: TDimensions;
  public
    // Dimensions of the play area.
    property PlayArea: TDimensions read fPlayArea;
  end;


implementation


uses
  // Delphi
  SysUtils,
  // Project
  UMessageBox;


{$R *.DFM}


procedure TPlayAreaDlg.FormActivate(Sender: TObject);
begin
  inherited;
  ColsEdit.Text := '';
  RowsEdit.Text := '';
  ColsLbl.Caption := Format('Number of columns [%d..%d]:',
    [TDimensions.MinCols, TDimensions.MaxCols]);
  RowsLbl.Caption := Format('Number of rows [%d..%d]:',
    [TDimensions.MinRows, TDimensions.MaxRows]);
  ColsEdit.SetFocus;
end;

procedure TPlayAreaDlg.EditKeyPress(Sender: TObject; var Key: Char);
begin
  if not CharInSet(Key, ['0'..'9', #8]) then
    Key := #0;
end;

procedure TPlayAreaDlg.OKBtnClick(Sender: TObject);
var
  Cols, Rows: Integer;  // number of rows and columns entered
begin
  inherited;
  Cols := StrToIntDef(ColsEdit.Text, 0);
  Rows := StrToIntDef(RowsEdit.Text, 0);
  ModalResult := mrNone;
  // Check entered rows and columns are in required ranges
  if (Cols < TDimensions.MinCols) or (Cols > TDimensions.MaxCols) then
    TMessageBox.Error(
      Self,
      Format(
        'Columns must be in range %d..%d',
        [TDimensions.MinCols, TDimensions.MaxCols]
      )
    )
  else if (Rows < TDimensions.MinRows) or (Rows > TDimensions.MaxRows) then
    TMessageBox.Error(
      Self,
      Format(
        'Rows must be in range %d..%d',
        [TDimensions.MinRows, TDimensions.MaxRows]
      )
    )
  else
    // All OK: set modal result to allow dialogue box to close
    ModalResult := mrOK;
  if ModalResult = mrNone then
    // We had error: restore focus to columns edit box
    ColsEdit.SetFocus
  else
    // We have no error: store entered values in PlayArea property
    fPlayArea := TDimensions.Create(Cols, Rows);
end;

end.
