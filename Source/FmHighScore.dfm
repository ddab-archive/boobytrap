inherited HighScoreDlg: THighScoreDlg
  Top = 107
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  inherited BodyPanel: TPanel
    Width = 345
    Height = 347
    BevelOuter = bvRaised
    ExplicitWidth = 345
    ExplicitHeight = 347
    object BodyBvl: TBevel
      Left = 1
      Top = 1
      Width = 343
      Height = 345
      Style = bsRaised
    end
    object Bvl2E: TBevel
      Left = 4
      Top = 43
      Width = 337
      Height = 21
    end
    object Bvl3E: TBevel
      Left = 4
      Top = 64
      Width = 337
      Height = 21
    end
    object Bvl1E: TBevel
      Left = 4
      Top = 22
      Width = 337
      Height = 21
    end
    object Level1ELbl: TLabel
      Left = 12
      Top = 24
      Width = 17
      Height = 16
      Caption = '1st'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Level2ELbl: TLabel
      Left = 12
      Top = 45
      Width = 21
      Height = 16
      Caption = '2nd'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Level3ELbl: TLabel
      Left = 12
      Top = 66
      Width = 19
      Height = 16
      Caption = '3rd'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Name1ELbl: TLabel
      Left = 60
      Top = 24
      Width = 193
      Height = 16
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Name2ELbl: TLabel
      Left = 60
      Top = 45
      Width = 193
      Height = 16
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Name3ELbl: TLabel
      Left = 60
      Top = 66
      Width = 193
      Height = 16
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Score1ELbl: TLabel
      Left = 276
      Top = 24
      Width = 57
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Score2ELbl: TLabel
      Left = 276
      Top = 45
      Width = 57
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Score3ELbl: TLabel
      Left = 276
      Top = 66
      Width = 57
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object HeadingLbl1: TLabel
      Left = 4
      Top = 3
      Width = 337
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = 'Easy'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object HeadingLbl2: TLabel
      Left = 4
      Top = 88
      Width = 337
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = 'Medium'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Bvl1M: TBevel
      Left = 4
      Top = 107
      Width = 337
      Height = 21
    end
    object Bvl2M: TBevel
      Left = 4
      Top = 128
      Width = 337
      Height = 21
    end
    object Bvl3M: TBevel
      Left = 4
      Top = 149
      Width = 337
      Height = 21
    end
    object Level1MLbl: TLabel
      Left = 12
      Top = 109
      Width = 17
      Height = 16
      Caption = '1st'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Level2MLbl: TLabel
      Left = 12
      Top = 130
      Width = 21
      Height = 16
      Caption = '2nd'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Level3MLbl: TLabel
      Left = 12
      Top = 151
      Width = 19
      Height = 16
      Caption = '3rd'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Name1MLbl: TLabel
      Left = 60
      Top = 109
      Width = 193
      Height = 16
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Name2MLbl: TLabel
      Left = 60
      Top = 130
      Width = 193
      Height = 16
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Name3MLbl: TLabel
      Left = 60
      Top = 151
      Width = 193
      Height = 16
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Score1MLbl: TLabel
      Left = 276
      Top = 109
      Width = 57
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Score2MLbl: TLabel
      Left = 276
      Top = 130
      Width = 57
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Score3MLbl: TLabel
      Left = 276
      Top = 151
      Width = 57
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object HeadingLbl3: TLabel
      Left = 4
      Top = 173
      Width = 337
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = 'Hard'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Bvl1H: TBevel
      Left = 4
      Top = 192
      Width = 337
      Height = 21
    end
    object Bvl2H: TBevel
      Left = 4
      Top = 213
      Width = 337
      Height = 21
    end
    object Bvl3H: TBevel
      Left = 4
      Top = 234
      Width = 337
      Height = 21
    end
    object Level1HLbl: TLabel
      Left = 12
      Top = 194
      Width = 17
      Height = 16
      Caption = '1st'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Level2HLbl: TLabel
      Left = 12
      Top = 215
      Width = 21
      Height = 16
      Caption = '2nd'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Level3HLbl: TLabel
      Left = 12
      Top = 236
      Width = 19
      Height = 16
      Caption = '3rd'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Name1HLbl: TLabel
      Left = 60
      Top = 194
      Width = 193
      Height = 16
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Name2HLbl: TLabel
      Left = 60
      Top = 215
      Width = 193
      Height = 16
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Name3HLbl: TLabel
      Left = 60
      Top = 236
      Width = 193
      Height = 16
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Score1HLbl: TLabel
      Left = 276
      Top = 194
      Width = 57
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Score2HLbl: TLabel
      Left = 276
      Top = 215
      Width = 57
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Score3HLbl: TLabel
      Left = 276
      Top = 236
      Width = 57
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object HeadingLbl4: TLabel
      Left = 4
      Top = 258
      Width = 337
      Height = 16
      Alignment = taCenter
      AutoSize = False
      Caption = 'Custom'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Bvl1C: TBevel
      Left = 4
      Top = 277
      Width = 337
      Height = 21
    end
    object Bvl2C: TBevel
      Left = 4
      Top = 298
      Width = 337
      Height = 21
    end
    object Bvl3C: TBevel
      Left = 4
      Top = 319
      Width = 337
      Height = 21
    end
    object Level1CLbl: TLabel
      Left = 12
      Top = 279
      Width = 17
      Height = 16
      Caption = '1st'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Level2CLbl: TLabel
      Left = 12
      Top = 300
      Width = 21
      Height = 16
      Caption = '2nd'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Level3CLbl: TLabel
      Left = 12
      Top = 321
      Width = 19
      Height = 16
      Caption = '3rd'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Name1CLbl: TLabel
      Left = 60
      Top = 279
      Width = 193
      Height = 16
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Name2CLbl: TLabel
      Left = 60
      Top = 300
      Width = 193
      Height = 16
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Name3CLbl: TLabel
      Left = 60
      Top = 321
      Width = 193
      Height = 16
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Score1CLbl: TLabel
      Left = 276
      Top = 279
      Width = 57
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Score2CLbl: TLabel
      Left = 276
      Top = 300
      Width = 57
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Score3CLbl: TLabel
      Left = 276
      Top = 321
      Width = 57
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
  end
  object ResetBtn: TButton
    Left = 400
    Top = 492
    Width = 75
    Height = 25
    Caption = '&Reset'
    TabOrder = 3
    OnClick = ResetBtnClick
  end
end
