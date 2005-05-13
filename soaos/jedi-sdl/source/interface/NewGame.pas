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
  Revision 1.6  2005/05/13 12:33:15  savage
  Various Changes and bug fixes. Main work on the NewGame screen.

  Revision 1.5  2005/05/08 14:43:59  savage
  Added Exception Logging

  Revision 1.4  2005/05/06 08:18:54  savage
  ListBoxDialog used in New GUI

  Revision 1.2  2004/10/17 18:38:06  savage
  Initial changes to stop it crashing on exit.

  Revision 1.1  2004/09/30 22:49:20  savage
  Initial Game Interface units.


}
{******************************************************************************}

interface

uses
  sdl,
  SiegeInterfaces,
  SiegeTypes{,
  Character};

type
  TMouseOverNewOptions = (
    moNone,
    moContinue,
    moCancel,
    moAppearance,
    moShirtColour,
    moPantsColour,
    moHairColour,
    moHairStyle,
    moBeard,
    moName,
    moTrainingStyle,
    moTrainingPoints,
    moStrengthMinus,
    moCoordinationMinus,
    moConstitutionMinus,
    moPerceptionMinus,
    moCharmMinus,
    moMysticismMinus,
    moCombatMinus,
    moStealthMinus,
    moStrengthPlus,
    moCoordinationPlus,
    moConstitutionPlus,
    moPerceptionPlus,
    moCharmPlus,
    moMysticismPlus,
    moCombatPlus,
    moStealthPlus,
    moStrength,
    moCoordination,
    moConstitution,
    moPerception,
    moCharm,
    moMysticism,
    moCombat,
    moStealth,
    moLeftArrow,
    moRightArrow );

  TInformationRect = record
    FRect : TSDL_Rect;
    FInfo : PSDL_Surface;
  end;

  TSelectableRect = record
    FRect : TSDL_Rect;
    FInfo : PSDL_Surface;
    FText : PSDL_Surface;
  end;

  TCharacter = class
  public
    BaseStrength : Integer;
    BaseCoordination : Integer;
    BaseConstitution : Integer;
    BaseMysticism : Integer;
    BaseCombat : Integer;
    BaseStealth : Integer;
    BaseMovement : Single;
    BasePerception : Integer;
    BaseCharm : Integer;
    BaseHealingRate : Integer;
    BaseRechargeRate : Integer;
    BaseHitPoints : Single;
    BaseMana : Single;
    BaseAttackRecovery : Integer;
    BaseAttackBonus : Single;
    BaseDefense : Single;
    BaseHitRecovery : integer;
    Damage : TDamageProfile;
    Resistance : TDamageResistanceProfile;
    TrainingPoints : Integer;
  end;

  TNewGame = class( TSimpleSoAInterface )
  private
    DXCircle : PSDL_Surface; //circle used for outline
    DXBox : PSDL_Surface;
    DXBlack : PSDL_Surface;
    DXContinue : PSDL_Surface;
    DXCancel : PSDL_Surface;
    DXLeftArrow, DXRightArrow : PSDL_Surface;
    TextMessage : array[ 0..104 ] of string;
    ContinueRect, CancelRect, LeftArrowRect, RightArrowRect : TSDL_Rect;
    InfoPanel : TSDL_Rect;
    MouseOverOptions : TMouseOverNewOptions;
    InfoRect : array[ 0..17 ] of TInformationRect; //was 35  //collision rects for information
    ArrowRect : array[ 0..15 ] of TInformationRect; //collision rects for arrows
    StatAdjustments : array[ 0..7 ] of integer; //used to see if we've added points to a stat or not
    StatName : array[ 0..1, 0..11 ] of string;
    SelectRect : array[ 0..20 ] of TSelectableRect; //collision rects for selectable text
    //base stuff - saved in case we do a cancel
    Damage : TDamageProfile;
    Resistance : TDamageResistanceProfile;
    BaseStrength : integer;
    BaseCoordination : integer;
    BaseConstitution : integer;
    BasePerception : integer;
    BaseCharm : integer;
    BaseMysticism : integer;
    BaseCombat : integer;
    BaseStealth : integer;
    TrainingPoints : integer;
    ixSelectedShirt : integer; //current selected shirt color
    ixSelectedPants : integer; //current selected pants color
    ixSelectedHair : integer; //current selected Hair color
    ixSelectedHairStyle : integer; //current selected Hairstyle
    ixSelectedBeard : integer;
    ixSelectedTraining : integer;
    
    procedure LoadBaseValues; //saves the base stats of the character
    procedure LoadNames;
    procedure CreateCollisionRects; //create the rects for the collision detection
    function ShowListBox( aX, aY : integer; aMoOptions : TMouseOverNewOptions ): integer;
  public
    Character : TCharacter;
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
  logger,
  globals,
  GameMainMenu,
  ListBoxDialog, sdlgameinterface, Math;

{ TNewGame }

procedure TNewGame.CreateCollisionRects;
const
  FailName : string = 'TNewGame.CreateCollisionRects';
  Flags : Cardinal = SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL;
var
  i, j : integer;
  LineHeight : integer;
  C : TSDL_Color;
