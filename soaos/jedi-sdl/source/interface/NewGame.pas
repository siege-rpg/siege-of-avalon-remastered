unit NewGame;
{******************************************************************************}
{
  $Id$

}
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
  Revision 1.7  2005/05/13 20:09:30  savage
  Changed so that german Continue appears correctly.

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
    moTrainingPoints,
    moPrimarySkill, // No longer used
    moStrength,
    moCoordination,
    moConstitution,
    moPerception,
    moCharm,
    moMysticism,
    moCombat,
    moStealth,
    moCharacterName,
    moAppearance,
    moShirtColour,
    moPantsColour,
    moHairColour,
    moHairStyle,
    moBeard,
    moTrainingStyle,
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
    moContinue,
    moCancel,
    moLeftArrow,
    moRightArrow,
    moNone );

  TRenderMode = ( rmNormal, rmPickList );

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
  private
    FName: string;
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
    constructor Create;
    property Name : string read FName write FName;
  end;

  TNewGame = class( TSimpleSoAInterface )
  private
    DXSelectRect : PSDL_Surface; // rectangle used for outline
    DXBlack : PSDL_Surface;
    DXContinue : PSDL_Surface;
    DXCancel : PSDL_Surface;
    DXLeftArrow, DXRightArrow : PSDL_Surface;
    DXPickList : PSDL_Surface;
    DXPlayerName : PSDL_Surface;
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
    RenderMode : TRenderMode;
    iPickListLow, iPickListHigh : integer;
    procedure LoadBaseValues; //saves the base stats of the character
    procedure LoadNames;
    procedure CreateCollisionRects; //create the rects for the collision detection
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
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 49 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 70 ] );
    SelectRect[ i ].FRect.x := 293;
    SelectRect[ i ].FRect.y := 265;
    SelectRect[ i ].FRect.w := 96;
    SelectRect[ i ].FRect.h := 21;
    inc( i );
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 50 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 71 ] );
    SelectRect[ i ].FRect.x := SelectRect[ i - 1 ].FRect.x;
    SelectRect[ i ].FRect.y := SelectRect[ i - 1 ].FRect.y + SelectRect[ i - 1 ].FRect.h;
    SelectRect[ i ].FRect.w := 96;
    SelectRect[ i ].FRect.h := 21;
    inc( i );
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 51 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 72 ] );
    SelectRect[ i ].FRect.x := SelectRect[ i - 1 ].FRect.x;
    SelectRect[ i ].FRect.y := SelectRect[ i - 1 ].FRect.y + SelectRect[ i - 1 ].FRect.h;
    SelectRect[ i ].FRect.w := 96;
    SelectRect[ i ].FRect.h := 21;
    inc( i );
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 52 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 73 ] );
    SelectRect[ i ].FRect.x := SelectRect[ i - 1 ].FRect.x;
    SelectRect[ i ].FRect.y := SelectRect[ i - 1 ].FRect.y + SelectRect[ i - 1 ].FRect.h;
    SelectRect[ i ].FRect.w := 96;
    SelectRect[ i ].FRect.h := 21;
     //Pants color
    inc( i );
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 53 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 70 ] );
    SelectRect[ i ].FRect.x := SelectRect[ i - 1 ].FRect.x;
    SelectRect[ i ].FRect.y := 307;
    SelectRect[ i ].FRect.w := 96;
    SelectRect[ i ].FRect.h := 21;
    inc( i );
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 54 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 71 ] );
    SelectRect[ i ].FRect.x := SelectRect[ i - 1 ].FRect.x;
    SelectRect[ i ].FRect.y := SelectRect[ i - 1 ].FRect.y + SelectRect[ i - 1 ].FRect.h;
    SelectRect[ i ].FRect.w := 96;
    SelectRect[ i ].FRect.h := 21;
    inc( i );
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 55 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 72 ] );
    SelectRect[ i ].FRect.x := SelectRect[ i - 1 ].FRect.x;
    SelectRect[ i ].FRect.y := SelectRect[ i - 1 ].FRect.y + SelectRect[ i - 1 ].FRect.h;
    SelectRect[ i ].FRect.w := 96;
    SelectRect[ i ].FRect.h := 21;
    inc( i );
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 56 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 73 ] );
    SelectRect[ i ].FRect.x := SelectRect[ i - 1 ].FRect.x;
    SelectRect[ i ].FRect.y := SelectRect[ i - 1 ].FRect.y + SelectRect[ i - 1 ].FRect.h;
    SelectRect[ i ].FRect.w := 96;
    SelectRect[ i ].FRect.h := 21;
     //hair color
    inc( i );
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 57 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 74 ] );
    SelectRect[ i ].FRect.x := SelectRect[ i - 1 ].FRect.x;
    SelectRect[ i ].FRect.y := 350;
    SelectRect[ i ].FRect.w := 96;
    SelectRect[ i ].FRect.h := 21;
    inc( i );
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 58 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 71 ] );
    SelectRect[ i ].FRect.x := SelectRect[ i - 1 ].FRect.x;
    SelectRect[ i ].FRect.y := SelectRect[ i - 1 ].FRect.y + SelectRect[ i - 1 ].FRect.h;
    SelectRect[ i ].FRect.w := 96;
    SelectRect[ i ].FRect.h := 21;
    inc( i );
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 59 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 75 ] );
    SelectRect[ i ].FRect.x := SelectRect[ i - 1 ].FRect.x;
    SelectRect[ i ].FRect.y := SelectRect[ i - 1 ].FRect.y + SelectRect[ i - 1 ].FRect.h;
    SelectRect[ i ].FRect.w := 96;
    SelectRect[ i ].FRect.h := 21;
    inc( i );
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 60 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 76 ] );
    SelectRect[ i ].FRect.x := SelectRect[ i - 1 ].FRect.x;
    SelectRect[ i ].FRect.y := SelectRect[ i - 1 ].FRect.y + SelectRect[ i - 1 ].FRect.h;
    SelectRect[ i ].FRect.w := 96;
    SelectRect[ i ].FRect.h := 21;
     //Hair style
    inc( i );
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 61 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 77 ] );
    SelectRect[ i ].FRect.x := SelectRect[ i - 1 ].FRect.x;
    SelectRect[ i ].FRect.y := 393;
    SelectRect[ i ].FRect.w := 96;
    SelectRect[ i ].FRect.h := 21;
    inc( i );
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 62 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 78 ] );
    SelectRect[ i ].FRect.x := SelectRect[ i - 1 ].FRect.x;
    SelectRect[ i ].FRect.y := SelectRect[ i - 1 ].FRect.y + SelectRect[ i - 1 ].FRect.h;
    SelectRect[ i ].FRect.w := 96;
    SelectRect[ i ].FRect.h := 21;
    inc( i );
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 63 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 79 ] );
    SelectRect[ i ].FRect.x := SelectRect[ i - 1 ].FRect.x;
    SelectRect[ i ].FRect.y := SelectRect[ i - 1 ].FRect.y + SelectRect[ i - 1 ].FRect.h;
    SelectRect[ i ].FRect.w := 96;
    SelectRect[ i ].FRect.h := 21;
    inc( i );
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 64 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 80 ] );
    SelectRect[ i ].FRect.x := SelectRect[ i - 1 ].FRect.x;
    SelectRect[ i ].FRect.y := SelectRect[ i - 1 ].FRect.y + SelectRect[ i - 1 ].FRect.h;
    SelectRect[ i ].FRect.w := 96;
    SelectRect[ i ].FRect.h := 21;
     //beard
    inc( i );
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 65 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 81 ] );
    SelectRect[ i ].FRect.x := SelectRect[ i - 1 ].FRect.x;
    SelectRect[ i ].FRect.y := 436;
    SelectRect[ i ].FRect.w := 96;
    SelectRect[ i ].FRect.h := 21;
    inc( i );
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 66 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 82 ] );
    SelectRect[ i ].FRect.x := SelectRect[ i - 1 ].FRect.x;
    SelectRect[ i ].FRect.y := SelectRect[ i - 1 ].FRect.y + SelectRect[ i - 1 ].FRect.h;
    SelectRect[ i ].FRect.w := 96;
    SelectRect[ i ].FRect.h := 21;

    //Training
    inc( i );
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 67 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 83 ] );
    SelectRect[ i ].FRect.x := 480;
    SelectRect[ i ].FRect.y := 160;
    SelectRect[ i ].FRect.w := 96;
    SelectRect[ i ].FRect.h := 21;
    inc( i );
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 68 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 84 ] );
    SelectRect[ i ].FRect.x := SelectRect[ i - 1 ].FRect.x;
    SelectRect[ i ].FRect.y := SelectRect[ i - 1 ].FRect.y + SelectRect[ i - 1 ].FRect.h;
    SelectRect[ i ].FRect.w := 96;
    SelectRect[ i ].FRect.h := 21;
    inc( i );
    SelectRect[ i ].FInfo := GameFont.DrawText( TextMessage[ 69 ], InfoPanel.w, InfoPanel.h );
    SelectRect[ i ].FText := GameFont.DrawText( TextMessage[ 85 ] );
    SelectRect[ i ].FRect.x := SelectRect[ i - 1 ].FRect.x;
    SelectRect[ i ].FRect.y := SelectRect[ i - 1 ].FRect.y + SelectRect[ i - 1 ].FRect.h;
    SelectRect[ i ].FRect.w := 96;
    SelectRect[ i ].FRect.h := 21;
  except
    on E: Exception do
      Log.LogError( E.Message, FailName );
  end;
