module Dialogs exposing (..)

import State exposing (State)
import Color exposing (Color)
import Character exposing (Character)
import Game exposing (Player)

-- Należy wykonać zwracaną wartość (State → State) by pokazać okno
{-
playerChooser : List Player -> String -> Bool -> (Maybe Player -> State -> State) -> (State -> State)
playerChooser choices title cancelEnabled cont =
  \s -> PlayerChoosing {
    original = s,
    continuation = cont,
    firstDigit = Nothing,
    secondDigit = Nothing,
    choices = players,
    title = title,
    cancelEnabled = cancelEnabled
  }
-}

message : String -> List (String, Color, (State->State)) -> (State -> State)
message text buttons =
  \s -> State.Message {
    text = text,
    buttons = buttons,
    parent = s
  }

menu : String -> List (String, Color, (State->State)) -> (State -> State)
menu text buttons =
  \s -> State.Menu {
    text = text,
    buttons = buttons,
    parent = s
  }

character : String -> (Character -> State -> (String, Bool)) -> List Character -> (Character -> State -> State) -> Maybe (State -> State) -> (State -> State)
character text characterDescriptor characters accept cancel =
  \s -> State.CharacterDialog {
    text = text,
    characterDescriptor = characterDescriptor,
    characters = characters,
    contAccept = accept,
    contCancel = cancel,
    faction = Nothing,
    character = Nothing,
    parent = s
  }

player : String -> (Player -> State -> (String, Bool)) -> List Player -> (Player -> State -> State) -> Maybe (State -> State) -> (State -> State)
player text playerDescriptor players accept cancel =
  \s -> State.PlayerDialog {
    text = text,
    playerDescriptor = playerDescriptor,
    players = players,
    contAccept = accept,
    contCancel = cancel,
    digit1 = Nothing,
    digit2 = Nothing,
    parent = s
  }
