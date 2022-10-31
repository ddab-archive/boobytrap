inherited InputBoxDlg: TInputBoxDlg
  Caption = 'InputBoxDlg'
  PixelsPerInch = 96
  TextHeight = 13
  inherited CancelBtn: TButton
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
  end
  inherited HelpBtn: TButton
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Visible = False
  end
  inherited BodyPanel: TPanel
    Width = 401
    Height = 65
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExplicitWidth = 401
    ExplicitHeight = 65
    object InputLabel: TLabel
      Left = 8
      Top = 8
      Width = 51
      Height = 13
      Caption = 'InputLabel'
    end
    object InputEdit: TEdit
      Left = 8
      Top = 24
      Width = 385
      Height = 21
      TabOrder = 0
    end
  end
  inherited OKBtn: TButton
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
  end
end
