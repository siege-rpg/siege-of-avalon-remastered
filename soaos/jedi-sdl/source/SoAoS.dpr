program SoAoS;

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
  SaveFile in 'engine\SaveFile.pas';

{$R *.res}

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
  SoAoSGame.SetIcon( SDL_LoadBMP( '' ), 0 );
  SoAoSGame.ActivateVideoMode;
  SoAoSGame.SetCaption( 'Siege of Avalon : Open Source Edition', '' );

  // Instantiate to get into our game loop.
  CurrentGameInterface := TGameIntro;
  
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

  SoAoSGame.Free;
end.
