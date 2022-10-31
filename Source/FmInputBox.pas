{
 * Implements a simple input dialogue box with a single edit field and
 * customisable prompt and caption.
 *
 * $Rev: 64 $
 * $Date: 2013-10-28 12:01:51 +0000 (Mon, 28 Oct 2013) $
 *
 * This file is licensed under the MIT license.
 *
 * Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
 * http://codedabbler.co.uk
}


unit FmInputBox;


interface


uses
  // Delphi
  StdCtrls, Controls, ExtCtrls, Classes,
  // Project
  FmOKBaseDlg;


type

  // Simple input dialogue box with a single edit field and customisable prompt
  // and caption.
  TInputBoxDlg = class(TOKBaseDlg)
    InputLabel: TLabel;
    InputEdit: TEdit;
  public
    // Displays dialogue box with given owner and caption and default input
    // string and returns text entered by user.
    // NOTE: ADefault is returned if user cancels.
    class function Execute(AOwner: TComponent; const ACaption, APrompt,
      ADefault: string): string;
  end;


implementation


{$R *.dfm}

{ TInputBoxDlg }

class function TInputBoxDlg.Execute(AOwner: TComponent; const ACaption,
  APrompt, ADefault: string): string;
begin
  with TInputBoxDlg.Create(AOwner) do
    try
      Caption := ACaption;
      InputLabel.Caption := APrompt;
      InputEdit.Text := ADefault;
      if ShowModal = mrOK then
        Result := InputEdit.Text
      else
        Result := ADefault;
    finally
      Free;
    end;
end;

end.
