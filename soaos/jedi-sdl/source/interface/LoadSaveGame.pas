unit LoadSaveGame;
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
  Classes,
  sdl,
  SiegeInterfaces;

type
  PSelectableRect = ^TSelectableRect;
  TSelectableRect = record
    rect : TSDL_Rect;
    time : integer;
    text : string;
    date : string;
    CharacterGif : string;
    MapName : string;
    CharacterName : array[ 0..4 ] of string;
    TextSurface : PSDL_Surface;
    DateSurface : PSDL_Surface;
    ScreenShotSurface : PSDL_Surface;
    MapSurface : PSDL_Surface;
    CharacterSurface : array[ 0..4 ] of PSDL_Surface;
  end;

  TVisibleDialog = ( vdNone, vdDelete, vdOverWrite, vdEnterName );
  TLoadSaveMouseOver = ( moNothing, moCancelButton, moLoadSaveButton );

  TLoadSaveGame = class( TSimpleSoAInterface )
  private
    DXBackHighlight : PSDL_Surface; //so we know which file is selected for loading
    DXLoadLight : PSDL_Surface;
    DXLoadDark : PSDL_Surface;
    DXLoadSaveUpper : PSDL_Surface;
    DXCancel : PSDL_Surface;
    DXok : PSDL_Surface;
    TextMessage : array[ 0..2 ] of string;
    SelectRect : TList; //collision rects for selectable text
    PTextItem : PSelectableRect;
    CurrentSelectedListItem : integer;
    ScrollState : integer;
    VisibleDialog : TVisibleDialog;
    StartFile : integer; //the first file to display
    LoadSaveRect : TSDL_Rect;
    CancelRect : TSDL_Rect;
    ScreenShotRect : TSDL_Rect;
    LoadSaveUpperRect : TSDL_Rect;
    SelectionRect : TSDL_Rect;
    MapRect : TSDL_Rect;
    CharacterRect : TSDL_Rect;
    MouseIsOver : TLoadSaveMouseOver;
    procedure LoadText; virtual;
    function LoadGameInfo( aGameName : string; var aMapName : string; var aCharacterGif : string; var aCharacterName : array of string ) : boolean;
    procedure DrawSaveGames;
    procedure DeleteSelectedFile;
    procedure DeleteSelectableRectItem( anItem : integer );
  public
    LoadThisFile : string; //This is the file to Save To or to Load From right here!
    LastSavedFile : string; //The caller loads this string so we know what the last file saved to/Loaded from is.
    procedure Render; override;
    procedure FreeSurfaces; override;
    procedure LoadSurfaces; override;
    procedure MouseDown( Button : Integer; Shift : TSDLMod; CurrentPos : TPoint ); override;
  end;

  TLoadGame = class( TLoadSaveGame )
  public
    procedure LoadSurfaces; override;
    procedure Render; override;
    procedure MouseDown( Button : Integer; Shift : TSDLMod; CurrentPos : TPoint ); override;
    procedure MouseMove( Shift : TSDLMod; CurrentPos : TPoint; RelativePos : TPoint ); override;
    procedure KeyDown( var Key : TSDLKey; Shift : TSDLMod; unicode : UInt16 ); override;
  end;

  TSaveGame = class( TLoadSaveGame )
  private
    SavedFileName : string; //characters name
    DXCaret : PSDL_Surface;
    procedure LoadText; override;
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
  GameMainMenu,
  sdlgameinterface,
  YesNoDialog,
  SaveFile;

{ TLoadSaveGame }

procedure TLoadSaveGame.FreeSurfaces;
var
  i : integer;
begin
  SDL_FreeSurface( DXBackHighlight );
  SDL_FreeSurface( DXLoadLight );
  SDL_FreeSurface( DXLoadDark );
  SDL_FreeSurface( DXLoadSaveUpper );
  SDL_FreeSurface( DXCancel );
  SDL_FreeSurface( DXok );


  for i := 0 to SelectRect.Count - 1 do
  begin
    DeleteSelectableRectItem( i );
  end;

  SelectRect.Free;

  ExText.Close;
  inherited;
