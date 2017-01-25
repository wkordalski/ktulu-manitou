module Menu exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Messages exposing (Msg)
import State
import Settings

view =
  div []
  [ h2 [] [text "Witaj w menu głównym!"]
  , button [onClick Messages.ShowGameSettings] [text "Rozpocznij nową grę"]
  ]

update msg =
  case msg of
    Messages.ShowGameSettings -> (State.GameSettings Settings.init, Cmd.none)
    _ -> (State.Error "Invalid message!", Cmd.none)
