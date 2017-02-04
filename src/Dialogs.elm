module Dialogs exposing (..)

import State exposing (State, DialogState)
import Color exposing (Color)
import Character exposing (Character)
import Game exposing (Player)
import Messages exposing (Msg)

import Html exposing (Html)

-- Należy wykonać zwracaną wartość (State → State) by pokazać okno

message : (DialogState data -> State) -> Html Msg -> List (Html Msg, (data->State)) -> (data->State)
message ctor text buttons =
  \s -> ctor (State.MessageDialog {
    text = text,
    buttons = buttons,
    data = s
  })

menu : (DialogState data -> State) -> Html Msg -> List (Html Msg, (data->State)) -> (data->State)
menu ctor text buttons =
  \s -> ctor (State.MenuDialog {
    text = text,
    buttons = buttons,
    data = s
  })

character : (DialogState data -> State) -> Html Msg -> (Character->data->(Html Msg, Bool)) -> (data->List Character) -> (Character->data->State) -> Maybe (data->State) -> (data->State)
character ctor text characterDescriptor characters accept cancel =
  \s -> ctor (State.CharacterDialog {
    text = text,
    characterDescriptor = characterDescriptor,
    characters = characters s,
    contAccept = accept,
    contCancel = cancel,
    faction = Nothing,
    character = Nothing,
    data = s
  })

player : (DialogState data -> State) -> Html Msg -> (Player->data->(Html Msg, Bool)) -> (data->List Player) -> (Player->data->State) -> Maybe (data->State) -> (data->State)
player ctor text playerDescriptor players accept cancel =
  \s -> ctor (State.PlayerDialog {
    text = text,
    playerDescriptor = playerDescriptor,
    players = players s,
    contAccept = accept,
    contCancel = cancel,
    digit1 = Nothing,
    digit2 = Nothing,
    data = s
  })
