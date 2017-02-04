module Program exposing (..)

import Color exposing (Color)
import Dialogs exposing (..)

import State exposing (State)
import Game as G
import Settings exposing (settings)
import Rules

import Actions
import Character exposing (Character)
import Faction exposing (Faction)
import Html exposing (Html)
import Utils exposing (nth)
import Messages exposing (Msg)

error text = \s -> State.Error text

maybePlayerName : Int -> G.State -> String
maybePlayerName p s =
  case nth s.players p of
    Just ch -> Character.name ch
    Nothing -> "Brak postaci"

program : () -> State
program =
  \s -> menu (State.Start) (Html.text "Hello in my game :)")
    [ (Html.text "Play the game",
        settings (State.Start) (
              Rules.all (\f -> Actions.won f program))
              program)
    , (Html.text "About authors",
        message (State.Start) (Html.text "Me and you") [(Html.text "OK", program)])] s
