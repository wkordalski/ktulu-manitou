module Program exposing (..)

import Color exposing (Color)
import Dialogs exposing (..)

import State exposing (State)

error text = \s -> State.Error text

program : State -> State
program =
  \s -> menu "Hello in my game :)"
    [ ("Play the game", Color.black,
        message "Not implemented" [("OK", Color.red, program)])
    , ("About authors", Color.green,
        message "Me and you" [("OK", Color.red, program)])] s
