{
 * Main program window class. Handles user interaction with game grid, user
 * actions and displays status info.
 *
 * $Rev: 93 $
 * $Date: 2013-10-29 03:02:32 +0000 (Tue, 29 Oct 2013) $
 *
 * This file is licensed under the MIT license.
 *
 * Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
 * http://codedabbler.co.uk
}


unit FmMain;


interface


uses
  // Delphi
  ExtCtrls, ComCtrls, StdCtrls, Controls, Classes, Forms, Windows, Messages,
  // 3rd party components
  PJWdwState, PJVersionInfo, PJAbout,
  // Project
  CmpGameGrid, UGame, USquare, ULevels;


type
  // Implements application's main window and associated event handlers.
  TMainForm = class(TForm)
    GridPanel: TPanel;
    NewBtn: TButton;
    HighScoreBtn: TButton;
    SkillLevelBtn: TButton;
    AboutBtn: TButton;
    ExitBtn: TButton;
    StatusBar: TStatusBar;
    AboutDlg: TPJAboutBoxDlg;
    GameBevel: TBevel;
    Timer: TTimer;
    SurrenderBtn: TButton;
    HelpBtn: TButton;
    VersionInfo: TPJVersionInfo;
    WdwState: TPJRegWdwState;
    // Displays About box when About button is clicked.
    procedure AboutBtnClick(Sender: TObject);
    // Exits program when Exit button is clicked.
    procedure ExitBtnClick(Sender: TObject);
    // Displays help contents when Help button is clicked.
    procedure HelpBtnClick(Sender: TObject);
    // Displays current high scores table when High Scores button is clicked.
    procedure HighScoreBtnClick(Sender: TObject);
    // Starts a new game when New Game button is clicked.
    procedure NewBtnClick(Sender: TObject);
    // Displays Skill Level dilaog box and handles and updates game board as
    // necessary when Skill Level button is clicked.
    procedure SkillLevelBtnClick(Sender: TObject);
    // Surrenders current game when Surrender button is clicked.
    procedure SurrenderBtnClick(Sender: TObject);
    // Creates owned objects and initialises form when it is first created.
    procedure FormCreate(Sender: TObject);
    // Frees owned objects and releases help system when form closes.
    procedure FormDestroy(Sender: TObject);
    // Handles game timer's OnTimer event: updates current game's elapsed time.
    procedure TimerTimer(Sender: TObject);
    // Handles Window state component's OnGetRegData event: informs component of
    // name of registry sub-key to use to store window state data.
    procedure WdwStateGetRegData(var RootKey: HKEY; var SubKey: String);
    // Displays help contents when F1 key is pressed.
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  strict private
    // Game grid component. Created dynamically.
    fGameGrid: TGameGrid;
    // Co-ordinates of current square on game grid.
    fCurSquare: TPoint;
    // Game engine object.
    fGame: TGame;
    // Object representing the games difficulty levels & high-scores.
    fPlayLevels: TLevels;
    // Displays the high-score list.
    procedure DisplayHighScores;
    // Handler for Game objects OnFlagChanged event that provides a reference to
    // the square that has been changed, along with its row and column.
    // NOTE: This handler is not called when a flagged square is revealed.
    procedure FlagToggle(Square: TSquare; Col, Row: Integer);
    // Event handler for game grid component's OnSquareClick event. Provides the
    // row and column of the clicked square along with information about the
    // state of the mouse.
    procedure GridClick(Sender: TObject; Col, Row: Integer;
      Button: TMouseButton; Shift: TShiftState);
    // Handler for game engine's OnReveal event that provides a reference to the
    // square being revealed, along with its row and column. Causes the game
    // grid component to reveal the appropriate square in the correct state.
    procedure RevealSquare(Square: TSquare; Col, Row: Integer);
    // Starts a new game.
    procedure StartNewGame;
    // Handler for Game object's OnGameEnd event. This is called when user
    // either wins the game explicitly or steps on a booby trap.
    procedure GameEnding;
    // Event handler for Game object's OnGameStart event. This is called when
    // user clicks first square.
    procedure GameStarting;
    // Updates state of buttons according to state of game.
    procedure UpdateButtons;
    // Tell user they've lost the game.
    procedure UserLooses;
    // Tells user that they've won the game and updates and displays leader
    // board if appropriate.
    procedure UserWins;
  end;

var
  MainForm: TMainForm;


implementation


uses
  // Delphi
  SysUtils,
  // Project
  CmpGameSquare, FmHighScore, FmInputBox, FmSkillLevel, UGlobals, UHelpManager,
  UHighScore, UMessageBox, USettings;


