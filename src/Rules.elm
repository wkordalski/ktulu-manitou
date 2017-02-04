module Rules exposing (all)

import Character
import GameDialogs as Dialogs
import State exposing (State)
import Game as G
import StateUtils
import Utils exposing (nth)

import Html
import Faction exposing (Faction)

night0 : (Faction -> G.State -> State) -> (G.State -> State) -> (G.State -> State)
night0 win cont =
  hooker <| cont

night : (Faction -> G.State -> State) -> (G.State -> State) -> (G.State -> State)
night win cont =
  cont -- TODO

day : (Faction -> G.State -> State) -> (G.State -> State) -> (G.State -> State)
day win cont =
  Dialogs.message (Html.text "Czy miasto chce wygrać?")
    [ (Html.text "Tak", win Faction.Citizen)
    , (Html.text "Nie", cont)]

daynight : (Faction -> G.State -> State) -> (G.State -> State)
daynight win =
  \s -> (day win <| night win <| daynight win) s

all : (Faction -> G.State -> State) -> (G.State -> State)
all win =
  night0 win <| daynight win

hooker : (G.State -> State) -> (G.State -> State)
hooker cont s =
  let meet player = -- : G.Player -> G.State -> State
    Dialogs.message (Html.text "Spotkała") [(Html.text "OK", cont)]
  in
  let chooseClient =
    Dialogs.player (Html.text "Wybiera klienta") (\p -> \s -> (StateUtils.displayPlayer s p, True)) (\s -> List.range 0 (s.playersNo - 1)) meet (Just (hooker cont))
  in
  Dialogs.message (Html.text "Budzi się kurtyzana")
    [(Html.text "OK", chooseClient)] s
