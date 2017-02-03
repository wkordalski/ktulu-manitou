module Program exposing (..)

import Color exposing (Color)
import Dialogs exposing (..)

import State exposing (State)
import Settings exposing (settings)

error text = \s -> State.Error text

program : State -> State
program =
  \s -> menu "Hello in my game :)"
    [ ("Play the game", Color.black,
        settings (\gs -> player "Some text" (\p -> \s -> (Basics.toString p, p%2==1)) [1,2,3] (\p -> error "Chosen") Nothing) program)
    , ("About authors", Color.green,
        message "Me and you" [("OK", Color.red, program)])] s