end;

procedure TNewGame.FreeSurfaces;
var
  i : integer;
begin
  SDL_FreeSurface( DXSelectRect ); //circle used for outline
  SDL_FreeSurface( DXBlack );
  SDL_FreeSurface( DXContinue );
  SDL_FreeSurface( DXCancel );
  SDL_FreeSurface( DXLeftArrow );
  SDL_FreeSurface( DXRightArrow );
  SDL_FreeSurface( DXPickList );
  SDL_FreeSurface( DXPlayerName );

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
    case RenderMode of
      rmNormal :
      begin
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
      end;

      rmPickList :
      begin
        case Key of
          SDLK_RETURN :
            begin
              RenderMode := rmNormal;
            end;

          SDLK_ESCAPE :
            begin
              RenderMode := rmNormal;
            end;

          SDLK_UP :
          begin

          end;

          SDLK_DOWN :
          begin
            
          end;
        end;
      end;
    end;
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
    if Player <> nil then
      Player.Free;

    Player := TCharacter.Create;
    Player.TrainingPoints := 20;

    //we store thse values so that we can keep the player from lowering his score beyon its start
    Damage := Player.Damage;
    Resistance := Player.Resistance;
    BaseStrength := Player.BaseStrength;
    BaseCoordination := Player.BaseCoordination;
    BaseConstitution := Player.BaseConstitution;
    BasePerception := Player.BasePerception;
    BaseCharm := Player.BaseCharm;
    BaseMysticism := Player.BaseMysticism;
    BaseCombat := Player.BaseCombat;
    BaseStealth := Player.BaseStealth;
    TrainingPoints := Player.TrainingPoints;

    for i := 0 to 7 do
    begin //initialize adjustments to zero
      StatAdjustments[ i ] := 0;
    end;

    // Set Default Appearance
    ixSelectedShirt := 0;
    ixSelectedPants := 4;
    ixSelectedHair := 8;
    ixSelectedHairStyle := 12;
    ixSelectedBeard := 17;
    ixSelectedTraining := 18;
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

    DXSelectRect := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'chaRedOval.bmp' ) );
    SDL_SetColorKey( DXSelectRect, Flags, SDL_MapRGB( DXSelectRect.format, 0, 255, 255 ) );

    DXBlack := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'chaBlack.bmp' ) );
    SDL_SetColorKey( DXBlack, Flags, SDL_MapRGB( DXBlack.format, 0, 255, 255 ) );

    DXContinue := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + SoASettings.LanguagePath + '/' + 'chaContinue.bmp' ) );
    SDL_SetColorKey( DXContinue, Flags, SDL_MapRGB( DXContinue.format, 255, 255, 255 ) );

    DXCancel := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + SoASettings.LanguagePath + '/' + 'chaCancel.bmp' ) );
    SDL_SetColorKey( DXCancel, Flags, SDL_MapRGB( DXCancel.format, 0, 255, 255 ) );

    DXLeftArrow := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'leftarrow.bmp' ) );
    SDL_SetColorKey( DXLeftArrow, Flags, SDL_MapRGB( DXLeftArrow.format, 0, 255, 255  ) );

    DXRightArrow := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + 'rightarrow.bmp' ) );
    SDL_SetColorKey( DXRightArrow, Flags, SDL_MapRGB( DXRightArrow.format, 0, 255, 255 ) );

    DXPickList := SDL_LoadBMP( PChar( SoASettings.InterfacePath + '/' + SoASettings.LanguagePath + '/' + 'chaChooseBox.bmp' ) );
    SDL_SetColorKey( DXPickList, Flags, SDL_MapRGB( DXBack.format, 0, 255, 255 ) );

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
    LoadBaseValues;
    //ShowStats;
    //DrawTheGuy;

    RenderMode := rmNormal;
  except
    on E: Exception do
      Log.LogError( E.Message, FailName );
  end;