{$R *.DFM}


{ TMainForm }

procedure TMainForm.AboutBtnClick(Sender: TObject);
begin
  AboutDlg.Execute;
end;

procedure TMainForm.DisplayHighScores;
var
  Dlg: THighScoreDlg;   // the high-score dialogue box
begin
  Dlg := THighScoreDlg.Create(Self);
  try
    Dlg.Level := fPlayLevels.CurrentLevel;
    Dlg.ShowModal;
  finally
    Dlg.Free;
  end;
end;

procedure TMainForm.ExitBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.FlagToggle(Square: TSquare; Col, Row: Integer);
const
  // constant array storing singular and plural suffixes
  cPlural: array[Boolean] of string[1] = ('', 's');
begin
  if Square.Flagged then
    fGameGrid.Squares[Col, Row].State := msFlag
  else
    fGameGrid.Squares[Col, Row].State := msClear;
  StatusBar.Panels[2].Text := Format('%d flag%s available',
    [fGame.AvailableFlags, cPlural[fGame.AvailableFlags <> 1]]);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Caption := VersionInfo.ProductName;
  Application.Title := VersionInfo.ProductName;
  Settings := TSettings.Create;
  fPlayLevels := TLevels.Create;
  fGameGrid := TGameGrid.Create(Self);
  fGameGrid.Parent := GridPanel;
  fGameGrid.Left := 4;
  fGameGrid.Top := 4;
  fGameGrid.OnSquareClick := GridClick;
  fCurSquare := Point(-1, -1);
  StartNewGame;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  fGame.Free;
  fPlayLevels.Free;
  Settings.Free;
  THelpManager.Quit;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Key = VK_F1) and (Shift = []) then
  begin
    // F1 pressed with no modifier: display help noting called from key-press
    Key := 0;
    THelpManager.Contents;
  end;
end;

procedure TMainForm.GameEnding;
begin
  Timer.Enabled := False;
  StatusBar.Panels[1].Text := IntToStr(fGame.ElapsedTime) + ' secs';
  if fGame.State = gsWon then
    UserWins
  else
    UserLooses;
  UpdateButtons;
end;

procedure TMainForm.GameStarting;
begin
  StatusBar.Panels[0].Text := 'In progress';
  Timer.Enabled := True;
  StatusBar.Panels[1].Text := IntToStr(fGame.ElapsedTime) + ' secs';
  UpdateButtons;
end;

procedure TMainForm.GridClick(Sender: TObject; Col, Row: Integer;
  Button: TMouseButton; Shift: TShiftState);
var
  NeedQuery: Boolean; // true if we need to switch on a query flag
begin
  // Check if there's a game in progress - do nothing if not
  if fGame.State in [gsWon, gsLost] then
    Exit;
  if Button = mbLeft then
  begin
    fCurSquare := Point(Col, Row);
    fGame.Reveal(Col, Row);
  end
  else if (Button = mbRight) and (fGameGrid.Squares[Col, Row].State < 0) then
  begin
    if not (ssShift in Shift) then
    begin
      // shift key not pressed
      fGame.ToggleFlag(Col, Row)
    end
    else
    begin
      // shift key pressed
      NeedQuery := (fGameGrid.Squares[Col, Row].State <> msQuery);
      fGame.ClearFlag(Col, Row);
      if NeedQuery then
        fGameGrid.Squares[Col, Row].State := msQuery
      else
        fGameGrid.Squares[Col, Row].State := msClear;
    end;
  end;
end;

procedure TMainForm.HelpBtnClick(Sender: TObject);
begin
  THelpManager.Contents;
end;

procedure TMainForm.HighScoreBtnClick(Sender: TObject);
begin
  DisplayHighScores;
end;

procedure TMainForm.NewBtnClick(Sender: TObject);
begin
  StartNewGame;
end;

procedure TMainForm.RevealSquare(Square: TSquare; Col, Row: Integer);
var
  TheState: TTrapSquareState;   // the state of the given square
begin
  if Square.BoobyTrapped then
    if (fCurSquare.X = Col) and (fCurSquare.Y = Row) then
      // revealed square is current one: display exploding bomb
      TheState := msExplodedTrap
    else if Square.Flagged then
      // revealed trap was flagged: display it in a different colour so user
      // can see this
      TheState := msFlaggedTrap
    else
      // revealed square isn't current one: display ordinary trap
      TheState := msTrap
  else if (fGameGrid.Squares[Col, Row].State = msFlag)
    and (fGame.State in [gsWon, gsLost]) then
    // square is not booby-trapped but user has flagged it and game is over:
    // display "no bomb" symbol
    TheState := msNoTrap
  else
    // display number of adjacent squares (or none)
    TheState := Square.NeighbouringTraps;
  fGameGrid.Squares[Col, Row].State := TheState;