end;

function TLoadSaveGame.LoadGameInfo( aGameName : string; var aMapName : string; var aCharacterGif : string; var aCharacterName : array of string ) : boolean;
var
  List : TStringList;
  S : string;
  Stream : TFileStream;
  EOB, BB : word;
  P, L : LongWord;
  Block : TSavBlocks;
  Filename : string;
  FoundCharacters : boolean;
  CharacterCount : integer;
  TravelBlock : string;
  SceneName : string;
begin
  result := false;
  EOB := EOBMarker;
  CharacterCount := 0;
  TravelBlock := '';
  FoundCharacters := false;

  Filename := ExtractFilePath( ParamStr( 0 ) ) + 'games/' + aGameName + '.idx';
  if not FileExists( Filename ) then
    Filename := ExtractFilePath( ParamStr( 0 ) ) + 'games/' + aGameName + '.sav';
    //Level:=lowercase(ChangeFileExt(ExtractFilename(LVLFile),''));
    //Scene:=CurrentScene;
  Stream := TFileStream.Create( Filename, fmOpenRead or fmShareDenyWrite );
  try
    List := TStringList.create;
    try
      while Stream.Position < Stream.Size do
      begin
        Stream.Read( Block, sizeof( Block ) );
        Stream.Read( L, sizeof( L ) );
        P := Stream.Position;
        case Block of
          sbMap :
            begin
              SetLength( S, L );
              Stream.Read( S[ 1 ], L );
              List.Text := S;
              aMapName := List.Values[ 'Map' ];
              SceneName := List.Values[ 'Scene' ];
            end;

          sbTravel :
            begin
              SetLength( TravelBlock, L );
              Stream.Read( TravelBlock[ 1 ], L );
            end;

          sbCharacter :
            begin
                //Log.Log('  Loading character block');
              SetLength( S, L );
              Stream.Read( S[ 1 ], L );
              List.Text := S;
              inc( CharacterCount );
              aCharacterName[ CharacterCount ] := List.Values[ 'CharacterName' ];
              aCharacterGif := List.Values[ 'Resource' ];
              FoundCharacters := true;
            end;

          sbItem :
            begin
            end;
        else
          begin
            if FoundCharacters then
              break;
          end;
        end;
        Stream.Seek( P + L, soFromBeginning );
        Stream.Read( BB, sizeof( BB ) );
        if BB <> EOB then
        begin
            //Log.Log('*** Error:  EOB not found');
          exit;
        end;
      end;
    finally
      List.free;
    end;
  finally
    Stream.free;
  end;

  result := true;
end;

procedure TLoadSaveGame.LoadSurfaces;
var
  Flags : Cardinal;
  i : integer;
