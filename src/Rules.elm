module Rules exposing (..)

import Dialogs

night0 : (Faction -> GState -> State) -> (GState -> State) -> (GState -> State)
night0 win cont =
  cont -- TODO

night : (Faction -> GState -> State) -> (GState -> State) -> (GState -> State)
night win cont =
  cont -- TODO

day : (Faction -> GState -> State) -> (GState -> State) -> (GState -> State)
day win cont =
  Dialogs.message (Html.text "Czy miasto chce wygrać?")
    [ (Html.text "Tak", win Faction.Citizen)
    , (Html.text "Nie", cont)]

daynight : (Faction -> GState -> State) -> (GState -> State)
daynight win =
  \s -> (day win <| night win <| daynight win) s



hooker cont =
  let chooseClient =
    Dialogs.player (Html.text "Wybiera klienta")
      (\p -> \s -> (Character.name (nth s.players)))
  Dialogs.message (Html.text "Budzi się kurtyzana")
    [(Html.text "OK")]
