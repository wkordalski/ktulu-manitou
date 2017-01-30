module Dialogs exposing (..)

import State exposing (State)
import Color exposing (Color)

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
  \s -> State.Message {
    text = text,
    buttons = buttons,
    parent = s
  }