begin
  inherited;
  Flags := SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL;

  ExText.Open( 'LoadGame' );
  for i := 0 to 2 do
  begin
    TextMessage[ i ] := ExText.GetText( 'Message' + inttostr( i ) );
  end;

  SelectRect := TList.create;

  VisibleDialog := vdNone;

  StartFile := 0;

  LoadText;

  DXBack := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'ldLoadSave.bmp' ) );
  SDL_SetColorKey( DXBack, Flags, SDL_MapRGB( DXBack.format, 0, 255, 255 ) );

  DXBackHighlight := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'opYellow.bmp' ) );
  SDL_SetColorKey( DXBackHighlight, Flags, SDL_MapRGB( DXBackHighlight.format, 0, 255, 255 ) );

  DXCancel := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'ldCancel.bmp' ) );
  SDL_SetColorKey( DXCancel, Flags, SDL_MapRGB( DXCancel.format, 0, 255, 255 ) );

  DXok := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'ldOk.bmp' ) );
  SDL_SetColorKey( DXok, Flags, SDL_MapRGB( DXok.format, 0, 255, 255 ) );



  // Set rectangles
  LoadSaveRect.x := 401;
  LoadSaveRect.y := 450;
  LoadSaveRect.w := 300;
  LoadSaveRect.h := 45;

  CancelRect.x := 101;
  CancelRect.y := 450;
  CancelRect.w := 300;
  CancelRect.h := 45;

  ScreenShotRect.x := 114;
  ScreenShotRect.y := 257;
  ScreenShotRect.w := 230;
  ScreenShotRect.h := 166;

  LoadSaveUpperRect.x := 94;
  LoadSaveUpperRect.y := 19;
  LoadSaveUpperRect.w := 357;
  LoadSaveUpperRect.h := 64;

  SelectionRect.x := 371;
  SelectionRect.y := 62;
  SelectionRect.w := 296;
  SelectionRect.h := 30;

  MapRect.x := 123;
  MapRect.y := 70;
  MapRect.w := 240;
  MapRect.h := 70;

  CharacterRect.x := 133;
  CharacterRect.y := 100;
  CharacterRect.w := 240;
  CharacterRect.h := 70;
end;

procedure TLoadSaveGame.LoadText;
var
  FileData : TSearchRec;
  FileNotFound : integer;
  SaveGameName : array[ 0..30 ] of Char;
  i, j : integer;
  fDay, fYear, fMonth : word;
  fHour, fMin, fSec, fMsec : word;
  pTempItem : pointer;
  AppPath : string;
  C : TSDL_Color;
begin
  C.r := 231;
  C.g := 156;
  C.b := 0;
  GameFont.ForeGroundColour := C;
  C.r := 0;
  C.g := 0;
  C.b := 0;
  GameFont.BackGroundColour := C;

  AppPath := ExtractFilePath( ParamStr( 0 ) );

  //Search for the first file meeting our criteria - create a Find file structure, and assign it a handle
  FileNotFound := FindFirst( AppPath + 'games/*.sav', faAnyFile, FileData );
  while FileNotFound = 0 do
  begin

    //get the filename without .sav on it
    StrLCopy( SaveGameName, PChar( FileData.Name ), Length( FileData.Name ) - 4 );
    if ExtractFilename( SaveGameName )[ 1 ] <> '~' then
    begin
      new( pTextItem );
      pTextItem.text := SaveGameName;
      //Get the last time this file was accessed
      pTextitem.time := FileAge( AppPath + 'games/' + FileData.Name );
      DecodeDate( FileDateToDateTime( pTextitem.time ), fYear, fMonth, fDay );
      DecodeTime( FileDateToDateTime( pTextitem.time ), fHour, fMin, fSec, fMsec );
      if fMin > 10 then
        pTextItem.Date := intToStr( fMonth ) + '/' + intToStr( fDay ) + '  ' + intToStr( fHour ) + ':' + intToStr( fMin ) //'/'+intToStr(fYear);
      else
        pTextItem.Date := intToStr( fMonth ) + '/' + intToStr( fDay ) + '  ' + intToStr( fHour ) + ':0' + intToStr( fMin ); //'/'+intToStr(fYear);
      GameFont.FontSize := 16;
      pTextItem.TextSurface := GameFont.DrawText( pTextItem.text );
      SDL_SetColorKey( pTextItem.TextSurface, SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL, SDL_MapRGB( pTextItem.TextSurface.format, 0, 0, 0 ) );
      GameFont.FontSize := 14;
      pTextItem.DateSurface := GameFont.DrawText( pTextItem.date );
      SDL_SetColorKey( pTextItem.DateSurface, SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL, SDL_MapRGB( pTextItem.DateSurface.format, 0, 0, 0 ) );
      pTextItem.ScreenShotSurface := SDL_LoadBMP( PChar( AppPath + 'games/' + SaveGameName + '.bmp' ) );
      SDL_SetColorKey( pTextItem.ScreenShotSurface, SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL, SDL_MapRGB( pTextItem.ScreenShotSurface.format, 0, 0, 0 ) );

      LoadGameInfo( pTextItem.Text, pTextItem.MapName, pTextItem.CharacterGif,  pTextItem.CharacterName );
      GameFont.FontSize := 18;

      pTextItem.MapSurface := GameFont.DrawText( pTextItem.MapName );
      SDL_SetColorKey( pTextItem.MapSurface, SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL, SDL_MapRGB( pTextItem.MapSurface.format, 0, 0, 0 ) );

      for i := Low( pTextItem.CharacterName ) to High( pTextItem.CharacterName ) do
      begin
        if pTextItem.CharacterName[i] <> '' then
        begin
          pTextItem.CharacterSurface[i] := GameFont.DrawText( pTextItem.CharacterName[i] );
          SDL_SetColorKey( pTextItem.CharacterSurface[i], SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL, SDL_MapRGB( pTextItem.CharacterSurface[i].format, 0, 0, 0 ) );
        end;
      end;

      SelectRect.add( pTextItem );
    end;
    //get the next file using the handle to the search structure - nonzero on failure to find file
    FileNotFound := FindNext( FileData );

  end;

   //Close the search handle, free the memory
  FindClose( FileData );

   //Sort by the time
  for i := 0 to SelectRect.count - 2 do
  begin
    for j := ( i + 1 ) to SelectRect.count - 1 do
    begin
      if ( ( PSelectableRect( SelectRect.items[ j ] ).time > PSelectableRect( SelectRect.items[ i ] ).time )
        and ( ( lowercase( trim( PSelectableRect( SelectRect.items[ i ] ).text ) ) <> lowercase( trim( LastSavedFile ) ) )
        or ( trim( LastSavedFile ) = '' ) ) )
        or ( ( lowercase( trim( LastSavedFile ) ) = lowercase( trim( PSelectableRect( SelectRect.items[ j ] ).text ) ) )
        and ( trim( LastSavedFile ) <> '' ) ) then
      begin
        pTempItem := SelectRect.items[ j ];
        SelectRect.items[ j ] := SelectRect.items[ i ];
        SelectRect.items[ i ] := pTempItem;
      end;
    end;
  end;
