program SoAoS;
{******************************************************************************}
{
  $Id$

}
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

uses
  IniFiles,
  SysUtils,
  sdl,
  sdlwindow,
  sdlgameinterface,
  SiegeInterfaces in 'interface\SiegeInterfaces.pas',
  globals in 'engine\globals.pas',
  SoAPreferences in 'engine\SoAPreferences.pas',
  Externalizer in 'interface\Externalizer.pas',
  AdventureLog in 'engine\AdventureLog.pas',
  GameIntro in 'interface\GameIntro.pas',
  GameMainMenu in 'interface\GameMainMenu.pas',
  NewGame in 'interface\NewGame.pas',
  LoadSaveGame in 'interface\LoadSaveGame.pas',
  GameOptions in 'interface\GameOptions.pas',
  GameJournal in 'interface\GameJournal.pas',
  GameCredits in 'interface\GameCredits.pas',
  YesNoDialog in 'interface\YesNoDialog.pas',
  SaveFile in 'engine\SaveFile.pas',
  AStar in 'ai\AStar.pas',
  DXEffects in 'graphics\DXEffects.pas',
  SiegeTypes in 'engine\SiegeTypes.pas',
  CustomAniFigure in 'engine\CustomAniFigure.pas',
  ListBoxDialog in 'interface\ListBoxDialog.pas';

{$IFDEF WIN32}
{$R *.res}
{$ENDIF}

procedure PlayOpeningMovie;
begin
  if FileExists( SoASettings.OpeningMovie )
  and ( bShowIntro ) then
  begin

  end;
end;

procedure PlayClosingMovie;
begin
  if FileExists( SoASettings.ClosingMovie )
  and ( bShowOuttro ) then
  begin

  end;
end;

begin
  if ( SoASettings.FullScreen ) then
  begin
    ScreenFlags := SDL_DOUBLEBUF or SDL_SWSURFACE or SDL_FULLSCREEN;
  end
  else
  begin
    ScreenFlags := SDL_DOUBLEBUF or SDL_SWSURFACE;
  end;

  PlayOpeningMovie;
  bShowOuttro := False; // Game must force to true to show closing movie

  SoAoSGame := TSDL2DWindow.Create( SoASettings.ScreenWidth, SoASettings.ScreenHeight, SoASettings.ScreenBPP, ScreenFlags );
  try
    SoAoSGame.SetIcon( SDL_LoadBMP( '' ), 0 );
    SoAoSGame.ActivateVideoMode;
    SoAoSGame.SetCaption( 'Siege of Avalon : Open Source Edition', '' );

    // Instantiate to get into our game loop.
    if SoASettings.ShowIntro then
      CurrentGameInterface := TGameIntro
    else
      CurrentGameInterface := TMainMenu;

    while CurrentGameInterface <> nil do
    begin
      GameWindow := CurrentGameInterface.Create( SoAoSGame );
      GameWindow.LoadSurfaces;

      SoAoSGame.Show;
      CurrentGameInterface := GameWindow.NextGameInterface;

      if ( GameWindow <> nil ) then
        FreeAndNil( GameWindow );
    end;

    PlayClosingMovie;
  finally
    SoAoSGame.Free;
  end;
end.
