module Program exposing (..)

import Color exposing (Color)
import Dialogs exposing (..)

import State exposing (State)
import Settings exposing (settings)

import Character exposing (Character)
import Html exposing (Html)
import Utils exposing (nth)
import Messages exposing (Msg)

error text = \s -> State.Error text

maybePlayerName : Int -> State -> String
maybePlayerName p s =
  let s2 = State.gameState s in
  case s2 of
    Just s3 ->
      case nth s3.players p of
        Just ch -> Character.name ch
        Nothing -> "Brak postaci"
    Nothing -> "Brak gry"

playersOfState s =
  case State.gameState s of
    Just ss -> List.range 0 (ss.playersNo - 1)
    Nothing -> []

program : State -> State
program =
  \s -> menu (Html.text "Hello in my game :)")
    [ (Html.text "Play the game", Color.black,
        settings (\gs -> \s ->
              player
                (Html.text "Some text")
                (\p -> \s -> (Html.text <| maybePlayerName p s, p%2==1))
                (\s -> playersOfState s)
                (\p -> error "Chosen")
                Nothing (State.Game gs))
              program)
    , (Html.text "About authors", Color.green,
        message (Html.text "Me and you") [(Html.text "OK", Color.red, program)])] s
