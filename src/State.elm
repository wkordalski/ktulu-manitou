module State exposing (..)

import Color exposing (Color)

import Game exposing (Player, GameState)
import Faction exposing (Faction)

type alias GameSettingsData = {
    players : Int
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
  | GameSettings GameSettingsData
  | PlayerSettings GameSettingsData
  | Error String
  | Won Faction
