unit GameJournal;
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
  SiegeInterfaces,
  AdventureLog;

type
  TGameJournal = class( TSimpleSoAInterface )
  private
    CurrentLogIndex, StartLogIndex : integer;
    JournalLog : TAdventureLog;
    DxTextMessage : array[ 0..1 ] of PSDL_Surface;
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
  {$IFDEF ver120}
  FileCtrl,
  {$ENDIF}
  SysUtils,
  globals,
  GameMainMenu;

{ TGameJournal }

procedure TGameJournal.FreeSurfaces;
var
  i : integer;
begin
  for i := Low( DxTextMessage ) to High( DxTextMessage ) do
    SDL_FreeSurface( DxTextMessage[ i ] );
    
  ExText.Close;
  inherited;
end;

procedure TGameJournal.KeyDown( var Key : TSDLKey; Shift : TSDLMod;
  unicode : UInt16 );
begin
  inherited;

end;

procedure TGameJournal.LoadSurfaces;
var
  Flags : Cardinal;
  i : integer;
begin
  inherited;
  Flags := SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL;

  ExText.Open( 'Journal' );
  for i := 0 to 1 do
  begin
    DxTextMessage[ i ] := GameFont.DrawText( ExText.GetText( 'Message' + inttostr( i ) ) );
    SDL_SetColorKey( DxTextMessage[ i ], Flags, SDL_MapRGB( DxTextMessage[ i ].format, 0, 0, 0 ) );
  end;

  if JournalLog.LogFileList.count - 1 > StartLogIndex then
    inc( StartLogIndex );

  if ( SoASettings.JournalFont = 1 ) and DirectoryExists( SoASettings.ArtPath + 'journalalt/' ) then
    JournalLog.LogDirectory := SoASettings.ArtPath + 'journalalt/'
  else
    JournalLog.LogDirectory := SoASettings.ArtPath + 'journal/';

  CurrentLogIndex := StartLogIndex; //JournalLog.LogFileList.count-1;
  if CurrentLogIndex >= JournalLog.LogFileList.count then
      CurrentLogIndex := JournalLog.LogFileList.count - 1;

  DXBack := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'Journal.bmp' ) );
  SDL_SetColorKey( DXBack, Flags, SDL_MapRGB( DXBack.format, 0, 255, 255 ) );

end;

procedure TGameJournal.MouseDown( Button : Integer; Shift : TSDLMod; CurrentPos : TPoint );
begin
  inherited;
  if PointIsInRect( CurrentPos, 582, 575, 659, 596 ) then
  begin //prev
    if CurrentLogIndex > 0 then
    begin
      CurrentLogIndex := CurrentLogIndex - 1;
    end;
  end
  else if PointIsInRect( CurrentPos, 681, 575, 721, 596 ) then
  begin //next
    if CurrentLogIndex < JournalLog.LogFileList.count - 1 then
    begin
      CurrentLogIndex := CurrentLogIndex + 1;
    end;
  end
  else if PointIsInRect( CurrentPos, 746, 575, 786, 596 ) then
  begin //exit
    NextGameInterface := TMainMenu;
    MainWindow.Rendering := false;
  end;
end;

procedure TGameJournal.MouseMove( Shift : TSDLMod; CurrentPos,
  RelativePos : TPoint );
begin
  inherited;

end;

procedure TGameJournal.Render;
begin
  inherited;

end;

end.
