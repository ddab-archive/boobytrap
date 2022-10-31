{
 * UDlgHelper.pas
 *
 * Implements "static" class that helps to manipulate dialogue boxes.
 *
 * $Rev: 93 $
 * $Date: 2013-10-29 03:02:32 +0000 (Tue, 29 Oct 2013) $
 *
 * This file is licensed under the MIT license.
 *
 * Copyright (c) 2013, Peter Johnson, http://delphidabbler.com and
 * http://codedabbler.co.uk
}


unit UDlgHelper;


interface


uses
  // Delphi
  Classes, Windows;

type
  // Static class that sets parent window of a dialogue box.
  TDlgHelper = class(TObject)
  public
    // Sets parent of given dialogue box to window associated with give parent
    // component.
    class procedure SetDlgParent(const Dlg, Parent: TComponent);
    // Sets parent of give dialogue box to its owner control.
    // NOTE: uses active form or main form as parent if owner is nil or has no
    // associated window.
    class procedure SetDlgParentToOwner(const Dlg: TComponent);
  end;


implementation


uses
  // Delphi
  SysUtils, Controls, Forms, Dialogs;


type
  // Abstraction of a window that provides information about the window.
  IWindowInfo = interface(IInterface)
    ['{8E0F5AA6-88AC-4734-99C0-2253E7CF665A}']
    // Check if window is a dialogue box.
    function IsDialog: Boolean;
    // Get bounding rectangle of window.
    function BoundsRect: TRect;
    // Get window handle.
    function Handle: THandle;
  end;

  // Abstraction of a window that can be aligned above another window.
  IAlignableWindow = interface(IInterface)
    ['{E65CAAEE-F782-4489-B2DF-2B8C4121825F}']
    // Get bounding rectangle of window.
    function BoundsRect: TRect;
    // Adjust window to have given bounding rectangle.
    procedure AdjustWindow(const Bounds: TRect);
  end;

  // Factory class that creates IWindowInfo instances from appropriate classes.
  TWindowInfoFactory = class(TObject)
  public
    // Creates a suitable IWindowInfo instance for given host component.
    class function Instance(const Host: TComponent): IWindowInfo;
  end;

  // Class that implements IAlignableWindow and IWindowInfo interfaces for a
  // form. Provides information about and positions the form.
  TFormWindow = class(TInterfacedObject,
    IAlignableWindow, IWindowInfo
  )
  strict private
    var
      // Reference to encapsulated form.
      fForm: TCustomForm;
  public
    // Check if window is a dialogue box. Method of IWindowInfo
    function IsDialog: Boolean;
    // Get bounding rectangle of window. Method of IWindowInfo and
    // IAlignableWindow
    function BoundsRect: TRect;
    // Get window handle. Method of IWindowInfo
    function Handle: THandle;
    // Adjust window to have given bounding rectangle. Method of
    // IAlignableWindow
    procedure AdjustWindow(const Bounds: TRect);
    // Creates new instance that provides for given form.
    constructor Create(const Form: TCustomForm);
  end;

{ TDlgHelper }

class procedure TDlgHelper.SetDlgParent(const Dlg, Parent: TComponent);
var
  ParentWindow: IWindowInfo;  // encapsulates parent window
  DlgWindow: IWindowInfo;     // encapsulates dialogue box window
begin
  Assert(Assigned(Dlg),                                    // ** do not localise
    'TDlgHelper.SetDlgParent: Dlg is nil');
  DlgWindow := TWindowInfoFactory.Instance(Dlg);
  ParentWindow := TWindowInfoFactory.Instance(Parent);
  SetWindowLong(DlgWindow.Handle, GWL_HWNDPARENT, ParentWindow.Handle);
end;

class procedure TDlgHelper.SetDlgParentToOwner(const Dlg: TComponent);
begin
  SetDlgParent(Dlg, Dlg.Owner);
end;

{ TWindowInfoFactory }

class function TWindowInfoFactory.Instance(
  const Host: TComponent): IWindowInfo;
begin
  Result := nil;
  if Host is TCustomForm then
    Result := TFormWindow.Create(Host as TCustomForm);
  if not Assigned(Result) then
  begin
    if Assigned(Screen.ActiveCustomForm) then
      Result := TFormWindow.Create(Screen.ActiveCustomForm)
    else if Assigned(Application.MainForm) then
      Result := TFormWindow.Create(Application.MainForm)
  end;
  Assert(Assigned(Result),                                 // ** do not localise
    'TWindowInfoFactory.Instance: Can''t create instance');
end;

{ TFormWindow }

procedure TFormWindow.AdjustWindow(const Bounds: TRect);
begin
  if IsDialog then
    fForm.SetBounds(Bounds.Left, Bounds.Top, fForm.Width, fForm.Height)
  else
    fForm.BoundsRect := Bounds;
end;

function TFormWindow.BoundsRect: TRect;
begin
  Result := fForm.BoundsRect;
end;

constructor TFormWindow.Create(const Form: TCustomForm);
begin
  Assert(Assigned(Form),                                   // ** do not localise
    'TFormWindow.Create: Form is nil');
  inherited Create;
  fForm := Form;
end;

function TFormWindow.Handle: THandle;
begin
  Result := fForm.Handle;
end;

function TFormWindow.IsDialog: Boolean;
begin
  Result := fForm.BorderStyle in [bsDialog, bsSizeToolWin, bsToolWindow];
end;

end.
