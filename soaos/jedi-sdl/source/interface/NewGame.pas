unit NewGame;
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
  SiegeInterfaces;

type
  TNewGame = class( TSimpleSoAInterface )
  private
    DXCircle : PSDL_Surface; //circle used for outline
    DXBox : PSDL_Surface;
    DXBlack : PSDL_Surface;
    DXContinue : PSDL_Surface;
    DXCancel : PSDL_Surface;
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
  globals;

{ TNewGame }

procedure TNewGame.FreeSurfaces;
begin
  SDL_FreeSurface( DXCircle ); //circle used for outline
  SDL_FreeSurface( DXBox );
  SDL_FreeSurface( DXBlack );
  SDL_FreeSurface( DXContinue );
  SDL_FreeSurface( DXCancel );
  inherited;
end;

procedure TNewGame.KeyDown( var Key : TSDLKey; Shift : TSDLMod;
  unicode : UInt16 );
begin
  inherited;

end;

procedure TNewGame.LoadSurfaces;
var
  Flags : Cardinal;
begin
  inherited;

  Flags := SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL;

  DXBack := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'CharCreate.bmp' ) );
  SDL_SetColorKey( DXBack, Flags, SDL_MapRGB( DXBack.format, 0, 255, 255 ) );

  DXCircle := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'chaRedOval.bmp' ) );
  SDL_SetColorKey( DXCircle, Flags, SDL_MapRGB( DXCircle.format, 0, 255, 255 ) );

  DXBlack := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'chaBlack.bmp' ) );
  SDL_SetColorKey( DXBlack, Flags, SDL_MapRGB( DXBlack.format, 0, 255, 255 ) );

  DXBox := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'chaChooseBox.bmp' ) );
  SDL_SetColorKey( DXBox, Flags, SDL_MapRGB( DXBox.format, 0, 255, 255 ) );

  DXContinue := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'chaContinue.bmp' ) );
  SDL_SetColorKey( DXContinue, Flags, SDL_MapRGB( DXContinue.format, 0, 255, 255 ) );

  DXCancel := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'chaCancel.bmp' ) );
  SDL_SetColorKey( DXCancel, Flags, SDL_MapRGB( DXCancel.format, 0, 255, 255 ) );

end;

procedure TNewGame.MouseDown( Button : Integer; Shift : TSDLMod;
  CurrentPos : TPoint );
begin
  inherited;

end;

procedure TNewGame.MouseMove( Shift : TSDLMod; CurrentPos,
  RelativePos : TPoint );
begin
  inherited;

end;

procedure TNewGame.Render;
begin
  inherited;

end;

end.
