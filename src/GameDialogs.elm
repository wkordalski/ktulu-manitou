module GameDialogs exposing (..)

import Dialogs
import State exposing (State (Game))

-- Należy wykonać zwracaną wartość (State → State) by pokazać okno

message =
  Dialogs.message Game

menu =
  Dialogs.menu Game

character =
  Dialogs.character Game

player =
  Dialogs.player Game