end;

procedure TLoadSaveGame.DrawSaveGames;
var
  i, j : integer;
begin
  j := 0;
  for i := 0 to SelectRect.count - 1 do
  begin
    if ( i >= StartFile ) and ( i < StartFile + 9 ) then
    begin //only show 9 files
      PSelectableRect( SelectRect.items[ i ] ).rect.x := 385;
      PSelectableRect( SelectRect.items[ i ] ).rect.y := 66 + j * 35;
      PSelectableRect( SelectRect.items[ i ] ).rect.w := 669 - PSelectableRect( SelectRect.items[ i ] ).rect.x;
      PSelectableRect( SelectRect.items[ i ] ).rect.h := ( 66 + j * 35 + 35 ) - PSelectableRect( SelectRect.items[ i ] ).rect.y;
      SDL_BlitSurface( PSelectableRect( SelectRect.items[ i ] ).TextSurface, nil, MainWindow.DisplaySurface, @PSelectableRect( SelectRect.items[ i ] ).rect );
      PSelectableRect( SelectRect.items[ i ] ).rect.x := 385 + 210;
      SDL_BlitSurface( PSelectableRect( SelectRect.items[ i ] ).DateSurface, nil, MainWindow.DisplaySurface, @PSelectableRect( SelectRect.items[ i ] ).rect );
      PSelectableRect( SelectRect.items[ i ] ).rect.x := 385;
      inc( j );
    end
    else
    begin //not on screen, set coll rect offscreen
      PSelectableRect( SelectRect.items[ i ] ).rect.x := -100;
      PSelectableRect( SelectRect.items[ i ] ).rect.y := -100;
      PSelectableRect( SelectRect.items[ i ] ).rect.w := 0;
      PSelectableRect( SelectRect.items[ i ] ).rect.h := 0;
    end;
  end; //end for
