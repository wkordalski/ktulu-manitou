module Settings exposing (..)

import Html exposing (..)
import Html.Attributes as Attrs exposing (..)
import Html.Events exposing (..)

import Messages exposing (Msg)
import State exposing (State, GameSettingsData)

import Dialogs
import Game as G
import Character exposing (Character)

settings : (State.DialogState () -> State) -> (G.State -> State) -> (() -> State) -> (() -> State)
settings ctor accept cancel =
  \s -> State.Settings (State.GameSettings {
    playersNo = 12,
    gettingPlayers = False,
    contAccept = accept,
    contCancel = cancel,
    players = [],
    characters = Character.makeContainer
  })

makeGameState : GameSettingsData -> G.State
makeGameState s =
  {
    players = List.reverse s.players,
    characters = s.characters,
    playersNo = List.length s.players
    -- TODO: other fields
  }

getUnusedCharacters : Int -> GameSettingsData -> List Character
getUnusedCharacters player {characters} =
  let l1 = []
  in let l2 = if characters.hooker == Nothing then (Character.hooker player) :: l1 else l1
  in let l3 = if characters.sheriff == Nothing then (Character.sheriff player) :: l2 else l2
  in l3

chooseCharacterForPlayer : (GameSettingsData -> State) -> (GameSettingsData -> State)
chooseCharacterForPlayer cont =
  \s ->
        let players_cnt = List.length s.players
        in
        Dialogs.character (State.Settings) (Html.text ("Choose player " ++ (Basics.toString players_cnt)))
          (\ch -> \s -> (Html.text <| Character.name ch, True))
          (\s -> getUnusedCharacters players_cnt s)
          (\ch -> \s ->
            cont <| { s | players = ch :: s.players, characters = Character.addCharacterToContainer s.characters ch }
          )
          Nothing s


view state =
  let {playersNo} = state
  in
  div []
    [ h2 [] [text "Tutaj są podstawowe ustawienia gry."]
    , input [onInput Messages.GameSettingsPlayersCount, type_ "number", Attrs.min "1", Attrs.max "99", value (toString playersNo)] []
    , button [onClick Messages.GameSettingsSetPlayers] [text "Accept"]
    ]


update : (State.DialogState GameSettingsData -> State) -> Msg -> GameSettingsData -> State
update ctor msg state =
  case msg of
    Messages.GameSettingsPlayersCount s ->
      case String.toInt s of
        Err _ -> State.Error "Wrong players count!"
        Ok v -> ctor (State.GameSettings { state | playersNo = v })
    Messages.GameSettingsSetPlayers ->
      let {contAccept, contCancel, playersNo} = state in
      (List.foldr (\a -> \b -> chooseCharacterForPlayer <| b)
        (\s -> contAccept (makeGameState s))
        (List.range 0 (playersNo-1))
      )
      state
    _ -> State.Error "Wrong message!"

isValid settings =
  True
