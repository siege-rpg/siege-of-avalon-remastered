unit globals;

interface

uses
  sdl,
  sdlwindow,
  sdlgameinterface,
  sdltruetypefont,
  SoAPreferences,
  SiegeInterfaces,
  GameIntro,
  Externalizer;

var
  // Global Class variables
  SoASettings : TSoAUserPreferences;
  SoAoSGame : TSDL2DWindow;
  CurrentGameInterface : TGameInterfaceClass = TGameIntro;
  GameWindow :  TGameInterface;
  GameFont :  TTrueTypeFont;
  ExText : TExternalizer;

  // Global type variables 
  bShowIntro, bShowOuttro : Boolean;
  ScreenFlags : UInt32;

implementation

initialization
begin
  SoASettings := TSoAUserPreferences.Create;
  ExText := TExternalizer.create;
  GameFont :=  TTrueTypeFont.Create( 'interface/LBLACK.TTF', [], 18 );
end;

finalization
begin
  SoASettings.Free;
  ExText.Free;
  GameFont.Free;
end;

end.
