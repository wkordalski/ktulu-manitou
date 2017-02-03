module Settings exposing (..)

import Html exposing (..)
import Html.Attributes as Attrs exposing (..)
import Html.Events exposing (..)

import Messages
import State exposing (State)

import Dialogs
import Game exposing (GameState)
import Character exposing (Character)

settings : (GameState -> State -> State) -> (State -> State) -> (State -> State)
settings accept cancel =
  \s -> State.GameSettings {
    playersNo = 12,
    gettingPlayers = False,
    contAccept = accept,
    contCancel = cancel,
    players = [],
    characters = Character.makeContainer
  }

makeGameState : State -> Result () GameState
makeGameState state =
  case state of
    State.GameSettings s ->
      Ok {
        players = List.reverse s.players,
        characters = s.characters,
        playersNo = List.length s.players
        -- TODO: other fields
      }
    _ -> Err ()

getUnusedCharacters : Int -> State.GameSettingsData -> List Character
getUnusedCharacters player {characters} =
  let l1 = []
  in let l2 = if characters.hooker == Nothing then (Character.hooker player) :: l1 else l1
  in let l3 = if characters.sheriff == Nothing then (Character.sheriff player) :: l2 else l2
  in l3

chooseCharacterForPlayer cont =
  \s ->
    case s of
      State.GameSettings data ->
        let players_cnt = List.length data.players
        in
        Dialogs.character (Html.text ("Choose player " ++ (Basics.toString players_cnt)))
          (\ch -> \s -> (Html.text <| Character.name ch, True))
          (\s -> getUnusedCharacters players_cnt data)
          (\ch -> \s ->
            case s of
              State.GameSettings st -> cont <| State.GameSettings { st | players = ch :: st.players, characters = Character.addCharacterToContainer st.characters ch }
              _ -> State.Error "Wrong state..."
          )
          Nothing s
      _ -> State.Error "Wrong state..."

view state =
  let {playersNo} = state
  in
  div []
    [ h2 [] [text "Tutaj są podstawowe ustawienia gry."]
    , input [onInput Messages.GameSettingsPlayersCount, type_ "number", Attrs.min "1", Attrs.max "99", value (toString playersNo)] []
    , button [onClick Messages.GameSettingsSetPlayers] [text "Accept"]
    ]


update msg state =
  case msg of
    Messages.GameSettingsPlayersCount s ->
      case String.toInt s of
        Err _ -> State.Error "Wrong players count!"
        Ok v -> State.GameSettings { state | playersNo = v }
    Messages.GameSettingsSetPlayers ->
      let {contAccept, contCancel, playersNo} = state in
      (List.foldr (\a -> \b -> chooseCharacterForPlayer <| b)
        (\s ->
          case makeGameState s of
            Ok gs -> contAccept gs s
            Err () -> contCancel s
        )
        (List.range 0 (playersNo-1))
      )
      (State.GameSettings state)
    _ -> State.Error "Wrong message!"

isValid settings =
  True
