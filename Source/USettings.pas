{
 * Handles persistent variables of program using Windows registry.
 *
 * $Rev: 93 $
 * $Date: 2013-10-29 03:02:32 +0000 (Tue, 29 Oct 2013) $
 *
 * This file is licensed under the MIT license.
 *
 * Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
 * http://codedabbler.co.uk
}


unit USettings;

interface

uses
  // Delphi
  Registry;

type

  // Class that saves and loads persistent program settings using registry
  TSettings = class(TObject)
  strict private
    var
      // Registry access object.
      fReg: TRegistry;
  public
    // Constructs new instance.
    constructor Create;
    // Destroys current instance.
    destructor Destroy; override;
    // Writes the given integer to the named value under the given sub-key.
    procedure WriteInt(Key, Name: string; Value: Integer);
    // Reads an integer from the named value under the given sub-key.
    // Substitutes the given default value if no such entry is found.
    function ReadInt(Key, Name: string; Default: Integer): Integer;
    // Writes the given string to the named value under the given sub-key.
    procedure WriteStr(Key, Name: string; Value: string);
    // Reads a string from the named value under the given sub-key. Substitutes
    // the given default value if no such entry is found.
    function ReadStr(Key, Name: string; Default: string): string;
    // Returns the program's main, top-level, registry sub-key.
    class function RegPath: string;
  end;

var
  // Golbal variable containing an instance of TSettings.
  Settings: TSettings;


implementation


uses
  // Delphi
  SysUtils, Windows,
  // Project
  UGlobals;

const
  // Program's top-level registry sub-key
  CRegPath = '\Software\delphiDabbler\BoobyTrap\1.0';


// Helper function that returns the registry key built from program's sub-key
// and given subsidiary key.
function BuildKey(SubPath: string): string;
begin
  Result := CRegPath;
  if SubPath <> '' then
    Result := Result + '\' + SubPath;
end;

{ TSettings }

constructor TSettings.Create;
begin
  inherited Create;
  if (Win32MajorVersion = 5) and (Win32MinorVersion = 0) then
    // Windows 2000: doesn't support KEY_WOW64_64KEY.
    fReg := TRegistry.Create
  else
    // If not Windows 2000 it must be Windows XP or later since program only
    // runs on Windows 2000 and later.
    fReg := TRegistry.Create(KEY_ALL_ACCESS or KEY_WOW64_64KEY);
end;

destructor TSettings.Destroy;
begin
  fReg.Free;
  inherited Destroy;
end;

function TSettings.ReadInt(Key, Name: string; Default: Integer): Integer;
begin
  if fReg.OpenKey(BuildKey(Key), False) and fReg.ValueExists(Name) then
    Result := fReg.ReadInteger(Name)
  else
    Result := Default;
end;

function TSettings.ReadStr(Key, Name: string; Default: string): string;
begin
  if fReg.OpenKey(BuildKey(Key), False) and fReg.ValueExists(Name) then
    Result := fReg.ReadString(Name)
  else
    Result := Default;
end;

class function TSettings.RegPath: string;
begin
  Result := CRegPath;
end;

procedure TSettings.WriteInt(Key, Name: string; Value: Integer);
begin
  if fReg.OpenKey(BuildKey(Key), True) then
    fReg.WriteInteger(Name, Value);
end;

procedure TSettings.WriteStr(Key, Name: string; Value: string);
begin
  if fReg.OpenKey(BuildKey(Key), True) then
    fReg.WriteString(Name, Value);
end;

end.
