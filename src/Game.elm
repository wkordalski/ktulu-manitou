module Game exposing (..)

import Character exposing (Character, CharacterContainer)

type alias Player = Int

type alias GameState =
  {
    players : List Character,
    characters : CharacterContainer,
    playersNo : Int
  }
