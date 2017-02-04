module Actions exposing (..)

import Faction exposing (Faction)
import Game as G

import State exposing (State)
import Dialogs

import Html


won : Faction -> (() -> State) -> (G.State -> State)
won fac cont =
  Dialogs.message (State.Game) (Html.text ("Wygrała frakcja: " ++ (Faction.name fac)))
    [ (Html.text "OK", \gs -> cont ()) ]

-- TODO: Here should be things like killing, drunking, etc.
