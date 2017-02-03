module State exposing (..)

import Color exposing (Color)

import Character exposing (Character, CharacterContainer)
import Game exposing (Player, GameState)
import Faction exposing (Faction)

import Html exposing (Html)
import Messages exposing (Msg)

type alias GameSettingsData = {
    playersNo : Int,

    contAccept : (GameState -> State -> State),
    contCancel : (State -> State),

    gettingPlayers : Bool,
    players : List Character,
    characters : CharacterContainer
  }

type State
  = Start
  | PlayerChoosing
    {
      original : State,
      choices : List Player,
      firstDigit : Maybe Int,
      secondDigit : Maybe Int,
      continuation : Maybe Player -> State -> State,
      title : String,
      cancelEnabled : Bool,
      parent : State
    }
  | Message -- text. and buttons horizontally, maby in few rows? (needs: styling)
    {
      text : Html Msg,
      buttons : List (Html Msg, Color, (State->State)),
      parent : State
    }
  | Menu -- text, and buttons vertically below
    {
      text : Html Msg,
      buttons : List (Html Msg, Color, (State->State)),
      parent : State
    }
  | CharacterDialog
    {
      text : Html Msg,
      characterDescriptor : Character -> State -> (Html Msg, Bool),
      characters : List Character,
      contAccept : Character -> State -> State,
      contCancel : Maybe (State -> State),
      faction : Maybe Faction,
      character : Maybe Character,
      parent : State
    }
  | PlayerDialog
    {
      text : Html Msg,
      playerDescriptor : Player -> State -> (Html Msg, Bool),
      players : List Player,
      contAccept : Player -> Action,
      contCancel : Maybe Action,
      digit1 : Maybe Int,
      digit2 : Maybe Int,
      parent : State
    }
  | GameSettings GameSettingsData
  | PlayerSettings GameSettingsData
  | Error String
  | Game GameState
  | Won Faction

type alias Action = State -> State

gameState state =
  case state of
    Game g -> Just g
    Menu {parent} -> gameState parent
    Message {parent} -> gameState parent
    CharacterDialog {parent} -> gameState parent
    _ -> Nothing