begin
  try
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


  
    LineHeight := 24;
     //first the ArrowRects
    for i := 0 to 7 do
    begin
      ArrowRect[ i ].FRect.x := 389;
      ArrowRect[ i + 8 ].FRect.x := 408;
      ArrowRect[ i ].FRect.w := 406 - ArrowRect[ i ].FRect.x;
      ArrowRect[ i + 8 ].FRect.w := 425 - ArrowRect[ i + 8 ].FRect.x;
      ArrowRect[ i ].FRect.y := 239 + i * LineHeight;
      ArrowRect[ i + 8 ].FRect.y := 239 + i * LineHeight;
      ArrowRect[ i ].FRect.h := ( 239 + i * LineHeight + LineHeight ) - ArrowRect[ i ].FRect.y;
      ArrowRect[ i + 8 ].FRect.h := ( 239 + i * LineHeight + LineHeight ) - ArrowRect[ i ].FRect.y;

      ArrowRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 26 ] + StatName[ 0 ][ i + 1 ] + '.', InfoPanel.w, InfoPanel.h );
      SDL_SetColorKey( ArrowRect[ i ].FInfo, Flags, SDL_MapRGB( ArrowRect[ i ].FInfo.format, 0, 0, 0 ) );

      if i < 5 then
      begin
        ArrowRect[ i + 8 ].FInfo := GameFont.DrawText( TextMessage[ 27 ] + StatName[ 0 ][ i + 1 ] + TextMessage[ 28 ] + StatName[ 0 ][ i + 1 ] + TextMessage[ 29 ], InfoPanel.w, InfoPanel.h );
        SDL_SetColorKey( ArrowRect[ i + 8 ].FInfo, Flags, SDL_MapRGB( ArrowRect[ i + 8 ].FInfo.format, 0, 0, 0 ) );
      end
      else
      begin
        ArrowRect[ i + 8 ].FInfo := GameFont.DrawText( TextMessage[ 30 ] + StatName[ 0 ][ i + 1 ] + TextMessage[ 31 ] + StatName[ 0 ][ i + 1 ] + TextMessage[ 29 ], InfoPanel.w, InfoPanel.h );
        SDL_SetColorKey( ArrowRect[ i + 8 ].FInfo, Flags, SDL_MapRGB( ArrowRect[ i + 8 ].FInfo.format, 0, 0, 0 ) );
      end;

    end; //end for

     //Training points
    InfoRect[ 0 ].FRect.x := 298;
    InfoRect[ 0 ].FRect.y := 212;
    InfoRect[ 0 ].FRect.w := 457 - InfoRect[ 0 ].FRect.x;
    InfoRect[ 0 ].FRect.h := 236 - InfoRect[ 0 ].FRect.y;
    InfoRect[ 0 ].FInfo := GameFont.DrawText( TextMessage[ 32 ], InfoPanel.w, InfoPanel.h );
     //Primary->Stealth
    for i := 1 to 9 do
    begin
      InfoRect[ i ].FRect.x := 289;
      InfoRect[ i ].FRect.w := 457 - InfoRect[ i ].FRect.x;
      InfoRect[ i ].FRect.y := 239 + ( i - 2 ) * LineHeight;
      InfoRect[ i ].FRect.h := ( 239 + ( i - 2 ) * LineHeight + LineHeight ) - InfoRect[ i ].FRect.y;
    end;
    InfoRect[ 1 ].FRect.x := 0; //no longer used here
    InfoRect[ 1 ].FRect.w := 0;
    InfoRect[ 1 ].FInfo := nil; //Primary skills are your characters main traits.  These skills determine '+
                       //'your Secondary skills, Resistance modifiers and Damage modifers.  Training '+
                       //'points are used to increase your Primary skills.';
    InfoRect[ 2 ].FInfo := GameFont.DrawText( TextMessage[ 33 ], InfoPanel.w, InfoPanel.h ) ; //'Strength represents the physical strength of a character.  Strength affects '+
                       //'how much damage a character inflicts in battle.';
    InfoRect[ 3 ].FInfo := GameFont.DrawText( TextMessage[ 34 ], InfoPanel.w, InfoPanel.h ); //'Coordination represents how agile a character is.  Coordination affects '+
                       //'a character''s movement, recovery and resistance modifiers.';
    InfoRect[ 4 ].FInfo := GameFont.DrawText( TextMessage[ 35 ], InfoPanel.w, InfoPanel.h ); //'Constitution represents a characters physical hardiness.  Constitution affects '+
                       //'a character''s healing rate and hit points.';
    InfoRect[ 5 ].FInfo := GameFont.DrawText( TextMessage[ 36 ], InfoPanel.w, InfoPanel.h ); //'Perception represents how well a character senses the area around him.';
                       //'Perception affects a character''s...something.  Lord knows I''m stumped.';
    InfoRect[ 6 ].FInfo := GameFont.DrawText( TextMessage[ 37 ], InfoPanel.w, InfoPanel.h ); //'Charm represents a character''s personal magnetism.  Charm affects the '+
                       //'prices a character can command when buying or selling items.';
    InfoRect[ 7 ].FInfo := GameFont.DrawText( TextMessage[ 38 ], InfoPanel.w, InfoPanel.h ); //'Mysticism represents a character''s magical ability.  Mysticism affects '+
                       //'the character''s recharge rate and mana.';
    InfoRect[ 8 ].FInfo := GameFont.DrawText( TextMessage[ 39 ], InfoPanel.w, InfoPanel.h ); //'Combat represents a character''s fighting ability.  Combat affects '+
                       //'the character''s damage modifiers.';
    InfoRect[ 9 ].FInfo := GameFont.DrawText( TextMessage[ 40 ], InfoPanel.w, InfoPanel.h ); //'Stealth represents the character''s ability to move and avoid detection.';


    i := 10;
     //the characters name
    InfoRect[ i ].FRect.x := 301;
    InfoRect[ i ].FRect.y := 92;
    InfoRect[ i ].FRect.w := 448 - InfoRect[ i ].FRect.x;
    InfoRect[ i ].FRect.h := 120 - InfoRect[ i ].FRect.y;
    InfoRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 41 ], InfoPanel.w, InfoPanel.h );
     //the appearance
    inc( i );
    InfoRect[ i ].FRect.x := 113;
    InfoRect[ i ].FRect.y := 92;
    InfoRect[ i ].FRect.w := 281 - InfoRect[ i ].FRect.x;
    InfoRect[ i ].FRect.h := 221 - InfoRect[ i ].FRect.y;
    InfoRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 42 ], InfoPanel.w, InfoPanel.h );
     //shirt color
    inc( i );
    InfoRect[ i ].FRect.x := 113;
    InfoRect[ i ].FRect.y := 236;
    InfoRect[ i ].FRect.w := 281 - InfoRect[ i ].FRect.x;
    InfoRect[ i ].FRect.h := 264 - InfoRect[ i ].FRect.y;
    InfoRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 43 ], InfoPanel.w, InfoPanel.h );
     //pants
    inc( i );
    InfoRect[ i ].FRect.x := 113;
    InfoRect[ i ].FRect.y := 278;
    InfoRect[ i ].FRect.w := 281 - InfoRect[ i ].FRect.x;
    InfoRect[ i ].FRect.h := 306 - InfoRect[ i ].FRect.y;
    InfoRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 44 ], InfoPanel.w, InfoPanel.h );
     //hair color
    inc( i );
    InfoRect[ i ].FRect.x := 113;
    InfoRect[ i ].FRect.y := 321;
    InfoRect[ i ].FRect.w := 281 - InfoRect[ i ].FRect.x;
    InfoRect[ i ].FRect.h := 348 - InfoRect[ i ].FRect.y;
    InfoRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 45 ], InfoPanel.w, InfoPanel.h );
     //hair style
    inc( i );
    InfoRect[ i ].FRect.x := 113;
    InfoRect[ i ].FRect.y := 363;
    InfoRect[ i ].FRect.w := 281 - InfoRect[ i ].FRect.x;
    InfoRect[ i ].FRect.h := 391 - InfoRect[ i ].FRect.y;
    InfoRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 46 ], InfoPanel.w, InfoPanel.h );
     //beard
    inc( i );
    InfoRect[ i ].FRect.x := 113;
    InfoRect[ i ].FRect.y := 406;
    InfoRect[ i ].FRect.w := 281 - InfoRect[ i ].FRect.x;
    InfoRect[ i ].FRect.h := 434 - InfoRect[ i ].FRect.y;
    InfoRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 47 ], InfoPanel.w, InfoPanel.h );
    inc( i );
    InfoRect[ i ].FRect.x := 300;
    InfoRect[ i ].FRect.y := 132;
    InfoRect[ i ].FRect.w := 468 - InfoRect[ i ].FRect.x;
    InfoRect[ i ].FRect.h := 160 - InfoRect[ i ].FRect.y;
    InfoRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 48 ], InfoPanel.w, InfoPanel.h ); //  Fighting training places an emphasis on your '+
                       //'character''s combat ability, Scouting emphasizes your character''s stealth talents '+
                       //'and Magic emphasizes your character''s spellcasting ability.';

     //now for the selectable text
     //Shirt color
    i := 0;
    SelectRect[ i ].FRect.x := -148;
    SelectRect[ i ].FRect.y := 80;
    SelectRect[ i ].FRect.w := -186 - InfoRect[ i ].FRect.x;
    SelectRect[ i ].FRect.h := 101 - InfoRect[ i ].FRect.y;
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 49 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 70 ] );
    inc( i );
    SelectRect[ i ].FRect.x := -197;
    SelectRect[ i ].FRect.y := 80;
    SelectRect[ i ].FRect.w := -258 - InfoRect[ i ].FRect.x;
    SelectRect[ i ].FRect.h := 101 - InfoRect[ i ].FRect.y;
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 50 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 71 ] );
    inc( i );
    SelectRect[ i ].FRect.x := -269;
    SelectRect[ i ].FRect.y := 80;
    SelectRect[ i ].FRect.w := -320 - InfoRect[ i ].FRect.x;
    SelectRect[ i ].FRect.h := 101 - InfoRect[ i ].FRect.y;
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 51 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 72 ] );
    inc( i );
    SelectRect[ i ].FRect.x := -331;
    SelectRect[ i ].FRect.y := 80;
    SelectRect[ i ].FRect.w := -382 - InfoRect[ i ].FRect.x;
    SelectRect[ i ].FRect.h := 101 - InfoRect[ i ].FRect.y;
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 52 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 73 ] );
     //Pants color
    inc( i );
    SelectRect[ i ].FRect.x := -148;
    SelectRect[ i ].FRect.y := 110;
    SelectRect[ i ].FRect.w := -186 - InfoRect[ i ].FRect.x;
    SelectRect[ i ].FRect.h := 131 - InfoRect[ i ].FRect.y;
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 53 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 70 ] );
    inc( i );
    SelectRect[ i ].FRect.x := -197;
    SelectRect[ i ].FRect.y := 110;
    SelectRect[ i ].FRect.w := -258 - InfoRect[ i ].FRect.x;
    SelectRect[ i ].FRect.h := 131 - InfoRect[ i ].FRect.y;
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 54 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 71 ] );
    inc( i );
    SelectRect[ i ].FRect.x := -269;
    SelectRect[ i ].FRect.y := 110;
    SelectRect[ i ].FRect.w := -320 - InfoRect[ i ].FRect.x;
    SelectRect[ i ].FRect.h := 131 - InfoRect[ i ].FRect.y;
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 55 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 72 ] );
    inc( i );
    SelectRect[ i ].FRect.x := -331;
    SelectRect[ i ].FRect.y := 110;
    SelectRect[ i ].FRect.w := -382 - InfoRect[ i ].FRect.x;
    SelectRect[ i ].FRect.h := 131 - InfoRect[ i ].FRect.y;
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 56 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 73 ] );
     //hair color
    inc( i );
    SelectRect[ i ].FRect.x := -149;
    SelectRect[ i ].FRect.y := 140;
    SelectRect[ i ].FRect.w := -201 - InfoRect[ i ].FRect.x;
    SelectRect[ i ].FRect.h := 161 - InfoRect[ i ].FRect.y;
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 57 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 74 ] );
    inc( i );
    SelectRect[ i ].FRect.x := -210;
    SelectRect[ i ].FRect.y := 140;
    SelectRect[ i ].FRect.w := -271 - InfoRect[ i ].FRect.x;
    SelectRect[ i ].FRect.h := 161 - InfoRect[ i ].FRect.y;
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 58 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 71 ] );
    inc( i );
    SelectRect[ i ].FRect.x := -281;
    SelectRect[ i ].FRect.y := 140;
    SelectRect[ i ].FRect.w := -320 - InfoRect[ i ].FRect.x;
    SelectRect[ i ].FRect.h := 161 - InfoRect[ i ].FRect.y;
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 59 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 75 ] );
    inc( i );
    SelectRect[ i ].FRect.x := 329;
    SelectRect[ i ].FRect.y := 140;
    SelectRect[ i ].FRect.w := 373 - InfoRect[ i ].FRect.x;
    SelectRect[ i ].FRect.h := 161 - InfoRect[ i ].FRect.y;
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 60 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 76 ] );
     //Hair style
    inc( i );
    SelectRect[ i ].FRect.x := 149;
    SelectRect[ i ].FRect.y := 170;
    SelectRect[ i ].FRect.w := 196 - InfoRect[ i ].FRect.x;
    SelectRect[ i ].FRect.h := 191 - InfoRect[ i ].FRect.y;
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 61 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 77 ] );
    inc( i );
    SelectRect[ i ].FRect.x := 206;
    SelectRect[ i ].FRect.y := 170;
    SelectRect[ i ].FRect.w := 249 - InfoRect[ i ].FRect.x;
    SelectRect[ i ].FRect.h := 191 - InfoRect[ i ].FRect.y;
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 62 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 78 ] );
    inc( i );
    SelectRect[ i ].FRect.x := 259;
    SelectRect[ i ].FRect.y := 170;
    SelectRect[ i ].FRect.w := 331;
    SelectRect[ i ].FRect.h := 194;
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 63 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 79 ] );
    inc( i );
    SelectRect[ i ].FRect.x := 340;
    SelectRect[ i ].FRect.y := 170;
    SelectRect[ i ].FRect.w := 382 - InfoRect[ i ].FRect.x;
    SelectRect[ i ].FRect.h := 191 - InfoRect[ i ].FRect.y;
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 64 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 80 ] );
     //beard
    inc( i );
    SelectRect[ i ].FRect.x := 149;
    SelectRect[ i ].FRect.y := 200;
    SelectRect[ i ].FRect.w := 185 - InfoRect[ i ].FRect.x;
    SelectRect[ i ].FRect.h := 223 - InfoRect[ i ].FRect.y;
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 65 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 81 ] );
    inc( i );
    SelectRect[ i ].FRect.x := 194;
    SelectRect[ i ].FRect.y := 200;
    SelectRect[ i ].FRect.w := 239 - InfoRect[ i ].FRect.x;
    SelectRect[ i ].FRect.h := 223 - InfoRect[ i ].FRect.y;
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 66 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 82 ] );

    //Training
    inc( i );
    SelectRect[ i ].FRect.x := 40;
    SelectRect[ i ].FRect.y := 270;
    SelectRect[ i ].FRect.w := 113 - InfoRect[ i ].FRect.x;
    SelectRect[ i ].FRect.h := 293 - InfoRect[ i ].FRect.y;
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 67 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 83 ] );
    inc( i );
    SelectRect[ i ].FRect.x := 127;
    SelectRect[ i ].FRect.y := 270;
    SelectRect[ i ].FRect.w := 200 - InfoRect[ i ].FRect.x;
    SelectRect[ i ].FRect.h := 293 - InfoRect[ i ].FRect.y;
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 68 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 84 ] );
    inc( i );
    SelectRect[ i ].FRect.x := 216;
    SelectRect[ i ].FRect.y := 270;
    SelectRect[ i ].FRect.w := 270 - InfoRect[ i ].FRect.x;
    SelectRect[ i ].FRect.h := 293 - InfoRect[ i ].FRect.y;
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 69 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 85 ] );
  except
    on E: Exception do
      Log.LogError( E.Message, FailName );
  end;
