module Settings exposing (..)

import Html exposing (..)
import Html.Attributes as Attrs exposing (..)
import Html.Events exposing (..)

import Messages
import State exposing (State)

import Game exposing (GameState)

init = { players = 12 }

view state =
  let {players} = state
  in
  div []
    [ h2 [] [text "Tutaj są podstawowe ustawienia gry."]
    , input [onInput Messages.GameSettingsPlayersCount, type_ "number", Attrs.min "4", Attrs.max "99", value (toString players)] []
    ]

update msg state =
  case msg of
    Messages.GameSettingsPlayersCount s ->
      case String.toInt s of
        Err _ -> State.Error "Wrong players count!"
        Ok v -> State.GameSettings { state | players = v}
    _ -> State.Error "Wrong message!"

isValid settings =
  True

{-
Usually cont will be something like this:
cont gameState =
  \s -> (some <| chained <| actions) (State.GameState gameState)
-}
{-
settings : (GameState -> State -> State) -> (State -> State)
settings cont =
  \s -> State.GameSettings {
    players = 12,
    continuation = cont
  }
-}
