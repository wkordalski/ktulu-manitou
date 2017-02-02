module State exposing (..)

import Color exposing (Color)

import Character exposing (Character, CharacterContainer)
import Game exposing (Player, GameState)
import Faction exposing (Faction)

type alias GameSettingsData = {
    playersNo : Int,

    contAccept : (GameState -> State -> State),
    contCancel : (State -> State),

    gettingPlayers : Bool,
    players : List Character,
    characters : CharacterContainer
  }

type State
  = Start
  | PlayerChoosing
    {
      original : State,
      choices : List Player,
      firstDigit : Maybe Int,
      secondDigit : Maybe Int,
      continuation : Maybe Player -> State -> State,
      title : String,
      cancelEnabled : Bool,
      parent : State
    }
  | Message -- text. and buttons horizontally, maby in few rows? (needs: styling)
    {
      text : String,
      buttons : List (String, Color, (State->State)),
      parent : State
    }
  | Menu -- text, and buttons vertically below
    {
      text : String,
      buttons : List (String, Color, (State->State)),
      parent : State
    }
  | CharacterDialog
    {
      text : String,
      characterDescriptor : Character -> String,
      characters : List Character,
      contAccept : Character -> State -> State,
      contCancel : Maybe (State -> State),
      faction : Maybe Faction,
      character : Maybe Character,
      parent : State
    }
  | GameSettings GameSettingsData
  | PlayerSettings GameSettingsData
  | Error String
  | Game GameState
  | Won Faction

gameState state =
  case state of
    Game g -> Just g
    Menu {parent} -> gameState parent
    Message {parent} -> gameState parent
    CharacterDialog {parent} -> gameState parent
    _ -> Nothing