end;

procedure TNewGame.FreeSurfaces;
var
  i : integer;
begin
  SDL_FreeSurface( DXCircle ); //circle used for outline
  SDL_FreeSurface( DXBox );
  SDL_FreeSurface( DXBlack );
  SDL_FreeSurface( DXContinue );
  SDL_FreeSurface( DXCancel );
  SDL_FreeSurface( DXLeftArrow );
  SDL_FreeSurface( DXRightArrow );

  for i := Low( InfoRect ) to High( InfoRect ) do
    if InfoRect[ i ].FInfo <> nil then
      SDL_FreeSurface( InfoRect[ i ].FInfo );

  for i := Low( ArrowRect ) to High( ArrowRect ) do
    if ArrowRect[ i ].FInfo <> nil then
      SDL_FreeSurface( ArrowRect[ i ].FInfo );

  for i := Low( SelectRect ) to High( SelectRect ) do
  begin
    if SelectRect[ i ].FInfo <> nil then
      SDL_FreeSurface( SelectRect[ i ].FInfo );
    if SelectRect[ i ].FText <> nil then
      SDL_FreeSurface( SelectRect[ i ].FText );
  end;

  ExText.Close;

  inherited;
end;

procedure TNewGame.KeyDown( var Key : TSDLKey; Shift : TSDLMod; unicode : UInt16 );
const
  FailName : string = 'TNewGame.KeyDown';
