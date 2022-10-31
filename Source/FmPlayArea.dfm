inherited PlayAreaDlg: TPlayAreaDlg
  Caption = 'New Play Area'
  OnActivate = FormActivate
  ExplicitWidth = 660
  ExplicitHeight = 555
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
    Width = 217
    Height = 70
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    ExplicitWidth = 217
    ExplicitHeight = 70
    object ColsLbl: TLabel
      Left = 8
      Top = 12
      Width = 145
      Height = 13
      AutoSize = False
      FocusControl = ColsEdit
    end
    object RowsLbl: TLabel
      Left = 8
      Top = 44
      Width = 145
      Height = 13
      AutoSize = False
      FocusControl = RowsEdit
    end
    object ColsEdit: TEdit
      Left = 160
      Top = 8
      Width = 49
      Height = 21
      MaxLength = 3
      TabOrder = 0
      OnKeyPress = EditKeyPress
    end
    object RowsEdit: TEdit
      Left = 160
      Top = 40
      Width = 49
      Height = 21
      MaxLength = 3
      TabOrder = 1
      OnKeyPress = EditKeyPress
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
