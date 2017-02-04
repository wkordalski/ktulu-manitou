module GameDialogs exposing (..)

import Dialogs
import Game as G
import State exposing (State (Game))

-- Należy wykonać zwracaną wartość (State → State) by pokazać okno

message : Html Msg -> List (Html Msg, (G.State->State)) -> (G.State->State)
message =
  Dialogs.message Game

menu : Html Msg -> List (Html Msg, (G.State->State)) -> (G.State->State)
menu =
  Dialogs.menu Game

character : Html Msg -> (Character->G.State->(Html Msg, Bool)) -> (G.State->List Character) -> (Character->G.State->State) -> Maybe (G.State->State) -> (G.State->State)
character =
  Dialogs.character Game

player : Html Msg -> (Player->G.State->(Html Msg, Bool)) -> (G.State->List Player) -> (Player->G.State->State) -> Maybe (G.State->State) -> (G.State->State)
player =
  Dialogs.player Game