end;

procedure TNewGame.MouseDown( Button : Integer; Shift : TSDLMod; CurrentPos : TPoint );
const
  FailName : string = 'TNewGame.MouseDown';
var
  x : integer;
  CharacterName : string;
begin
  inherited;
  try
    case RenderMode of
      rmNormal :
      begin
        MouseOverOptions := moNone;
        if PointIsInRect( CurrentPos, ContinueRect.x, ContinueRect.y, ContinueRect.x + ContinueRect.w, ContinueRect.y + ContinueRect.h ) then
        begin
          // Check to see we have all data before starting the new game
          NextGameInterface := TMainMenu;
          MainWindow.Rendering := false;
        end
        else if PointIsInRect( CurrentPos, CancelRect.x, CancelRect.y, CancelRect.x + CancelRect.w, CancelRect.y + CancelRect.h ) then
        begin
          NextGameInterface := TMainMenu;
          MainWindow.Rendering := false;
        end
        else if PointIsInRect( CurrentPos, LeftArrowRect.x, LeftArrowRect.y, LeftArrowRect.x + LeftArrowRect.w, LeftArrowRect.y + LeftArrowRect.h ) then
          MouseOverOptions := moLeftArrow
        else if PointIsInRect( CurrentPos, RightArrowRect.x, RightArrowRect.y, RightArrowRect.x + RightArrowRect.w, RightArrowRect.y + RightArrowRect.h ) then
          MouseOverOptions := moRightArrow
        else
        begin
          for x := Low( ArrowRect ) to High( ArrowRect ) do
          begin
            if PointIsInRect( CurrentPos, ArrowRect[ x ].FRect.x, ArrowRect[ x ].FRect.y, ArrowRect[ x ].FRect.x + ArrowRect[ x ].FRect.w, ArrowRect[ x ].FRect.y + ArrowRect[ x ].FRect.h ) then
            begin
              MouseOverOptions := TMouseOverNewOptions( x + 18 );
              exit;
            end;
          end;

          for x := Low( InfoRect ) to High( InfoRect ) do
          begin
            if PointIsInRect( CurrentPos, InfoRect[ x ].FRect.x, InfoRect[ x ].FRect.y, InfoRect[ x ].FRect.x + InfoRect[ x ].FRect.w, InfoRect[ x ].FRect.y + InfoRect[ x ].FRect.h ) then
            begin
              MouseOverOptions := TMouseOverNewOptions( x );
              case MouseOverOptions of
                moCharacterName :
                begin
                  CharacterName := Player.Name;
                  DXPlayerName := GameFont.Input( MainWindow.DisplaySurface, InfoRect[ Ord( moCharacterName ) ].FRect.x + 2, InfoRect[ Ord( moCharacterName ) ].FRect.y + 2, InfoRect[ Ord( moCharacterName ) ].FRect.w - 24, InfoRect[ Ord( moCharacterName ) ].FRect.h - 3, CharacterName );
                  Player.Name := CharacterName;
                end;

                moShirtColour :
                begin
                  RenderMode := rmPickList;
                  iPickListLow := 0;
                  iPickListHigh := 3;
                end;

                moPantsColour :
                begin
                  RenderMode := rmPickList;
                  iPickListLow := 4;
                  iPickListHigh := 7;
                end;

                moHairColour :
                begin
                  RenderMode := rmPickList;
                  iPickListLow := 8;
                  iPickListHigh := 11;
                end;

                moHairStyle :
                begin
                  RenderMode := rmPickList;
                  iPickListLow := 12;
                  iPickListHigh := 15;
                end;

                moBeard :
                begin
                  RenderMode := rmPickList;
                  iPickListLow := 16;
                  iPickListHigh := 17;
                end;

                moTrainingStyle :
                begin
                  RenderMode := rmPickList;
                  iPickListLow := 18;
                  iPickListHigh := 20;
                end;
              end;
              exit;
            end;
          end;
        end;
      end;

      rmPickList :
      begin
        case MouseOverOptions of
          moTrainingStyle :
          begin
            for x := iPickListLow to iPickListHigh do
            begin
              if PointIsInRect( CurrentPos, SelectRect[ x ].FRect.x, SelectRect[ x ].FRect.y, SelectRect[ x ].FRect.x + SelectRect[ x ].FRect.w, SelectRect[ x ].FRect.y + SelectRect[ x ].FRect.h ) then
              begin
                ixSelectedTraining := x;
                break;
              end;
            end;
          end;
          
          moShirtColour :
          begin
            for x := iPickListLow to iPickListHigh do
            begin
              if PointIsInRect( CurrentPos, SelectRect[ x ].FRect.x, SelectRect[ x ].FRect.y, SelectRect[ x ].FRect.x + SelectRect[ x ].FRect.w, SelectRect[ x ].FRect.y + SelectRect[ x ].FRect.h ) then
              begin
                ixSelectedShirt := x;
                break;
              end;
            end;
          end;

          moPantsColour :
          begin
            for x := iPickListLow to iPickListHigh do
            begin
              if PointIsInRect( CurrentPos, SelectRect[ x ].FRect.x, SelectRect[ x ].FRect.y, SelectRect[ x ].FRect.x + SelectRect[ x ].FRect.w, SelectRect[ x ].FRect.y + SelectRect[ x ].FRect.h ) then
              begin
                ixSelectedPants := x;
                break;
              end;
            end;
          end;

          moHairColour :
          begin
            for x := iPickListLow to iPickListHigh do
            begin
              if PointIsInRect( CurrentPos, SelectRect[ x ].FRect.x, SelectRect[ x ].FRect.y, SelectRect[ x ].FRect.x + SelectRect[ x ].FRect.w, SelectRect[ x ].FRect.y + SelectRect[ x ].FRect.h ) then
              begin
                ixSelectedHair := x;
                break;
              end;
            end;
          end;

          moHairStyle :
          begin
            for x := iPickListLow to iPickListHigh do
            begin
              if PointIsInRect( CurrentPos, SelectRect[ x ].FRect.x, SelectRect[ x ].FRect.y, SelectRect[ x ].FRect.x + SelectRect[ x ].FRect.w, SelectRect[ x ].FRect.y + SelectRect[ x ].FRect.h ) then
              begin
                ixSelectedHairStyle := x;
                break;
              end;
            end;
          end;

          moBeard :
          begin
            for x := iPickListLow to iPickListHigh do
            begin
              if PointIsInRect( CurrentPos, SelectRect[ x ].FRect.x, SelectRect[ x ].FRect.y, SelectRect[ x ].FRect.x + SelectRect[ x ].FRect.w, SelectRect[ x ].FRect.y + SelectRect[ x ].FRect.h ) then
              begin
                ixSelectedBeard := x;
                break;
              end;
            end;
            if PointIsInRect( CurrentPos, SelectRect[ x ].FRect.x, SelectRect[ x ].FRect.y, SelectRect[ x ].FRect.x + SelectRect[ x ].FRect.w, SelectRect[ x ].FRect.y + SelectRect[ x ].FRect.h ) then
            begin
              RenderMode := rmNormal;
            end;
          end;
        else
          RenderMode := rmNormal;
        end;
      end;
    end;
  except
    on E: Exception do
      Log.LogError( E.Message, FailName );
  end;