begin
  inherited;
  try
    case Key of
      SDLK_RETURN :
        begin
          NextGameInterface := TMainMenu;
        end;

      SDLK_ESCAPE :
        begin
          NextGameInterface := TMainMenu;
        end;
    end;
    MainWindow.Rendering := false;
  except
    on E: Exception do
      Log.LogError( E.Message, FailName );
  end;
end;

procedure TNewGame.LoadBaseValues;
const
  FailName : string = 'TNewGame.LoadBaseValues';
var
  i : integer;
begin
  try
    //we store thse values so that we can keep the player from lowering his score beyon its start
    Damage := Character.Damage;
    Resistance := Character.Resistance;
    BaseStrength := Character.BaseStrength;
    BaseCoordination := Character.BaseCoordination;
    BaseConstitution := Character.BaseConstitution;
    BasePerception := Character.BasePerception;
    BaseCharm := Character.BaseCharm;
    BaseMysticism := Character.BaseMysticism;
    BaseCombat := Character.BaseCombat;
    BaseStealth := Character.BaseStealth;
    TrainingPoints := Character.TrainingPoints;

    for i := 0 to 7 do
    begin //initialize adjustments to zero
      StatAdjustments[ i ] := 0;
    end;
  except
    on E: Exception do
      Log.LogError( E.Message, FailName );
  end;
