unit GameMainMenu;
{******************************************************************************}
{                                                                              }
{               Siege Of Avalon : Open Source Edition                          }
{               -------------------------------------                          }
{                                                                              }
{ Portions created by Digital Tome L.P. Texas USA are                          }
{ Copyright �1999-2000 Digital Tome L.P. Texas USA                             }
{ All Rights Reserved.                                                         }
{                                                                              }
{ Portions created by Team SOAOS are                                           }
{ Copyright (C) 2003 - Team SOAOS.                                             }
{                                                                              }
{                                                                              }
{ Contributor(s)                                                               }
{ --------------                                                               }
{ Dominique Louis <Dominique@SavageSoftware.com.au>                            }
{                                                                              }
{                                                                              }
{                                                                              }
{ You may retrieve the latest version of this file at the SOAOS project page : }
{   http://www.sourceforge.com/projects/soaos                                  }
{                                                                              }
{ The contents of this file maybe used with permission, subject to             }
{ the GNU Lesser General Public License Version 2.1 (the "License"); you may   }
{ not use this file except in compliance with the License. You may             }
{ obtain a copy of the License at                                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Software distributed under the License is distributed on an                  }
{ "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or               }
{ implied. See the License for the specific language governing                 }
{ rights and limitations under the License.                                    }
{                                                                              }
{ Description                                                                  }
{ -----------                                                                  }
{                                                                              }
{                                                                              }
{                                                                              }
{                                                                              }
{                                                                              }
{                                                                              }
{                                                                              }
{ Requires                                                                     }
{ --------                                                                     }
{   SDL ( http://www.libsdl.org ) and DirectX ( http://www.microsoft.com )     }
{   Runtime libraris on Win32 and just SDL ( http://www.libsdl.org ) shared    }
{   objects or their equivalents on Linux and other Unixes                     }
{                                                                              }
{ Programming Notes                                                            }
{ -----------------                                                            }
{   Should compile with Delphi, Kylix and FreePascal on Win32 and Linux for    }
{   starter and FreeBSD and MacOS X etc there after.                           }
{                                                                              }
{                                                                              }
{ Revision History                                                             }
{ ----------------                                                             }
{   September   30 2004 - DL : Initial Creation                                }
{                                                                              }
{
  $Log$
  Revision 1.1  2004/09/30 22:49:20  savage
  Initial Game Interface units.


}
{******************************************************************************}

interface

uses
  sdl,
  SiegeInterfaces;

type
  TMainMenuRect = record
    Rect : TSDL_Rect;
    Image : PSDL_Surface;
    Enabled : boolean;
  end;

  TMainMenu = class( TSimpleSoAInterface )
  private
    FMenuChoice : integer;
    FPrevChoice : integer;
    procedure GetMenuRect( var MenuItem : TMainMenuRect; X, Y : integer; BM : PSDL_Surface );
    procedure SetNextGameInterface;
    function Exit : boolean;
  public
    MenuItems : array[ 1..8 ] of TMainMenuRect;
    procedure FreeSurfaces; override;
    procedure LoadSurfaces; override;
    procedure Render; override;
    procedure MouseDown( Button : Integer; Shift : TSDLMod; CurrentPos : TPoint ); override;
    procedure MouseMove( Shift : TSDLMod; CurrentPos : TPoint; RelativePos : TPoint ); override;
    procedure KeyDown( var Key : TSDLKey; Shift : TSDLMod; unicode : UInt16 ); override;
  end;

implementation

uses
  globals,
  NewGame,
  LoadSaveGame,
  GameOptions,
  GameJournal,
  GameCredits,
  YesNoDialog;

const
  XFrame = 106;
  YFrame = 41;

{ TMainMenu }

procedure TMainMenu.FreeSurfaces;
var
  i : integer;
begin
  for i := Low( MenuItems ) to High( MenuItems ) do
  begin
    SDL_FreeSurface( MenuItems[ i ].Image );
  end;
  inherited;
end;

procedure TMainMenu.KeyDown( var Key : TSDLKey; Shift : TSDLMod; unicode : UInt16 );
begin
  inherited;
  case Key of
    SDLK_RETURN :
      begin
        SetNextGameInterface;
      end;

    SDLK_ESCAPE :
      begin
        FMenuChoice := 7;
        SetNextGameInterface;
      end;

    SDLK_UP : dec( FMenuChoice );

    SDLK_DOWN : inc( FMenuChoice );
  end;

  if FMenuChoice > High( MenuItems ) then
    FMenuChoice := Low( MenuItems )
  else if FMenuChoice < Low( MenuItems ) then
    FMenuChoice := High( MenuItems );
end;

procedure TMainMenu.LoadSurfaces;
const
  XFrame = 106;
  YFrame = 41;
var
  Flags : Cardinal;
  Rect : TSDL_Rect;
  MainText : PSDL_Surface;
  Y1 : integer;
begin
  inherited;
  FPrevChoice := 0; // Reset menu item
  FMenuChoice := 1; // Highlight new game

  Flags := SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL;

  DXBack := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'gMainMenuBlank.bmp' ) );
  SDL_SetColorKey( DXBack, Flags, SDL_MapRGB( DXBack.format, 0, 255, 255 ) );

  MainText := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + SoASettings.LanguagePath + '/' + 'gMainMenuText.bmp' ) );
  SDL_SetColorKey( DXBack, Flags, SDL_MapRGB( DXBack.format, 0, 255, 255 ) );
  Rect.x := 106;
  Rect.y := 41;
  Rect.w := 582;
  Rect.h := 416;

  SDL_BlitSurface( MainText, nil, DXBack, @Rect );

  SDL_FreeSurface( MainText );

  MainText := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + SoASettings.LanguagePath + '/' + 'gMainMenuTextBttns.bmp' ) );
  Y1 := YFrame;
  GetMenuRect( MenuItems[ 1 ], XFrame, Y1, MainText );

  inc( Y1, 52 );
  GetMenuRect( MenuItems[ 2 ], XFrame, Y1, MainText );

  inc( Y1, 52 );
  GetMenuRect( MenuItems[ 3 ], XFrame, Y1, MainText );

  inc( Y1, 52 );
  GetMenuRect( MenuItems[ 4 ], XFrame, Y1, MainText );

  inc( Y1, 52 );
  GetMenuRect( MenuItems[ 5 ], XFrame, Y1, MainText );

  inc( Y1, 52 );
  GetMenuRect( MenuItems[ 6 ], XFrame, Y1, MainText );

  inc( Y1, 52 );
  GetMenuRect( MenuItems[ 7 ], XFrame, Y1, MainText );

  inc( Y1, 52 );
  GetMenuRect( MenuItems[ 8 ], XFrame, Y1, MainText );

  ExText.Open( 'Intro' );
  
  SDL_FreeSurface( MainText );