end;

procedure TLoadSaveGame.Render;
var
  i : integer;
begin
  inherited;
  DrawSaveGames;

  SDL_BlitSurface( DXLoadDark, nil, MainWindow.DisplaySurface, @LoadSaveRect );
  case MouseIsOver of
    moCancelButton :
      begin
        SDL_BlitSurface( DXCancel, nil, MainWindow.DisplaySurface, @CancelRect );
      end;

    moLoadSaveButton :
      begin
        SDL_BlitSurface( DXLoadLight, nil, MainWindow.DisplaySurface, @LoadSaveRect );
      end
  end;

  if CurrentSelectedListItem > -1 then
  begin
    SelectionRect.x := PSelectableRect( SelectRect.items[ CurrentSelectedListItem ] ).rect.x;
    SelectionRect.y := PSelectableRect( SelectRect.items[ CurrentSelectedListItem ] ).rect.y;

    SDL_SetAlpha( DXBackHighlight, SDL_RLEACCEL or SDL_SRCALPHA, 64 );
    SDL_BlitSurface( DXBackHighlight, nil, MainWindow.DisplaySurface, @SelectionRect );

    SDL_BlitSurface( PSelectableRect( SelectRect.items[ CurrentSelectedListItem ] ).ScreenShotSurface, nil, MainWindow.DisplaySurface, @ScreenShotRect );

    SDL_BlitSurface( PSelectableRect( SelectRect.items[ CurrentSelectedListItem ] ).MapSurface, nil, MainWindow.DisplaySurface, @MapRect );

    CharacterRect.y := 100;
    for i := Low( pTextItem.CharacterName ) to High( pTextItem.CharacterName ) do
    begin
      if pTextItem.CharacterName[ i ] <> '' then
      begin
        SDL_BlitSurface( PSelectableRect( SelectRect.items[ CurrentSelectedListItem ] ).CharacterSurface[i], nil, MainWindow.DisplaySurface, @CharacterRect );
        inc( CharacterRect.y, 80 );
      end;
    end;
  end;

  SDL_BlitSurface( DXLoadSaveUpper, nil, MainWindow.DisplaySurface, @LoadSaveUpperRect );
end;

procedure TLoadSaveGame.MouseDown( Button : Integer; Shift : TSDLMod; CurrentPos : TPoint );
var
  i : integer;
begin
  inherited;

  for i := 0 to SelectRect.count - 1 do
  begin
    if ( i >= StartFile ) and ( i < StartFile + 10 ) then
    begin
      if PointIsInRect( CurrentPos, PSelectableRect( SelectRect.items[ i ] ).rect.x,
        PSelectableRect( SelectRect.items[ i ] ).rect.y,
        PSelectableRect( SelectRect.items[ i ] ).rect.x + PSelectableRect( SelectRect.items[ i ] ).rect.w,
        PSelectableRect( SelectRect.items[ i ] ).rect.y + PSelectableRect( SelectRect.items[ i ] ).rect.h ) then
      begin
        if i <> CurrentSelectedListItem then
        begin
          CurrentSelectedListItem := i;

        end; //endif i <> CurrentSelectedListItem NEW July 8 2000
      end;
    end;
  end; //end for

  //check for scroll arrows
  if PointIsInRect( CurrentPos, 673, 203, 694, 218 ) then
  begin //up arrow
    if StartFile > 0 then
    begin
      dec( StartFile );
      ScrollState := -3;
    end;
  end
  else if PointIsInRect( CurrentPos, 673, 234, 694, 250 ) then
  begin //down arrow
    if StartFile + 8 < SelectRect.count - 1 then
    begin
      inc( StartFile );
      ScrollState := 3;
      if CurrentSelectedListItem > StartFile then
        CurrentSelectedListItem := StartFile;
    end;
  end //endif arrows
  else if PointIsInRect( CurrentPos, 369, 400, 492, 428 ) then
  begin //delete
    if ( CurrentSelectedListItem > -1 ) then
    begin
      if trim( PSelectableRect( SelectRect.items[ CurrentSelectedListItem ] ).Text ) <> '' then
      begin
        DeleteSelectedFile;
      end;
    end;
  end
  else
    ScrollState := 0;
