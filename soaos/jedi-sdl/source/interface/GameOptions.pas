unit GameOptions;
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
  Classes,
  sdl,
  SiegeInterfaces;

type
  TGameOptions = class( TSimpleSoAInterface )
  private
    DXContinue, DXYellow, DXVolumeSlider, DXVolumeShadow : PSDL_Surface;
    DxTextMessage : array[ 0..4 ] of PSDL_Surface;
    SpellList : TStringList;
    MouseIsOverContinue, MouseIsOverSound, MouseIsOverMusic, MouseIsOverShadows, MouseIsOverSpells : Boolean;
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
  SysUtils,
  globals,
  GameMainMenu;

{ TGameOptions }

procedure TGameOptions.FreeSurfaces;
var
  i : integer;
begin
  SDL_FreeSurface( DXContinue );
  SDL_FreeSurface( DXYellow );
  SDL_FreeSurface( DXVolumeSlider );
  SDL_FreeSurface( DXVolumeShadow );
  for i := Low( DxTextMessage ) to High( DxTextMessage ) do
    SDL_FreeSurface( DxTextMessage[ i ] );

  ExText.Close;
  inherited;
end;

procedure TGameOptions.KeyDown( var Key : TSDLKey; Shift : TSDLMod; unicode : UInt16 );
begin
  inherited;
  MainWindow.Rendering := false;
end;

procedure TGameOptions.LoadSurfaces;
var
  Flags : Cardinal;
  i : integer;
  C : TSDL_Color;
begin
  inherited;
  Flags := SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL;

  ExText.Open( 'Options' );
  C.r := 231;
  C.g := 156;
  C.b := 0;
  GameFont.ForeGroundColour := C;
  C.r := 0;
  C.g := 0;
  C.b := 0;
  GameFont.BackGroundColour := C;
  {if SoASettings.UseSmallFont then
    GameFont.FontSize := 13
  else}
  GameFont.FontSize := 18;
  for i := 0 to 4 do
  begin
    DxTextMessage[ i ] := GameFont.DrawText( ExText.GetText( 'Message' + inttostr( i ) ) );
    SDL_SetColorKey( DxTextMessage[ i ], Flags, SDL_MapRGB( DxTextMessage[ i ].format, 0, 0, 0 ) );
  end;

  //TODO : { if Character <> nil then SpellList := Character.SpellList; }

  DXContinue := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'opContinue.bmp' ) );
  SDL_SetColorKey( DXContinue, Flags, SDL_MapRGB( DXContinue.format, 0, 255, 255 ) );

  DXYellow := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'opYellow.bmp' ) );
  SDL_SetColorKey( DXYellow, Flags, SDL_MapRGB( DXYellow.format, 0, 255, 255 ) );

  DXVolumeSlider := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'opVolume.bmp' ) );
  SDL_SetColorKey( DXVolumeSlider, Flags, SDL_MapRGB( DXVolumeSlider.format, 0, 255, 255 ) );

  DXVolumeShadow := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'opVolumeShadow.bmp' ) );
  SDL_SetColorKey( DXVolumeShadow, Flags, SDL_MapRGB( DXVolumeShadow.format, 0, 255, 255 ) );

  DXBack := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'options.bmp' ) );
  SDL_SetColorKey( DXBack, Flags, SDL_MapRGB( DXBack.format, 0, 255, 255 ) );

  NextGameInterface := TMainMenu; // TODO : Change this to something more appropriate
end;

procedure TGameOptions.MouseDown( Button : Integer; Shift : TSDLMod; CurrentPos : TPoint );
begin
  inherited;
  if PointIsInRect( CurrentPos, 500, 450, 700, 495 ) then
  begin // clicked continue
    MainWindow.Rendering := false;
  end;
end;

procedure TGameOptions.MouseMove( Shift : TSDLMod; CurrentPos, RelativePos : TPoint );
begin
  inherited;
  if Dragging then
  begin
  end
  else
  begin
    MouseIsOverContinue := false;
    MouseIsOverSound := false;
    MouseIsOverMusic := false;
    MouseIsOverShadows := false;
    MouseIsOverSpells := false;
    if PointIsInRect( CurrentPos, 500, 450, 700, 495 ) then
      MouseIsOverContinue := true
    else if PointIsInRect( CurrentPos, 100, 61, 332, 126 ) then
      MouseIsOverSound := true
    else if PointIsInRect( CurrentPos, 9, 144, 332, 209 ) then
      MouseIsOverMusic := true
    else if PointIsInRect( CurrentPos, 350, 61, 695, 98 ) then
      MouseIsOverShadows := true
    else if PointIsInRect( CurrentPos, 359, 670, 121, 240 ) then
      MouseIsOverSpells := true;
  end;
end;

procedure TGameOptions.Render;
var
  Rect : TSDL_Rect;
begin
  inherited;
  if MouseIsOverContinue then
  begin
    Rect.x := 400;
    Rect.y := 450;
    Rect.w := 300;
    Rect.h := 45;
    SDL_BlitSurface( DXContinue, nil, MainWindow.DisplaySurface, @Rect );
  end;

  if MouseIsOverSound then
  begin
    Rect.x := ( MainWindow.DisplaySurface.w - DxTextMessage[ 0 ].w ) shr 1;
    Rect.y := 516;
    Rect.w := DxTextMessage[ 0 ].w;
    Rect.h := DxTextMessage[ 0 ].h;
    SDL_BlitSurface( DxTextMessage[ 0 ], nil, MainWindow.DisplaySurface, @Rect );
  end;

  if MouseIsOverMusic then
  begin
    Rect.x := ( MainWindow.DisplaySurface.w - DxTextMessage[ 1 ].w ) shr 1;
    Rect.y := 516;
    Rect.w := DxTextMessage[ 1 ].w;
    Rect.h := DxTextMessage[ 1 ].h;
    SDL_BlitSurface( DxTextMessage[ 1 ], nil, MainWindow.DisplaySurface, @Rect );
  end;

  if MouseIsOverShadows then
  begin
    Rect.x := ( MainWindow.DisplaySurface.w - DxTextMessage[ 2 ].w ) shr 1;
    Rect.y := 516;
    Rect.w := DxTextMessage[ 2 ].w;
    Rect.h := DxTextMessage[ 2 ].h;
    SDL_BlitSurface( DxTextMessage[ 2 ], nil, MainWindow.DisplaySurface, @Rect );
  end;

  if MouseIsOverSpells then
  begin
    {if Character = nil then
    begin
      Rect.x := ( MainWindow.DisplaySurface.w - DxTextMessage[ 3 ].w ) shr 1;
      Rect.y := 516;
      Rect.w := DxTextMessage[ 3 ].w;
      Rect.h := DxTextMessage[ 3 ].h;
      SDL_BlitSurface( DxTextMessage[ 3 ], nil, MainWindow.DisplaySurface, @Rect )
    end
    else}
    begin
      Rect.x := ( MainWindow.DisplaySurface.w - DxTextMessage[ 4 ].w ) shr 1;
      Rect.y := 516;
      Rect.w := DxTextMessage[ 4 ].w;
      Rect.h := DxTextMessage[ 4 ].h;
      SDL_BlitSurface( DxTextMessage[ 4 ], nil, MainWindow.DisplaySurface, @Rect )
    end
  end;
end;

end.
