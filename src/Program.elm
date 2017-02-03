module Program exposing (..)

import Color exposing (Color)
import Dialogs exposing (..)

import State exposing (State)
import Settings exposing (settings)

import Html exposing (Html)

error text = \s -> State.Error text

program : State -> State
program =
  \s -> menu (Html.text "Hello in my game :)")
    [ (Html.text "Play the game", Color.black,
        settings (\gs -> player (Html.text "Some text") (\p -> \s -> (Html.text <| Basics.toString p, p%2==1)) [1,2,3] (\p -> error "Chosen") Nothing) program)
    , (Html.text "About authors", Color.green,
        message (Html.text "Me and you") [(Html.text "OK", Color.red, program)])] s