end;

procedure TNewGame.MouseMove( Shift : TSDLMod; CurrentPos, RelativePos : TPoint );
const
  FailName : string = 'TNewGame.MouseMove';
var
  x : integer;
begin
  inherited;
  try
    case RenderMode of
      rmNormal :
      begin
        MouseOverOptions := moNone;
        if PointIsInRect( CurrentPos, ContinueRect.x, ContinueRect.y, ContinueRect.x + ContinueRect.w, ContinueRect.y + ContinueRect.h ) then
          MouseOverOptions := moContinue
        else if PointIsInRect( CurrentPos, CancelRect.x, CancelRect.y, CancelRect.x + CancelRect.w, CancelRect.y + CancelRect.h ) then
          MouseOverOptions := moCancel
        else if PointIsInRect( CurrentPos, LeftArrowRect.x, LeftArrowRect.y, LeftArrowRect.x + LeftArrowRect.w, LeftArrowRect.y + LeftArrowRect.h ) then
          MouseOverOptions := moLeftArrow
        else if PointIsInRect( CurrentPos, RightArrowRect.x, RightArrowRect.y, RightArrowRect.x + RightArrowRect.w, RightArrowRect.y + RightArrowRect.h ) then
          MouseOverOptions := moRightArrow
        else
        begin
          for x := Low( ArrowRect ) to High( ArrowRect ) do
          begin
            if PointIsInRect( CurrentPos, ArrowRect[ x ].FRect.x, ArrowRect[ x ].FRect.y, ArrowRect[ x ].FRect.x + ArrowRect[ x ].FRect.w, ArrowRect[ x ].FRect.y + ArrowRect[ x ].FRect.h ) then
            begin
              MouseOverOptions := TMouseOverNewOptions( x + 18 );
              exit;
            end;
          end;

          for x := Low( InfoRect ) to High( InfoRect ) do
          begin
            if PointIsInRect( CurrentPos, InfoRect[ x ].FRect.x, InfoRect[ x ].FRect.y, InfoRect[ x ].FRect.x + InfoRect[ x ].FRect.w, InfoRect[ x ].FRect.y + InfoRect[ x ].FRect.h ) then
            begin
              MouseOverOptions := TMouseOverNewOptions( x );
              exit;
            end;
          end;
        end;
      end;

      rmPickList :
      begin
      
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
var
  x : integer;
  lRect : TSDL_Rect;