end;

procedure TLoadSaveGame.DeleteSelectedFile;
var
  YesNo : TYesNoDialog;
  aCharacter : string;
begin
  YesNo := TYesNoDialog.Create( SoAoSGame );
  try
    YesNo.QuestionText := TextMessage[ 0 ];
    YesNo.LoadSurfaces;
    SoAoSGame.Show;
    if YesNo.DialogResult = drYes then
    begin
      DeleteFile( PChar( ExtractFilePath( ParamStr( 0 ) ) + 'games/' + PSelectableRect( SelectRect.items[ CurrentSelectedListItem ] ).text + '.sav' ) );
      if FileExists( ExtractFilePath( ParamStr( 0 ) ) + 'games/' + PSelectableRect( SelectRect.items[ CurrentSelectedListItem ] ).text + '.bmp' ) then
        DeleteFile( PChar( ExtractFilePath( ParamStr( 0 ) ) + 'games/' + PSelectableRect( SelectRect.items[ CurrentSelectedListItem ] ).text + '.bmp' ) );
      try
        if FileExists( ExtractFilePath( ParamStr( 0 ) ) + 'games/' + PSelectableRect( SelectRect.items[ CurrentSelectedListItem ] ).text + '.idx' ) then
          DeleteFile( PChar( ExtractFilePath( ParamStr( 0 ) ) + 'games/' + PSelectableRect( SelectRect.items[ CurrentSelectedListItem ] ).text + '.idx' ) );
      except
      end;
      try
        if FileExists( ExtractFilePath( ParamStr( 0 ) ) + 'games/' + PSelectableRect( SelectRect.items[ CurrentSelectedListItem ] ).text + '.map' ) then
          DeleteFile( PChar( ExtractFilePath( ParamStr( 0 ) ) + 'games/' + PSelectableRect( SelectRect.items[ CurrentSelectedListItem ] ).text + '.map' ) );
      except
      end;
      aCharacter := ChangeFileExt( SoASettings.ArtPath + '/' + PSelectableRect( SelectRect.items[ CurrentSelectedListItem ] ).CharacterGif, '.pox' );
          //if FileExists(a) then
             //DeleteFile(PChar(a)); -> This is OUT in a June 11 modification
      DeleteSelectableRectItem( CurrentSelectedListItem );
      SelectRect.Delete( CurrentSelectedListItem );
      if CurrentSelectedListItem > ( SelectRect.Count - 1 ) then
        CurrentSelectedListItem := ( SelectRect.Count - 1 );
    end;
  finally
    YesNo.Free;
  end;
  ResetInputManager;
  MainWindow.Rendering := true;
end;

procedure TLoadSaveGame.DeleteSelectableRectItem(anItem: integer);
var
  j : integer;
begin
  if PSelectableRect( SelectRect[ anItem ] ).TextSurface <> nil then
    SDL_FreeSurface( PSelectableRect( SelectRect[ anItem ] ).TextSurface );
  if PSelectableRect( SelectRect[ anItem ] ).DateSurface <> nil then
    SDL_FreeSurface( PSelectableRect( SelectRect[ anItem ] ).DateSurface );
  if PSelectableRect( SelectRect[ anItem ] ).ScreenShotSurface <> nil then
    SDL_FreeSurface( PSelectableRect( SelectRect[ anItem ] ).ScreenShotSurface );
  if PSelectableRect( SelectRect[ anItem ] ).MapSurface <> nil then
  SDL_FreeSurface( PSelectableRect( SelectRect[ anItem ] ).MapSurface );
  for j := Low( PSelectableRect( SelectRect[ anItem ] ).CharacterSurface ) to High( PSelectableRect( SelectRect[ anItem ] ).CharacterSurface ) do
    if PSelectableRect( SelectRect[ anItem ] ).CharacterName[ j ] <> '' then
      SDL_FreeSurface( PSelectableRect( SelectRect[ anItem ] ).CharacterSurface[ j ] );
  Dispose( PSelectableRect( SelectRect[ anItem ] ) );
