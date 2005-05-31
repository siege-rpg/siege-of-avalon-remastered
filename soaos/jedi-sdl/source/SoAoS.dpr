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
  Revision 1.9  2005/05/29 00:30:40  savage
  Play Opening movie if it is available

  Revision 1.8  2005/05/25 23:15:34  savage
  Latest Changes

  Revision 1.7  2005/05/24 22:15:02  savage
  Latest additions to determine if it is the first time the game is run.


}
{******************************************************************************}

uses
  {$IFDEF WIN32}
  Windows,
  {$ELSE}
  {$IFDEF UNIX}
    {$IFDEF FPC}
    pthreads,
    baseunix,
    unix,
    x,
    xlib;
    {$ELSE}
    Libc,
    Xlib;
    {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  IniFiles,
  SysUtils,
  sdl in 'sdl\sdl.pas',
  sdlwindow in 'sdl\sdlwindow.pas',
  sdlgameinterface in 'sdl\sdlgameinterface.pas',
  sdltruetypefont in 'sdl\sdltruetypefont.pas',
  sdlticks in 'sdl\sdlticks.pas',
  sdlinput in 'sdl\sdlinput.pas',
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
  SiegeTypes in 'engine\SiegeTypes.pas',
  CustomAniFigure in 'engine\CustomAniFigure.pas',
  ListBoxDialog in 'interface\ListBoxDialog.pas',
  logger in 'sdl\logger.pas',
  sdl_ttf in 'sdl\sdl_ttf.pas',
  sdlaudiomixer in 'sdl\sdlaudiomixer.pas',
  sdl_mixer in 'sdl\sdl_mixer.pas',
  smpeg in 'sdl\smpeg.pas',
  registryuserpreferences in 'sdl\registryuserpreferences.pas',
  userpreferences in 'sdl\userpreferences.pas',
  AniDec30 in 'engine\AniDec30.pas';

{$IFDEF WIN32}
{$R *.res}
{$ENDIF}

procedure PlayBinkMovie( aMoviePath, aSwitches : string );
const
  {$IFDEF WIN32}
  BinkPlayer : string = 'BinkPlay';
  {$ELSE}
  BinkPlayer : string = 'BinkPlayer';
  {$ENDIF}
var
  MovieProcess : string;
{$IFDEF WIN32}
  ProcessInfo: TProcessInformation;
  Startupinfo: TStartupInfo;
  ExitCode: longword;
{$ELSE}
{$IFDEF UNIX}
  pid: PID_T;
  Max: Integer;
  I: Integer;
  parg: PPCharArray;
  argnum: Integer;
  returnvalue : Integer;
  arguments : array[0..1] of string;
{$ENDIF}
{$ENDIF}
begin
  MovieProcess := ExtractFilePath( ParamStr( 0 ) ) + BinkPlayer;
  {$IFDEF WIN32}
  // Initialize the structures
  FillChar(ProcessInfo, sizeof(TProcessInformation), 0);
  FillChar(Startupinfo, sizeof(TStartupInfo), 0);
  Startupinfo.cb := sizeof(TStartupInfo);

  // Attempts to create the process
  Startupinfo.dwFlags := STARTF_USESHOWWINDOW;
  Startupinfo.wShowWindow := 1;
  if CreateProcess( nil, PChar( MovieProcess + ' ' + aMoviePath + ' ' + aSwitches ), nil, nil, False, {CREATE_NEW_CONSOLE or} NORMAL_PRIORITY_CLASS
    , nil, nil, Startupinfo, ProcessInfo ) then
  begin
    // The process has been successfully created
    // No let's wait till it ends...
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);

    // Process has finished. Now we should close it.
    GetExitCodeProcess(ProcessInfo.hProcess, ExitCode);  // Optional
    CloseHandle(ProcessInfo.hThread);
    CloseHandle(ProcessInfo.hProcess);
  end;
  {$ELSE}
  {$IFDEF UNIX}
  arguments[0] := aMoviePath;
  arguments[1] := aSwitches;
  
  pid := fork;

  if pid = 0 then
  begin
    Max := sysconf(_SC_OPEN_MAX);
    for i := (STDERR_FILENO+1) to Max do
    begin
      fcntl(i, F_SETFD, FD_CLOEXEC);
    end;

    argnum := High(arguments) + 1;

    GetMem(parg,(2 + argnum) * sizeof(PChar));
    parg[0] := PChar(MovieProcess);

    i := 0;

    while i <= high(arguments) do
    begin
      inc(i);
      parg[i] := PChar(arguments[i-1]);
    end;

    parg[i+1] := nil;
    execvp(PChar(MovieProcess),PPChar(@parg[0]));
    halt;
  end;

  if pid > 0 then
  begin
    waitpid(pid,@returnvalue,0);
  end;
  {$ENDIF}
  {$ENDIF}
end;


procedure PlayOpeningMovie;
var
  Movie : string;
begin
  Movie := SoASettings.MoviePath + '\' + SoASettings.OpeningMovie;
  if FileExists( Movie )
  and ( bShowIntro ) then
  begin
     if ( SoASettings.FullScreen ) then
       PlayBinkMovie( Movie, SoASettings.MovieSwitches + '/P' )
     else
       PlayBinkMovie( Movie, '/I1' );
  end;
end;

procedure PlayClosingMovie;
var
  Movie : string;
begin
  Movie := SoASettings.MoviePath + '\' + SoASettings.ClosingMovie;
  if FileExists( Movie )
  and ( bShowOuttro ) then
  begin
    if ( SoASettings.FullScreen ) then
      PlayBinkMovie( Movie, SoASettings.MovieSwitches )
    else
      PlayBinkMovie( Movie, '/I1' );
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

  Application := TSDL2DWindow.Create( SoASettings.ScreenWidth, SoASettings.ScreenHeight, SoASettings.ScreenBPP, ScreenFlags );
  try
    Application.SetIcon( nil, 0 );
    Application.ActivateVideoMode;
    Application.SetCaption( 'Siege of Avalon : Open Source Edition', '' );

    // Instantiate to get into our game loop.
    if SoASettings.ShowIntro then
      CurrentGameInterface := TGameIntro
    else
      CurrentGameInterface := TMainMenu;

    while CurrentGameInterface <> nil do
    begin
      GameWindow := CurrentGameInterface.Create( Application );
      GameWindow.LoadSurfaces;

      Application.Show;
      CurrentGameInterface := GameWindow.NextGameInterface;

      if ( GameWindow <> nil ) then
        FreeAndNil( GameWindow );
    end;

    PlayClosingMovie;
  finally
    Application.Free;
  end;
end.
