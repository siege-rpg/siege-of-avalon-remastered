unit GameIntro;
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
  Revision 1.2  2004/10/02 21:44:19  savage
  Repositioned Siege Logo

  Revision 1.1  2004/09/30 22:49:20  savage
  Initial Game Interface units.


}
{******************************************************************************}

interface

uses
  sdl,
  SiegeInterfaces;

type  
  TGameIntro = class( TSimpleSoAInterface )
  private
    DXSiege, DXLogo : PSDL_Surface;
    TotalTime : single;
    LogoAlpha, SiegeAlpha : integer;
  public
    procedure FreeSurfaces; override;
    procedure LoadSurfaces; override;
    procedure Render; override;
    procedure MouseDown( Button : Integer; Shift : TSDLMod; CurrentPos : TPoint ); override;
    procedure MouseWheelScroll( WheelDelta : Integer; Shift : TSDLMod; CurrentPos : TPoint ); override;
    procedure KeyDown( var Key : TSDLKey; Shift : TSDLMod; unicode : UInt16 ); override;
    procedure Update( aElapsedTime : single ); override;
  end;

implementation

uses
  SysUtils,
  //sdlaudiomixer,
  logger,
  globals,
  GameMainMenu;

{ TGameIntro }

procedure TGameIntro.FreeSurfaces;
begin
  SDL_FreeSurface( DXSiege );

  SDL_FreeSurface( DXLogo );
  inherited;
end;

procedure TGameIntro.KeyDown( var Key : TSDLKey; Shift : TSDLMod; unicode : UInt16 );
const
  FailName : string = 'TGameIntro.KeyDown';
begin
  inherited;
  try
    MainWindow.Rendering := false;
  except
    on E: Exception do
      Log.LogError( E.Message, FailName );
  end;
end;

procedure TGameIntro.LoadSurfaces;
const
  FailName : string = 'TGameIntro.LoadSurfaces';
var
  Flags : Cardinal;
  //IntroMusic : TSDLMusic;
begin
  inherited;
  try
    Flags := SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL;

    DXSiege := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'aniSiege.bmp' ) );
    Log.LogStatus( 'Loaded aniSiege.bmp', FailName );
    SDL_SetColorKey( DXSiege, Flags, SDL_MapRGB( DXSiege.format, 0, 255, 255 ) );

    DXLogo := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'aniDTIPresents.bmp' ) );
    Log.LogStatus( 'Loaded aniDTIPresents.bmp', FailName );
    SDL_SetColorKey( DXLogo, Flags, SDL_MapRGB( DXLogo.format, 0, 255, 255 ) );

    DXBack := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'aniBack.bmp' ) );
    Log.LogStatus( 'Loaded aniBack.bmp', FailName );
    SDL_SetColorKey( DXBack, Flags, SDL_MapRGB( DXBack.format, 0, 255, 255 ) );

    LogoAlpha := 0;
    SiegeAlpha := 0;

    NextGameInterface := TMainMenu;
    Log.LogStatus( 'NextGameInterface TMainMenu', FailName );

    // GameAudio.MusicManager.Add( TSDLMusic.Create( ) );
  except
    on E: Exception do
      Log.LogError( E.Message, FailName );
  end;
end;

procedure TGameIntro.MouseDown( Button : Integer; Shift : TSDLMod; CurrentPos : TPoint );
const
  FailName : string = 'TGameIntro.MouseDown';
begin
  inherited;
  try
    MainWindow.Rendering := false;
  except
    on E: Exception do
      Log.LogError( E.Message, FailName );
  end;
end;

procedure TGameIntro.MouseWheelScroll( WheelDelta : Integer; Shift : TSDLMod; CurrentPos : TPoint );
const
  FailName : string = 'TGameIntro.MouseWheelScroll';
begin
  inherited;
  try
    MainWindow.Rendering := false;
  except
    on E: Exception do
      Log.LogError( E.Message, FailName );
  end;
end;

procedure TGameIntro.Render;
const
  FailName : string = 'TGameIntro.Render';
var
  Rect : TSDL_Rect;
begin
  inherited;
  try
    Rect.x := 0;
    Rect.y := 0;
    Rect.w := DxSiege.w;
    Rect.h := DxSiege.h;
    SDL_SetAlpha( DxSiege, SDL_RLEACCEL or SDL_SRCALPHA, SiegeAlpha );
    SDL_BlitSurface( DxSiege, nil, MainWindow.DisplaySurface, @Rect );

    Rect.x := MainWindow.DisplaySurface.w - ( DxLogo.w - 200 );
    Rect.y := ( MainWindow.DisplaySurface.h - DxLogo.h ) - 20;
    Rect.w := DxLogo.w;
    Rect.h := DxLogo.h;
    SDL_SetAlpha( DxLogo, SDL_RLEACCEL or SDL_SRCALPHA, LogoAlpha );
    SDL_BlitSurface( DxLogo, nil, MainWindow.DisplaySurface, @Rect );
  except
    on E: Exception do
      Log.LogError( E.Message, FailName );
  end;
end;

procedure TGameIntro.Update(aElapsedTime: single);
const
  FailName : string = 'TGameIntro.Update';
begin
  inherited;
  try
    TotalTime := TotalTime + aElapsedTime;
    if TotalTime > 1.980 then
    begin
      SiegeAlpha := SiegeAlpha + 5;
      if SiegeAlpha > 255 then
        SiegeAlpha := 255
    end;

    if TotalTime > 10.980 then
    begin
      LogoAlpha := LogoAlpha + 5;
      if LogoAlpha > 255 then
        LogoAlpha := 255
    end;
    if TotalTime > 18 then
      MainWindow.Rendering := false;
  except
    on E: Exception do
      Log.LogError( E.Message, FailName );
  end;
end;

end.
 