end;

procedure TMainForm.SkillLevelBtnClick(Sender: TObject);
var
  Dlg: TSkillLevelDlg;      // instance of Skill Level dialogue box
  PlayLevel: Integer;       // records current play level (area)
  Difficulty: TDifficulty;  // records current difficulty within play level
begin
  Dlg := TSkillLevelDlg.Create(Self);
  try
    PlayLevel := fPlayLevels.CurrentLevelIndex;
    Difficulty := fPlayLevels.CurrentDifficulty;
    Dlg.Levels := fPlayLevels;
    Dlg.ShowModal;
    // Check if user changed either play level (area) or difficulty level and,
    // if we're not inside a game, start a new one (this ensures new grid size
    // etc are displayed).
    if ((PlayLevel <> fPlayLevels.CurrentLevelIndex)
      or (Difficulty <> fPlayLevels.CurrentDifficulty))
      and (fGame.State = gsNotStarted) then
      StartNewGame;
  finally
    Dlg.Free;
  end;
end;

procedure TMainForm.StartNewGame;
var
  Size: TDimensions;  // number of rows and columns in current play area
  Traps: Integer;     // number of traps in current play level
begin
  Size := fPlayLevels.CurrentLevel.PlayArea;
  Traps := fPlayLevels.CurrentLevel.Traps[fPlayLevels.CurrentDifficulty];
  fGameGrid.SetSize(Size);
  GridPanel.Width := fGameGrid.Width + 8;
  GridPanel.Height := fGameGrid.Height + 8;
  GridPanel.Left := GameBevel.Left + (GameBevel.Width - GridPanel.Width) div 2;
  GridPanel.Top := GameBevel.Top + (GameBevel.Height - GridPanel.Height) div 2;
  // Get rid of any old game object and create a new game object with required
  // dimensions and number of traps
  fGame.Free;
  fGame := TGame.Create(Size, Traps);
  fGame.OnReveal := RevealSquare;
  fGame.OnFlagChanged := FlagToggle;
  fGame.OnGameStart := GameStarting;
  fGame.OnGameEnd := GameEnding;
  StatusBar.Panels[0].Text := 'Click a square to start';
  StatusBar.Panels[1].Text := '';
  StatusBar.Panels[2].Text := Format('%d flags available',
    [fGame.AvailableFlags]);
  StatusBar.Panels[3].Text := Format('%d booby traps in a %d × %d grid',
    [Traps, Size.Cols, Size.Rows]);
  UpdateButtons;
end;

procedure TMainForm.SurrenderBtnClick(Sender: TObject);
begin
  fGame.Surrender;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  StatusBar.Panels[1].Text := IntToStr(fGame.ElapsedTime) + ' secs';
end;

procedure TMainForm.UpdateButtons;
begin
  SurrenderBtn.Enabled := (fGame.State = gsInProgress);
  SkillLevelBtn.Enabled := fGame.State <> gsInProgress;
end;

procedure TMainForm.UserLooses;
begin
  StatusBar.Panels[0].Text := 'You loose';
end;

procedure TMainForm.UserWins;
var
  Name: string;             // user's name
  Score: Integer;           // user's score
  LeaderBoard: THighScore;  // reference to appropriate leader board object
begin
  StatusBar.Panels[0].Text := 'You win!!!';
  // Check to see if score qualifies for place on leader board
  Score := fGame.ElapsedTime;
  LeaderBoard :=
    fPlayLevels.CurrentLevel.HighScores[fPlayLevels.CurrentDifficulty];
  if LeaderBoard.GoodEnough(Score) then
  begin
    TMessageBox.Information(
      Self,
      'You win!'#10#10'Your score is among the best and has been placed on '
        + 'the high-score list'
    );
    Name := TInputBoxDlg.Execute(Self, 'Your name', 'Enter your name', '');
    LeaderBoard.EnterScore(Name, Score);
    DisplayHighScores;
  end
  else
    TMessageBox.Information(
      Self,
      'You win!'#10#10'But your score is not quick enough to be placed on the '
        + 'high-score list'
    );
end;

procedure TMainForm.WdwStateGetRegData(var RootKey: HKEY;
  var SubKey: String);
begin
  SubKey := TSettings.RegPath + '\Window';
end;

end.