end;

procedure TNewGame.LoadNames;
const
  FailName : string = 'TNewGame.LoadNames';
begin
  try
    StatName[ 0 ][ 1 ] := TextMessage[ 86 ]; //'Strength';
    StatName[ 0 ][ 2 ] := TextMessage[ 87 ]; //'Coordination';
    StatName[ 0 ][ 3 ] := TextMessage[ 88 ]; //'Constitution';
    StatName[ 0 ][ 4 ] := TextMessage[ 89 ]; //'Perception';
    StatName[ 0 ][ 5 ] := TextMessage[ 90 ]; //'Charm';
    StatName[ 0 ][ 6 ] := TextMessage[ 91 ]; //'Mysticism';
    StatName[ 0 ][ 7 ] := TextMessage[ 92 ]; //'Combat';
    StatName[ 0 ][ 8 ] := TextMessage[ 93 ]; //'Stealth';

    StatName[ 1 ][ 1 ] := TextMessage[ 94 ]; //'Piercing';
    StatName[ 1 ][ 2 ] := TextMessage[ 95 ]; //'Crushing';
    StatName[ 1 ][ 3 ] := TextMessage[ 96 ]; //'Cutting';
    StatName[ 1 ][ 4 ] := TextMessage[ 97 ]; //'Heat';
    StatName[ 1 ][ 5 ] := TextMessage[ 98 ]; //'Cold';
    StatName[ 1 ][ 6 ] := TextMessage[ 99 ]; //'Electric';
    StatName[ 1 ][ 7 ] := TextMessage[ 100 ]; //'Poison';
    StatName[ 1 ][ 8 ] := TextMessage[ 101 ]; //'Magic';
    StatName[ 1 ][ 9 ] := TextMessage[ 102 ]; //'Mental';
    StatName[ 1 ][ 10 ] := TextMessage[ 103 ]; //'Stun';
    StatName[ 1 ][ 11 ] := TextMessage[ 104 ]; //'Special';
  except
    on E: Exception do
      Log.LogError( E.Message, FailName );
  end;