end;

{ TLoadGame }

procedure TLoadGame.KeyDown( var Key : TSDLKey; Shift : TSDLMod; unicode : UInt16 );
begin
  inherited;
  MainWindow.Rendering := false;
end;

procedure TLoadGame.LoadSurfaces;
var
  Flags : Cardinal;
begin
  inherited;
  Flags := SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL;

  DXLoadLight := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + SoASettings.LanguagePath + '/' + 'ldLoadLight.bmp' ) );
  SDL_SetColorKey( DXLoadLight, Flags, SDL_MapRGB( DXLoadLight.format, 0, 255, 255 ) );

  DXLoadDark := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + SoASettings.LanguagePath + '/' + 'ldLoadDark.bmp' ) );
  SDL_SetColorKey( DXLoadDark, Flags, SDL_MapRGB( DXLoadDark.format, 0, 255, 255 ) );

  DXLoadSaveUpper := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + SoASettings.LanguagePath + '/' + 'ldLoadUpper.bmp' ) );
  SDL_SetColorKey( DXLoadSaveUpper, Flags, SDL_MapRGB( DXLoadSaveUpper.format, 0, 255, 255 ) );

  if SelectRect.Count > 0 then
    CurrentSelectedListItem := 0;

  NextGameInterface := TMainMenu; // TODO : Change this to something more appropriate
end;

procedure TLoadGame.MouseDown( Button : Integer; Shift : TSDLMod; CurrentPos : TPoint );
begin
  inherited;
  if PointIsInRect( CurrentPos, CancelRect.x, CancelRect.y, CancelRect.x + CancelRect.w, CancelRect.y + CancelRect.h ) then
  begin
    MainWindow.Rendering := false;
  end
  else if PointIsInRect( CurrentPos, LoadSaveRect.x, LoadSaveRect.y, LoadSaveRect.x + LoadSaveRect.w, LoadSaveRect.y + LoadSaveRect.h ) then
  begin
    // Load the game
  end;
end;

procedure TLoadGame.MouseMove( Shift : TSDLMod; CurrentPos, RelativePos : TPoint );
begin
  inherited;
  MouseIsOver := moNothing;
  if PointIsInRect( CurrentPos, CancelRect.x, CancelRect.y, CancelRect.x + CancelRect.w, CancelRect.y + CancelRect.h ) then
  begin
    MouseIsOver := moCancelButton;
  end
  else if PointIsInRect( CurrentPos, LoadSaveRect.x, LoadSaveRect.y, LoadSaveRect.x + LoadSaveRect.w, LoadSaveRect.y + LoadSaveRect.h ) then
  begin
    MouseIsOver := moLoadSaveButton;
  end;
end;

procedure TLoadGame.Render;
begin
  inherited;

end;

{ TSaveGame }

procedure TSaveGame.FreeSurfaces;
begin
  SDL_FreeSurface( DXCaret );
  inherited;
end;

procedure TSaveGame.KeyDown( var Key : TSDLKey; Shift : TSDLMod;
  unicode : UInt16 );
begin
  inherited;
  MainWindow.Rendering := false;
end;

procedure TSaveGame.LoadSurfaces;
var
  Flags : Cardinal;
