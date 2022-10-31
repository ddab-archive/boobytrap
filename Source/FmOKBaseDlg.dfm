inherited OKBaseDlg: TOKBaseDlg
  Caption = 'OKBaseDlg'
  PixelsPerInch = 96
  TextHeight = 13
  inherited CancelBtn: TButton
    Caption = 'Cancel'
    TabOrder = 2
  end
  inherited HelpBtn: TButton
    TabOrder = 3
  end
  object OKBtn: TButton
    Left = 399
    Top = 492
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
end