end;

procedure TNewGame.LoadSurfaces;
const
  FailName : string = 'TNewGame.LoadSurfaces';
  Flags : Cardinal = SDL_SRCCOLORKEY or SDL_RLEACCEL or SDL_HWACCEL;
var
  i : integer;
begin
  inherited;
  try
    ExText.Open( 'CharCreation' );
    for i := Low( TextMessage ) to High( TextMessage ) do
    begin
      TextMessage[ i ] := ExText.GetText( 'Message' + IntToStr( i ) );
    end;

    DXBack := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + SoASettings.LanguagePath + '/' + 'CharCreate.bmp' ) );
    SDL_SetColorKey( DXBack, Flags, SDL_MapRGB( DXBack.format, 0, 255, 255 ) );

    DXCircle := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'chaRedOval.bmp' ) );
    SDL_SetColorKey( DXCircle, Flags, SDL_MapRGB( DXCircle.format, 0, 255, 255 ) );

    DXBlack := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'chaBlack.bmp' ) );
    SDL_SetColorKey( DXBlack, Flags, SDL_MapRGB( DXBlack.format, 0, 255, 255 ) );

    DXBox := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + SoASettings.LanguagePath + '/' + 'chaChooseBox.bmp' ) );
    SDL_SetColorKey( DXBox, Flags, SDL_MapRGB( DXBox.format, 0, 255, 255 ) );

    DXContinue := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + SoASettings.LanguagePath + '/' + 'chaContinue.bmp' ) );
    SDL_SetColorKey( DXContinue, Flags, SDL_MapRGB( DXContinue.format, 255, 255, 255 ) );

    DXCancel := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + SoASettings.LanguagePath + '/' + 'chaCancel.bmp' ) );
    SDL_SetColorKey( DXCancel, Flags, SDL_MapRGB( DXCancel.format, 0, 255, 255 ) );

    DXLeftArrow := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'leftarrow.bmp' ) );
    SDL_SetColorKey( DXLeftArrow, Flags, SDL_MapRGB( DXLeftArrow.format, 0, 255, 255  ) );

    DXRightArrow := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'rightarrow.bmp' ) );
    SDL_SetColorKey( DXRightArrow, Flags, SDL_MapRGB( DXRightArrow.format, 0, 255, 255 ) );

    ContinueRect.x := 400;
    ContinueRect.y := 449;
    ContinueRect.w := DXContinue.w;
    ContinueRect.h := DXContinue.h;

    CancelRect.x := 100;
    CancelRect.y := 449;
    CancelRect.w := DXCancel.w;
    CancelRect.h := DXCancel.h;

    LeftArrowRect.x := 112;
    LeftArrowRect.y := 73;
    LeftArrowRect.w := DXLeftArrow.w;
    LeftArrowRect.h := DXLeftArrow.h;

    RightArrowRect.x := 250;
    RightArrowRect.y := 73;
    RightArrowRect.w := DXRightArrow.w;
    RightArrowRect.h := DXRightArrow.h;

    InfoPanel.x := 488;
    InfoPanel.y := 160;
    InfoPanel.w := 194;
    InfoPanel.h := 274;

    LoadNames;
    CreateCollisionRects;
    //LoadBaseValues;
    //ShowStats;
    //DrawTheGuy;
  except
    on E: Exception do
      Log.LogError( E.Message, FailName );
  end;
end;

procedure TNewGame.MouseDown( Button : Integer; Shift : TSDLMod; CurrentPos : TPoint );
const
  FailName : string = 'TNewGame.MouseDown';
begin
  inherited;
  try
    if PointIsInRect( CurrentPos, 452, 133, 467, 159 ) then
      ixSelectedTraining := ShowListBox( 313, 175, moTrainingStyle )
    else if PointIsInRect( CurrentPos, 265, 239, 279, 264  ) then
      ixSelectedShirt := ShowListBox( 280, 239, moShirtColour )
    else if PointIsInRect( CurrentPos, 265, 280, 279, 295 ) then
      ixSelectedPants := ShowListBox( 280, 281, moPantsColour )
    else if PointIsInRect( CurrentPos, 265, 322, 279, 337 ) then
      ixSelectedHair := ShowListBox( 280, 323, moHairColour )
    else if PointIsInRect( CurrentPos, 265, 364, 279, 379 ) then
      ixSelectedHairStyle := ShowListBox( 280, 365, moHairStyle )
    else if PointIsInRect( CurrentPos, 265, 408, 279, 423 ) then
      ixSelectedBeard := ShowListBox( 280, 409, moBeard )
    else if PointIsInRect( CurrentPos, CancelRect.x, CancelRect.y, CancelRect.x + CancelRect.w, CancelRect.y + CancelRect.h ) then
    begin
      NextGameInterface := TMainMenu;
      MainWindow.Rendering := false;
    end
    else if PointIsInRect( CurrentPos, ContinueRect.x, ContinueRect.y, ContinueRect.x + ContinueRect.w, ContinueRect.y + ContinueRect.h ) then
    begin
      // Check to see we have all data before starting the new game
      NextGameInterface := TMainMenu;
      MainWindow.Rendering := false;
    end
    else if PointIsInRect( CurrentPos, LeftArrowRect.x, LeftArrowRect.y, LeftArrowRect.x + LeftArrowRect.w, LeftArrowRect.y + LeftArrowRect.h ) then
      // Set Previous Character
    else if PointIsInRect( CurrentPos, RightArrowRect.x, RightArrowRect.y, RightArrowRect.x + RightArrowRect.w, RightArrowRect.y + RightArrowRect.h ) then
      // Set Next Character
  except
    on E: Exception do
      Log.LogError( E.Message, FailName );
  end;
