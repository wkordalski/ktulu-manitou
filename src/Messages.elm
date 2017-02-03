module Messages exposing (..)

import Character exposing (Character)
import Faction exposing (Faction)

type Msg
  -- UNDO SUPPORT --
  = Undo | DropHistory
  -- GAME SETTINGS --
  | ShowGameSettings
  | GameSettingsPlayersCount String
  | GameSettingsSetPlayers
  -- MENU & MESSAGE DIALOG --
  | CommandClicked Int
  -- CHOOSE CHARACTER DIALOG --
  | CharacterDialogOKButton
  | CharacterDialogBackButton
  | CharacterDialogSetFaction Faction
  | CharacterDialogSetCharacter Character
  -- CHOOSE PLAYER DIALOG --
  | PlayerDialogOKButton
  | PlayerDialogBackButton
  | PlayerDialogSetDigit1 Int
  | PlayerDialogSetDigit2 Int
