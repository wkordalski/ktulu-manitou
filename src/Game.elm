module Game exposing (..)

import Character exposing (Character, CharacterContainer)

type alias Player = Int

type alias State =
  {
    players : List Character,
    characters : CharacterContainer,
    playersNo : Int
  }