end;

procedure TNewGame.MouseMove( Shift : TSDLMod; CurrentPos, RelativePos : TPoint );
const
  FailName : string = 'TNewGame.MouseMove';
var
  i : integer;
begin
  inherited;
  try
    MouseOverOptions := moNone;
    if PointIsInRect( CurrentPos, 113, 92, 261, 222 ) then
      MouseOverOptions := moAppearance
    else if PointIsInRect( CurrentPos, 113, 236, 261, 264 ) then
      MouseOverOptions := moShirtColour
    else if PointIsInRect( CurrentPos, 113, 278, 261, 306 ) then
      MouseOverOptions := moPantsColour
    else if PointIsInRect( CurrentPos, 113, 320, 261, 348 ) then
      MouseOverOptions := moHairColour
    else if PointIsInRect( CurrentPos, 113, 363, 261, 391 ) then
      MouseOverOptions := moHairStyle
    else if PointIsInRect( CurrentPos, 113, 406, 261, 434 ) then
      MouseOverOptions := moBeard
    else if PointIsInRect( CurrentPos, 300, 92, 448, 120 ) then
      MouseOverOptions := moName
    else if PointIsInRect( CurrentPos, 300, 132, 448, 160 ) then
      MouseOverOptions := moTrainingStyle
    else if PointIsInRect( CurrentPos, 288, 205, 460, 236 ) then
      MouseOverOptions := moTrainingPoints
    else if PointIsInRect( CurrentPos, 288, 240, 387, 264 ) then
      MouseOverOptions := moStrength
    else if PointIsInRect( CurrentPos, 288, 265, 387, 289 ) then
      MouseOverOptions := moCoordination
    else if PointIsInRect( CurrentPos, 288, 290, 387, 314 ) then
      MouseOverOptions := moConstitution
    else if PointIsInRect( CurrentPos, 288, 315, 387, 339 ) then
      MouseOverOptions := moPerception
    else if PointIsInRect( CurrentPos, 288, 340, 387, 364 ) then
      MouseOverOptions := moCharm
    else if PointIsInRect( CurrentPos, 288, 365, 387, 389 ) then
      MouseOverOptions := moMysticism
    else if PointIsInRect( CurrentPos, 288, 390, 387, 414 ) then
      MouseOverOptions := moCombat
    else if PointIsInRect( CurrentPos, 288, 415, 387, 439 ) then
      MouseOverOptions := moStealth
    else if PointIsInRect( CurrentPos, ContinueRect.x, ContinueRect.y, ContinueRect.x + ContinueRect.w, ContinueRect.y + ContinueRect.h ) then
      MouseOverOptions := moContinue
    else if PointIsInRect( CurrentPos, CancelRect.x, CancelRect.y, CancelRect.x + CancelRect.w, CancelRect.y + CancelRect.h ) then
      MouseOverOptions := moCancel
    else if PointIsInRect( CurrentPos, LeftArrowRect.x, LeftArrowRect.y, LeftArrowRect.x + LeftArrowRect.w, LeftArrowRect.y + LeftArrowRect.h ) then
      MouseOverOptions := moLeftArrow
    else if PointIsInRect( CurrentPos, RightArrowRect.x, RightArrowRect.y, RightArrowRect.x + RightArrowRect.w, RightArrowRect.y + RightArrowRect.h ) then
      MouseOverOptions := moRightArrow
    else
    begin
      for i := 0 to 15 do
      begin
        if PointIsInRect( CurrentPos, ArrowRect[ i ].FRect.x, ArrowRect[ i ].FRect.y, ArrowRect[ i ].FRect.x + ArrowRect[ i ].FRect.w, ArrowRect[ i ].FRect.y + ArrowRect[ i ].FRect.h ) then
        begin
          MouseOverOptions := TMouseOverNewOptions( i + 12 );
          break;
        end;
      end;
    end;
  except
    on E: Exception do
      Log.LogError( E.Message, FailName );
  end;
end;

procedure TNewGame.Render;
const
  FailName : string = 'TNewGame.Render';
