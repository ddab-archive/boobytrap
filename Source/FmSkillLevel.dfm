inherited SkillLevelDlg: TSkillLevelDlg
  Caption = 'Skill Levels'
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  inherited BodyPanel: TPanel
    Width = 265
    Height = 177
    ExplicitWidth = 265
    ExplicitHeight = 177
    object PlayAreaLbl: TLabel
      Left = 8
      Top = 8
      Width = 63
      Height = 13
      Caption = 'Playing area:'
    end
    object DifficultyLbl: TLabel
      Left = 8
      Top = 128
      Width = 46
      Height = 13
      Caption = 'Difficulty:'
    end
    object NumTrapsLbl: TLabel
      Left = 144
      Top = 148
      Width = 113
      Height = 13
      AutoSize = False
    end
    object PlayAreaList: TListBox
      Left = 8
      Top = 24
      Width = 121
      Height = 97
      ItemHeight = 13
      TabOrder = 0
      OnClick = PlayAreaListClick
    end
    object AddBtn: TButton
      Left = 144
      Top = 24
      Width = 113
      Height = 25
      Caption = 'Add new play area...'
      TabOrder = 2
      OnClick = AddBtnClick
    end
    object DeleteBtn: TButton
      Left = 144
      Top = 56
      Width = 113
      Height = 25
      Caption = 'Delete play area'
      TabOrder = 3
      OnClick = DeleteBtnClick
    end
    object DifficultyCombo: TComboBox
      Left = 8
      Top = 144
      Width = 121
      Height = 21
      Style = csDropDownList
      TabOrder = 1
      OnChange = DifficultyComboChange
      Items.Strings = (
        'Easy'
        'Medium'
        'Hard'
        'Custom...')
    end
  end
end
