{
 * Implements static class that manages the BoobyTrap HTML Help system.
 *
 * $Rev: 93 $
 * $Date: 2013-10-29 03:02:32 +0000 (Tue, 29 Oct 2013) $
 *
 * This file is licensed under the MIT license.
 *
 * Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
 * http://codedabbler.co.uk
}


unit UHelpManager;


interface


uses
  // Delphi
  Windows;


type
  // Static class that manages the program's HTML help system.
  THelpManager = class(TObject)
  strict private
    // Returns fully specified name of help file.
    class function HelpFileName: string;
    // Returns fully specified topic URL for given topic name.
    class function TopicURL(const TopicName: string): string;
    // Calls HtmlHelp API with given command, topic name and command dependant
    // data. Topic name may be empty if no specified topic is required.
    class procedure DoAppHelp(const Command: UINT;
      const TopicName: string; const Data: DWORD);
  public
    // Displays help contents.
    class procedure Contents;
    // Displays help topic(s) specified by given A-Link keyword.
    class procedure ShowALink(const AKeyword: string);
    // Closes down the help system.
    class procedure Quit;
  end;


implementation


uses
  // Delphi
  SysUtils;

type
  // Structure used to specify one or more ALink names or KLink keywords to be
  THHAKLink = packed record
    cbStruct: Integer;    // size of this structure
    fReserved: BOOL;      // must be FALSE (really!)
    pszKeywords: LPCTSTR; // semi-colon separated keywords
    pszUrl: LPCTSTR;      // URL to jump to if no keywords found (may be nil)
    pszMsgText: LPCTSTR;  // MessageBox text on failure (used if pszUrl nil)
    pszMsgTitle: LPCTSTR; // Title of any failure MessageBox
    pszWindow: LPCTSTR;   // Window to display pszURL in
    fIndexOnFail: BOOL;   // Displays index if keyword lookup fails.
  end;

{ THelpManager }

class procedure THelpManager.Contents;
begin
  DoAppHelp(HH_DISPLAY_TOC, '', 0);
end;

class procedure THelpManager.DoAppHelp(const Command: UINT;
  const TopicName: string; const Data: DWORD);
var
  HelpURL: string; // URL of help file, or topic with help file
begin
  if TopicName = '' then
    HelpURL := HelpFileName
  else
    HelpURL := TopicURL(TopicName);
  HtmlHelp(GetDesktopWindow(), HelpURL, Command, Data);
end;

class function THelpManager.HelpFileName: string;
begin
  Result := ChangeFileExt(ParamStr(0), '.chm');
end;

class procedure THelpManager.Quit;
begin
  HtmlHelp(0, nil, HH_CLOSE_ALL, 0);
end;

class procedure THelpManager.ShowALink(const AKeyword: string);
var
  ALink: THHAKLink;   // structure containing details of A-Link
resourcestring
  // Error messages for if A-Link not found
  sNoHelpMsg = 'Sorry, there is no help available for this item.';
  sNoHelpTitle = 'BoobyTrap Help';
begin
  // This one is weird: when using the Unicode API just casting a Unicode string
  // using PChar and then assigning it to the appropriate pszXXX field of
  // THHAKLink causes HTML Help to see only the first character of the keyword.
  // We have to cast the UnicodeString to AnsiString and then to a pointer to
  // get this to work, even though the pszXXX fields are is declared as LPCTSTR,
  // which is an alias to PWideChar!
  ZeroMemory(@ALink, SizeOf(ALink));
  ALink.cbStruct := SizeOf(ALink);      // size of structure
  ALink.fIndexOnFail := False;
  ALink.pszMsgText := Pointer(AnsiString(sNoHelpMsg));
  ALink.pszMsgTitle := Pointer(AnsiString(sNoHelpTitle));
  ALink.pszKeywords := Pointer(AnsiString(AKeyword));
  DoAppHelp(HH_ALINK_LOOKUP, '', DWORD(@ALink));
end;

class function THelpManager.TopicURL(const TopicName: string): string;
begin
  Result := HelpFileName + '::/HTML/' + TopicName + '.htm';
end;

end.