begin
  inherited;
  try
    case MouseOverOptions of
      moName :
      begin
        SDL_BlitSurface( InfoRect[ 10 ].FInfo, nil, MainWindow.DisplaySurface, @InfoPanel );
      end;

      moAppearance :
      begin
        SDL_BlitSurface( InfoRect[ 11 ].FInfo, nil, MainWindow.DisplaySurface, @InfoPanel );
      end;
      
      moShirtColour :
      begin
        SDL_BlitSurface( InfoRect[ 12 ].FInfo, nil, MainWindow.DisplaySurface, @InfoPanel );
      end;

      moPantsColour :
      begin
        SDL_BlitSurface( InfoRect[ 13 ].FInfo, nil, MainWindow.DisplaySurface, @InfoPanel );
      end;

      moHairColour :
      begin
        SDL_BlitSurface( InfoRect[ 14 ].FInfo, nil, MainWindow.DisplaySurface, @InfoPanel );
      end;

      moHairStyle :
      begin
        SDL_BlitSurface( InfoRect[ 15 ].FInfo, nil, MainWindow.DisplaySurface, @InfoPanel );
      end;

      moBeard :
      begin
        SDL_BlitSurface( InfoRect[ 16 ].FInfo, nil, MainWindow.DisplaySurface, @InfoPanel );
      end;

      moTrainingStyle :
      begin
        SDL_BlitSurface( InfoRect[ 17 ].FInfo, nil, MainWindow.DisplaySurface, @InfoPanel );
      end;

      moTrainingPoints :
        SDL_BlitSurface( InfoRect[ 0 ].FInfo, nil, MainWindow.DisplaySurface, @InfoPanel );
        
      moStrength :
        SDL_BlitSurface( InfoRect[ 2 ].FInfo, nil, MainWindow.DisplaySurface, @InfoPanel );

      moCoordination :
        SDL_BlitSurface( InfoRect[ 3 ].FInfo, nil, MainWindow.DisplaySurface, @InfoPanel );

      moConstitution :
        SDL_BlitSurface( InfoRect[ 4 ].FInfo, nil, MainWindow.DisplaySurface, @InfoPanel );

      moPerception :
        SDL_BlitSurface( InfoRect[ 5 ].FInfo, nil, MainWindow.DisplaySurface, @InfoPanel );

      moCharm :
        SDL_BlitSurface( InfoRect[ 6 ].FInfo, nil, MainWindow.DisplaySurface, @InfoPanel );

      moMysticism :
        SDL_BlitSurface( InfoRect[ 7 ].FInfo, nil, MainWindow.DisplaySurface, @InfoPanel );

      moCombat :
        SDL_BlitSurface( InfoRect[ 8 ].FInfo, nil, MainWindow.DisplaySurface, @InfoPanel );

      moStealth :
        SDL_BlitSurface( InfoRect[ 9 ].FInfo, nil, MainWindow.DisplaySurface, @InfoPanel );

      moContinue :
        begin
          SDL_BlitSurface( DXContinue, nil, MainWindow.DisplaySurface, @ContinueRect );
        end;

      moCancel :
        begin
          SDL_BlitSurface( DXCancel, nil, MainWindow.DisplaySurface, @CancelRect );
        end;

      moStrengthMinus..moStealthPlus :
        SDL_BlitSurface( ArrowRect[ Ord( MouseOverOptions ) - 12 ].FInfo, nil, MainWindow.DisplaySurface, @InfoPanel );
    end;

    SDL_BlitSurface( DXLeftArrow, nil, MainWindow.DisplaySurface, @LeftArrowRect );
    SDL_BlitSurface( DXRightArrow, nil, MainWindow.DisplaySurface, @RightArrowRect );
  except
    on E: Exception do
      Log.LogError( E.Message, FailName );
  end;
end;

function TNewGame.ShowListBox( aX, aY : integer; aMoOptions : TMouseOverNewOptions ) : integer;
const
  FailName : string = 'TNewGame.ShowListBox';
var
  ListBoxDialog : TListBoxDialog;
  i, x, iLow, iHigh : integer;
begin
  Result := -1;
  try
    iLow := 0;
    iHigh := 3;
    ListBoxDialog := TListBoxDialog.Create( SoAoSGame, aX, aY );
    try
      case aMoOptions of
        moShirtColour :
        begin
          iLow := 0;
          iHigh := 3;
        end;

        moPantsColour :
        begin
          iLow := 4;
          iHigh := 7;
        end;

        moHairColour :
        begin
          iLow := 8;
          iHigh := 11;
        end;

        moHairStyle :
        begin
          iLow := 12;
          iHigh := 15;
        end;

        moBeard :
        begin
          iLow := 16;
          iHigh := 17;
        end;

        moTrainingStyle :
        begin
          iLow := 18;
          iHigh := 20;
        end;
      end;

      x := 0;
      SetLength( ListBoxDialog.ListItems, iHigh - iLow );
      for i := iLow to iHigh do
      begin
        ListBoxDialog.ListItems[ x ].FInfo := SelectRect[ i ].FInfo;
        ListBoxDialog.ListItems[ X ].FText := SelectRect[ i ].FText;
        inc( x );
      end;
    
      ListBoxDialog.LoadSurfaces;
      SoAoSGame.Show;
      Result := ListBoxDialog.SelectedIndex;
    finally
      ListBoxDialog.Free;
    end;
    ResetInputManager;
  except
    on E: Exception do
      Log.LogError( E.Message, FailName );
  end;
end;

end.

