module DialogViews exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Color.Convert exposing (colorToHex)

import Messages exposing (Msg)
import State exposing (State)

import Utils exposing (nth)

buttonFromDescription (text, color, cont) id =
  button
    [style [("color", colorToHex color)]
    , onClick (Messages.CommandClicked id)]
    [Html.text text]

updateMessage msg {text, buttons, parent} =
  case msg of
    Messages.CommandClicked i ->
        case nth buttons i of
          Nothing -> State.Error "Invalid button ID!!!"
          Just (text, color, cont) -> cont parent
    _ -> State.Error "Invalid message"

viewMessage {text, buttons, parent} =
  div []
  ( (h2 [] [Html.text text]) ::
  (List.indexedMap (\i d -> buttonFromDescription d i) buttons) )

updateMenu msg {text, buttons, parent} =
  case msg of
    Messages.CommandClicked i ->
        case nth buttons i of
          Nothing -> State.Error "Invalid button ID!!!"
          Just (text, color, cont) -> cont parent
    _ -> State.Error "Invalid message"

-- TODO: more styling - options one above another
viewMenu {text, buttons, parent} =
  div []
  ( (h2 [] [Html.text text]) ::
  (List.indexedMap (\i d -> buttonFromDescription d i) buttons) )
