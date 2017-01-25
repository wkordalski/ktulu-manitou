module State exposing (..)

import Game exposing (Player, GameState)
import Faction exposing (Faction)

type alias GameSettingsData = {
    players : Int
  }

type State
  = PlayerChoosing
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
  | Menu
  | GameSettings GameSettingsData
  | PlayerSettings GameSettingsData
  | Error String
  | Won Faction
