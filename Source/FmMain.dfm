object MainForm: TMainForm
  Left = 202
  Top = 328
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 409
  ClientWidth = 780
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object GameBevel: TBevel
    Left = 0
    Top = 0
    Width = 661
    Height = 385
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
  end
  object GridPanel: TPanel
    Left = 10
    Top = 10
    Width = 464
    Height = 365
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
  end
  object NewBtn: TButton
    Left = 670
    Top = 10
    Width = 104
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'New Game'
    TabOrder = 1
    OnClick = NewBtnClick
  end
  object HighScoreBtn: TButton
    Left = 670
    Top = 128
    Width = 104
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'High Scores...'
    TabOrder = 3
    OnClick = HighScoreBtnClick
  end
  object SkillLevelBtn: TButton
    Left = 670
    Top = 167
    Width = 104
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Skill Level...'
    TabOrder = 4
    OnClick = SkillLevelBtnClick
  end
  object AboutBtn: TButton
    Left = 670
    Top = 266
    Width = 104
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'About...'
    TabOrder = 6
    OnClick = AboutBtnClick
  end
  object ExitBtn: TButton
    Left = 670
    Top = 345
    Width = 104
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'E&xit'
    TabOrder = 7
    OnClick = ExitBtnClick
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 390
    Width = 780
    Height = 19
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Panels = <
      item
        Width = 150
      end
      item
        Width = 60
      end
      item
        Width = 150
      end
      item
        Width = 50
      end>
    SizeGrip = False
  end
  object SurrenderBtn: TButton
    Left = 670
    Top = 69
    Width = 104
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Surrender'
    TabOrder = 2
    OnClick = SurrenderBtnClick
  end
  object HelpBtn: TButton
    Left = 670
    Top = 226
    Width = 104
    Height = 25
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    Caption = 'Help...'
    TabOrder = 5
    OnClick = HelpBtnClick
  end
  object AboutDlg: TPJAboutBoxDlg
    Title = 'About'
    ButtonPlacing = abpRight
    VersionInfo = VersionInfo
    Position = abpOwner
    UseOwnerAsParent = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 504
    Top = 8
  end
  object Timer: TTimer
    Enabled = False
    OnTimer = TimerTimer
    Left = 504
    Top = 40
  end
  object VersionInfo: TPJVersionInfo
    Left = 472
    Top = 8
  end
  object WdwState: TPJRegWdwState
    AutoSaveRestore = True
    IgnoreState = True
    Options = [woIgnoreState, woIgnoreSize, woFitWorkArea]
    OnGetRegData = WdwStateGetRegData
    Left = 472
    Top = 40
  end
end
