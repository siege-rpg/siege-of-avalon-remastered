unit ExitGame;
{******************************************************************************}
{                                                                              }
{               Siege Of Avalon : Open Source Edition                          }
{               -------------------------------------                          }
{                                                                              }
{ Portions created by Digital Tome L.P. Texas USA are                          }
{ Copyright ©1999-2000 Digital Tome L.P. Texas USA                             }
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

}
{******************************************************************************}

interface

uses
  sdl,
  sdlgameinterface,
  SiegeInterfaces;

type
  TExitGame = class( TSimpleSoAInterface )
  private
    DxTextMessage : PSDL_Surface;
    procedure SetNextGameInterface( Next : TGameInterfaceClass );
  public
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
  GameMainMenu;

{ TExitGame }

procedure TExitGame.FreeSurfaces;
begin
  SDL_FreeSurface( DxTextMessage );
  inherited;
end;

procedure TExitGame.KeyDown( var Key : TSDLKey; Shift : TSDLMod; unicode : UInt16 );
begin
  inherited;
  case Key of
    SDLK_RETURN, SDLK_KP_ENTER :
      begin
        SetNextGameInterface( nil );
      end;

    SDLK_ESCAPE :
      begin
        SetNextGameInterface( TMainMenu );
      end;
  end;
end;

procedure TExitGame.LoadSurfaces;
var
  Flags : Cardinal;
  C : TSDL_Color;
begin
  inherited;
  Flags := SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL;

  DXBack := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + SoASettings.LanguagePath + '/' + 'ldChooseBox.bmp' ) );
  SDL_SetColorKey( DXBack, Flags, SDL_MapRGB( DXBack.format, 0, 255, 255 ) );

  C.r := 231;
  C.g := 156;
  C.b := 0;
  GameFont.ForeGroundColour := C;
  C.r := 0;
  C.g := 0;
  C.b := 0;
  GameFont.BackGroundColour := C;
  GameFont.FontSize := 18;
  
  ExText.Open( 'Intro' );
  DxTextMessage := GameFont.DrawText( ExText.GetText( 'Message0' ), 261, 55 );
  SDL_SetColorKey( DxTextMessage, Flags, SDL_MapRGB( DxTextMessage.format, 0, 0, 0 ) );
end;

procedure TExitGame.MouseDown( Button : Integer; Shift : TSDLMod; CurrentPos : TPoint );
begin
  inherited;
  if PointIsInRect( CurrentPos, 304, 318, 357, 350 ) then
  begin //Yes pressed- quit game
    SetNextGameInterface( nil );
  end
  else if PointIsInRect( CurrentPos, 440, 318, 492, 350 ) then
  begin //No pressed- just show screen
    SetNextGameInterface( TMainMenu )
  end;
end;

procedure TExitGame.MouseMove( Shift : TSDLMod; CurrentPos,
  RelativePos : TPoint );
begin
  inherited;

end;

procedure TExitGame.Render;
var
  Rect : TSDL_Rect;
begin
  inherited;
  Rect.x := ( MainWindow.DisplaySurface.w - DxTextMessage.w ) shr 1;
  Rect.y := ( ( MainWindow.DisplaySurface.h - DxTextMessage.h ) shr 1 ) - 20;
  Rect.w := DxTextMessage.w;
  Rect.h := DxTextMessage.h;
  SDL_BlitSurface( DxTextMessage, nil, MainWindow.DisplaySurface, @Rect );
end;

procedure TExitGame.SetNextGameInterface( Next : TGameInterfaceClass );
begin
  NextGameInterface := Next;
  MainWindow.Rendering := false;
end;

end.
 