begin
  inherited;
  try
    case RenderMode of
      rmNormal :
      begin
        case MouseOverOptions of
          moTrainingPoints..moTrainingStyle :
          begin
            SDL_BlitSurface( InfoRect[ Ord( MouseOverOptions ) ].FInfo, nil, MainWindow.DisplaySurface, @InfoPanel );
          end;

          moContinue :
            begin
              SDL_BlitSurface( DXContinue, nil, MainWindow.DisplaySurface, @ContinueRect );
            end;

          moCancel :
            begin
              SDL_BlitSurface( DXCancel, nil, MainWindow.DisplaySurface, @CancelRect );
            end;

          moStrengthMinus..moStealthPlus :
            SDL_BlitSurface( ArrowRect[ Ord( MouseOverOptions ) - 18 ].FInfo, nil, MainWindow.DisplaySurface, @InfoPanel );
        end;
      end;

      rmPickList :
      begin
        case MouseOverOptions of
          moShirtColour :
          begin
            lRect.x := 280;
            lRect.y := 239;
            lRect.w := DXPickList.w;
            lRect.h := DXPickList.h;
          end;

          moPantsColour :
          begin
            lRect.x := 280;
            lRect.y := 281;
            lRect.w := DXPickList.w;
            lRect.h := DXPickList.h;
          end;

          moHairColour :
          begin
            lRect.x := 280;
            lRect.y := 323;
            lRect.w := DXPickList.w;
            lRect.h := DXPickList.h;
          end;

          moHairStyle :
          begin
            lRect.x := 280;
            lRect.y := 365;
            lRect.w := DXPickList.w;
            lRect.h := DXPickList.h;
          end;

          moBeard :
          begin
            lRect.x := 280;
            lRect.y := 409;
            lRect.w := DXPickList.w;
            lRect.h := DXPickList.h;
          end;

          moTrainingStyle :
          begin
            lRect.x := 467;
            lRect.y := 134;
            lRect.w := DXPickList.w;
            lRect.h := DXPickList.h;
          end;
        else
          begin
            iPickListLow := 0;
            iPickListHigh := 3;
            lRect.x := 25;
            lRect.y := 25;
            lRect.w := DXPickList.w;
            lRect.h := DXPickList.h;
          end
        end;

        SDL_BlitSurface( DXPickList, nil, MainWindow.DisplaySurface, @lRect );

        for x := iPickListLow to iPickListHigh do
        begin
          SDL_BlitSurface( SelectRect[ x ].FText, nil, MainWindow.DisplaySurface, @SelectRect[ x ].FRect );
        end;
      end;
    end;

    lRect := InfoRect[ Ord( moShirtColour ) ].FRect;
    lRect.x := lRect.x + 2;
    lRect.y := lRect.y + 2;
    lRect.w := lRect.w - 24;
    lRect.h := lRect.h - 3;
    SDL_FillRect( MainWindow.DisplaySurface, @lRect, SDL_MapRGB( MainWindow.DisplaySurface.format, 0, 0, 0 ) );
    SDL_BlitSurface( SelectRect[ ixSelectedShirt ].FText, nil, MainWindow.DisplaySurface, @lRect );

    lRect := InfoRect[ Ord( moPantsColour ) ].FRect;
    lRect.x := lRect.x + 2;
    lRect.y := lRect.y + 2;
    lRect.w := lRect.w - 24;
    lRect.h := lRect.h - 3;
    SDL_FillRect( MainWindow.DisplaySurface, @lRect, SDL_MapRGB( MainWindow.DisplaySurface.format, 0, 0, 0 ) );
    SDL_BlitSurface( SelectRect[ ixSelectedPants ].FText, nil, MainWindow.DisplaySurface, @lRect );

    lRect := InfoRect[ Ord( moHairColour ) ].FRect;
    lRect.x := lRect.x + 2;
    lRect.y := lRect.y + 2;
    lRect.w := lRect.w - 24;
    lRect.h := lRect.h - 3;
    SDL_FillRect( MainWindow.DisplaySurface, @lRect, SDL_MapRGB( MainWindow.DisplaySurface.format, 0, 0, 0 ) );
    SDL_BlitSurface( SelectRect[ ixSelectedHair ].FText, nil, MainWindow.DisplaySurface, @lRect );

    lRect := InfoRect[ Ord( moHairStyle ) ].FRect;
    lRect.x := lRect.x + 2;
    lRect.y := lRect.y + 2;
    lRect.w := lRect.w - 24;
    lRect.h := lRect.h - 3;
    SDL_FillRect( MainWindow.DisplaySurface, @lRect, SDL_MapRGB( MainWindow.DisplaySurface.format, 0, 0, 0 ) );
    SDL_BlitSurface( SelectRect[ ixSelectedHairStyle ].FText, nil, MainWindow.DisplaySurface, @lRect );

    lRect := InfoRect[ Ord( moBeard ) ].FRect;
    lRect.x := lRect.x + 2;
    lRect.y := lRect.y + 2;
    lRect.w := lRect.w - 24;
    lRect.h := lRect.h - 3;
    SDL_FillRect( MainWindow.DisplaySurface, @lRect, SDL_MapRGB( MainWindow.DisplaySurface.format, 0, 0, 0 ) );
    SDL_BlitSurface( SelectRect[ ixSelectedBeard ].FText, nil, MainWindow.DisplaySurface, @lRect );

    lRect := InfoRect[ Ord( moTrainingStyle ) ].FRect;
    lRect.x := lRect.x + 2;
    lRect.y := lRect.y + 2;
    lRect.w := lRect.w - 24;
    lRect.h := lRect.h - 3;
    SDL_FillRect( MainWindow.DisplaySurface, @lRect, SDL_MapRGB( MainWindow.DisplaySurface.format, 0, 0, 0 ) );
    SDL_BlitSurface( SelectRect[ ixSelectedTraining ].FText, nil, MainWindow.DisplaySurface, @lRect );

    if Player.Name <> '' then
    begin
      lRect := InfoRect[ Ord( moCharacterName ) ].FRect;
      lRect.x := lRect.x + 2;
      lRect.y := lRect.y + 2;
      lRect.w := lRect.w - 24;
      lRect.h := lRect.h - 3;
      SDL_BlitSurface( DXPlayerName, nil, MainWindow.DisplaySurface, @lRect );
    end;

    SDL_BlitSurface( DXLeftArrow, nil, MainWindow.DisplaySurface, @LeftArrowRect );
    SDL_BlitSurface( DXRightArrow, nil, MainWindow.DisplaySurface, @RightArrowRect );
  except
    on E: Exception do
      Log.LogError( E.Message, FailName );
  end;
end;

{ TCharacter }

constructor TCharacter.Create;
begin
  inherited;
  BaseStrength := 7;
  BaseCoordination := 7;
  BaseConstitution := 7;
  BaseMysticism := 5;
  BaseCombat := 5;
  BaseStealth := 5;
  BasePerception := 10;
  BaseCharm := 10;
  BaseHealingRate := 10;
  BaseRechargeRate := 10;
  BaseHitPoints := 20;
  BaseMana := 10;
  BaseAttackRecovery := 12;
  BaseHitRecovery := 0;
  TrainingPoints := 0;
end;

end.