end;

procedure TMainMenu.GetMenuRect( var MenuItem : TMainMenuRect; X, Y : integer; BM : PSDL_Surface );
const
  W = 582;
  H = 52;
var
  Flags : Cardinal;
begin
  MenuItem.Rect.x := X - XFrame;
  MenuItem.Rect.y := Y - YFrame;
  MenuItem.Rect.w := X + W;
  MenuItem.Rect.h := Y + H;

  MenuItem.Image := SDL_CreateRGBSurface( SDL_SWSURFACE, W, H,
    MainWindow.DisplaySurface.format.BitsPerPixel, MainWindow.DisplaySurface.format.RMask, MainWindow.DisplaySurface.format.GMask,
    MainWindow.DisplaySurface.format.BMask, MainWindow.DisplaySurface.format.AMask );

  Flags := SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL;
  SDL_SetColorKey( MenuItem.Image, Flags, SDL_MapRGB( MenuItem.Image.format, 255, 0, 255 ) );
  SDL_BlitSurface( BM, @MenuItem.Rect, MenuItem.Image, nil );
end;

procedure TMainMenu.MouseDown( Button : Integer; Shift : TSDLMod; CurrentPos : TPoint );
var
  i : integer;
begin
  inherited;
  for i := 1 to 8 do
  begin
    if {MenuItems[ i ].enabled
    and}PointIsInRect( CurrentPos, MenuItems[ i ].Rect.x, MenuItems[ i ].Rect.x, MenuItems[ i ].Rect.w, MenuItems[ i ].Rect.h ) then
    begin
      FMenuChoice := i;
      SetNextGameInterface;
      break;
    end;
  end;
end;

procedure TMainMenu.MouseMove( Shift : TSDLMod; CurrentPos, RelativePos : TPoint );
var
  i : integer;
begin
  inherited;
  for i := 1 to 8 do
  begin
    if {MenuItems[ i ].enabled
    and}PointIsInRect( CurrentPos, MenuItems[ i ].Rect.x, MenuItems[ i ].Rect.x, MenuItems[ i ].Rect.w, MenuItems[ i ].Rect.h ) then
    begin
      FMenuChoice := i;
      break;
    end;
  end;
end;

procedure TMainMenu.Render;
var
  Rect : TSDL_Rect;
begin
  inherited;
  if FMenuChoice <> FPrevChoice then
  begin
    Rect.x := MenuItems[ FMenuChoice ].Rect.x + 105;
    Rect.y := MenuItems[ FMenuChoice ].Rect.y + 45;
    Rect.w := MenuItems[ FMenuChoice ].Rect.w - MenuItems[ FMenuChoice ].Rect.x;
    Rect.h := MenuItems[ FMenuChoice ].Rect.h - MenuItems[ FMenuChoice ].Rect.y;
    SDL_BlitSurface( MenuItems[ FMenuChoice ].Image, nil, MainWindow.DisplaySurface, @Rect );
  end;
end;

procedure TMainMenu.SetNextGameInterface;
begin
  MainWindow.Rendering := false;
  case FMenuChoice of
    1 : NextGameInterface := TNewGame;
    2 : NextGameInterface := TLoadGame;
    3 : NextGameInterface := TSaveGame;
    4 : NextGameInterface := TGameOptions;
    5 : NextGameInterface := TGameJournal;
    6 : NextGameInterface := TGameCredits;
    7 :
    begin
      if Exit then
        NextGameInterface := nil
      else
        MainWindow.Rendering := true;
    end ;
    8 : NextGameInterface := TMainMenu;
  end;
end;

function TMainMenu.Exit: boolean;
var
  YesNo : TYesNoDialog;
begin
  YesNo := TYesNoDialog.Create( SoAoSGame );
  try
    YesNo.QuestionText := ExText.GetText( 'Message0' );
    YesNo.LoadSurfaces;
    SoAoSGame.Show;
    Result := ( YesNo.DialogResult = drYes );
  finally
    YesNo.Free;
  end;
  ResetInputManager;
end;

end.
 