begin
  inherited;
  Flags := SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL;

  DXLoadLight := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'ldSaveLight.bmp' ) );
  SDL_SetColorKey( DXLoadLight, Flags, SDL_MapRGB( DXLoadLight.format, 0, 255, 255 ) );

  DXLoadDark := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'ldSaveDark.bmp' ) );
  SDL_SetColorKey( DXLoadDark, Flags, SDL_MapRGB( DXLoadDark.format, 0, 255, 255 ) );

  DXLoadSaveUpper := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + SoASettings.LanguagePath + '/' + 'ldSaveUpper.bmp' ) );
  SDL_SetColorKey( DXLoadSaveUpper, Flags, SDL_MapRGB( DXLoadSaveUpper.format, 0, 255, 255 ) );

  // Create the Caret Surface
  DXCaret := GameFont.DrawText( '|' );
  SDL_SetColorKey( DXCaret, SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL, SDL_MapRGB( DXCaret.format, 0, 0, 0 ) );

  if SelectRect.Count > 0 then
    CurrentSelectedListItem := 1;

  SavedFileName := PSelectableRect( SelectRect.items[ 0 ] ).Text;

  NextGameInterface := TMainMenu; // TODO : Change this to something more appropriate
end;

procedure TSaveGame.LoadText;
begin
  inherited;
  new( pTextItem );
  pTextItem.text := '<empty save slot>';
  pTextItem.Date := '00/00  00:00';
  pTextItem.TextSurface := GameFont.DrawText( pTextItem.text );
  SDL_SetColorKey( pTextItem.TextSurface, SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL, SDL_MapRGB( pTextItem.TextSurface.format, 0, 0, 0 ) );
  pTextItem.DateSurface := GameFont.DrawText( pTextItem.date );
  SDL_SetColorKey( pTextItem.DateSurface, SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL, SDL_MapRGB( pTextItem.DateSurface.format, 0, 0, 0 ) );
  pTextItem.ScreenShotSurface := GameFont.DrawText( 'No Screenshot Available' );
  SDL_SetColorKey( pTextItem.ScreenShotSurface, SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL, SDL_MapRGB( pTextItem.ScreenShotSurface.format, 0, 0, 0 ) );
  pTextItem.MapSurface := nil;
  SelectRect.add( pTextItem );
  if trim( LastSavedFile ) = '' then
  begin //there is no last saved game, so slap a blank box at top
    SelectRect.Move( SelectRect.count - 1, 0 );
  end;
end;

procedure TSaveGame.MouseDown( Button : Integer; Shift : TSDLMod;
  CurrentPos : TPoint );
begin
  inherited;
  if PointIsInRect( CurrentPos, CancelRect.x, CancelRect.y, CancelRect.x + CancelRect.w, CancelRect.y + CancelRect.h ) then
  begin
    MainWindow.Rendering := false;
  end
  else if PointIsInRect( CurrentPos, LoadSaveRect.x, LoadSaveRect.y, LoadSaveRect.x + LoadSaveRect.w, LoadSaveRect.y + LoadSaveRect.h ) then
  begin
    // Save the game
  end;
end;

procedure TSaveGame.MouseMove( Shift : TSDLMod; CurrentPos,
  RelativePos : TPoint );
begin
  inherited;
  MouseIsOver := moNothing;
  if PointIsInRect( CurrentPos, CancelRect.x, CancelRect.y, CancelRect.x + CancelRect.w, CancelRect.y + CancelRect.h ) then
  begin
    MouseIsOver := moCancelButton;
  end
  else if PointIsInRect( CurrentPos, LoadSaveRect.x, LoadSaveRect.y, LoadSaveRect.x + LoadSaveRect.w, LoadSaveRect.y + LoadSaveRect.h ) then
  begin
    MouseIsOver := moLoadSaveButton;
  end;
end;

procedure TSaveGame.Render;
begin
  inherited;
  //SDL_BlitSurface( DXLoadDark, nil, MainWindow.DisplaySurface, @LoadSaveRect );
end;

end.
