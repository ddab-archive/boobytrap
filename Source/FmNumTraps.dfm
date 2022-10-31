inherited NumTrapsDlg: TNumTrapsDlg
  Caption = 'Edit Number of Booby Traps'
  OnActivate = FormActivate
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
  end
  inherited BodyPanel: TPanel
    Width = 241
    Height = 36
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExplicitWidth = 241
    ExplicitHeight = 36
    object NumTrapsLbl: TLabel
      Left = 11
      Top = 12
      Width = 3
      Height = 13
      FocusControl = NumTrapsEdit
    end
    object NumTrapsEdit: TEdit
      Left = 168
      Top = 8
      Width = 65
      Height = 21
      MaxLength = 3
      TabOrder = 0
      OnKeyPress = NumTrapsEditKeyPress
    end
  end
  inherited OKBtn: TButton
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    OnClick = OKBtnClick
  end
end
