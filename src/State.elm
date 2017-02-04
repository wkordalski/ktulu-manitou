module State exposing (..)

import Color exposing (Color)

import Character exposing (Character, CharacterContainer)
import Game as G exposing (Player)
import Faction exposing (Faction)

import Html exposing (Html)
import Messages exposing (Msg)

type alias GameSettingsData = {
    playersNo : Int,

    contAccept : (G.State -> State),
    contCancel : (() -> State),

    gettingPlayers : Bool,
    players : List Character,
    characters : CharacterContainer
  }

type State
  = Start (DialogState ())
  | Settings (DialogState GameSettingsData)
  | Game (DialogState G.State)
  | Error String

type DialogState data
  = MessageDialog -- text. and buttons horizontally, maby in few rows? (needs: styling)
    {
      text : Html Msg,
      buttons : List (Html Msg, (data->State)),
      data : data
    }
  | MenuDialog -- text, and buttons vertically below
    {
      text : Html Msg,
      buttons : List (Html Msg, (data->State)),
      data : data
    }
  | CharacterDialog
    {
      text : Html Msg,
      characterDescriptor : Character -> data -> (Html Msg, Bool),
      characters : List Character,
      contAccept : Character -> data -> State,
      contCancel : Maybe (data -> State),
      faction : Maybe Faction,
      character : Maybe Character,
      data : data
    }
  | PlayerDialog
    {
      text : Html Msg,
      playerDescriptor : Player -> data -> (Html Msg, Bool),
      players : List Player,
      contAccept : Player -> data -> State,
      contCancel : Maybe (data -> State),
      digit1 : Maybe Int,
      digit2 : Maybe Int,
      data : data
    }
  | GameSettings data
