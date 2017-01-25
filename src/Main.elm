{-
Players: {0, ..., n-1} -> character detail
Characters: {name -> Mayby player}
-- Character { id -> player, (other options...)}
Some options of game (ship arrival, who has statuette {Maby player}, who owns statuette {Maby player})
-}

import Html exposing (..)

import Settings
import Messages exposing (Msg)

import Menu

import State exposing (State)

main = Html.program {
    init = init,
    view = view,
    update = update,
    subscriptions = subscriptions
  }

-- INIT

init : (State, Cmd Msg)
init = (State.Menu, Cmd.none)


-- UPDATE SYSTEM

update : Msg -> State -> (State, Cmd Msg)
update msg state =
  case state of
    State.Menu -> Menu.update msg
    State.GameSettings s -> Settings.update msg s
    _ -> (State.Error "Invalid state now!", Cmd.none)


-- SUBSCRIPTIONS

subscriptions : State -> Sub Msg
subscriptions model =
  Sub.none


-- VIEWS

view : State -> Html Msg
view state =
  case state of
    State.Menu -> Menu.view
    State.GameSettings s -> Settings.view s
    State.Error msg -> div [] [h2 [] [text "Błąd!"], span [] [text msg]]
    _ -> div [] [text "Co ty tutaj robisz?"]



{-

Some first view on how all this should work.

hooker : (State -> State) -> (State -> State)
sheriff : (State -> State) -> (State -> State)


night0 cont =
  (hooker <| sheriff) cont

day : (State -> State) -> (State -> State)
night : (State -> State) -> (State -> State)

daynights : (State -> State) -> (State -> State)
daynights cont = (day <| night <| daynights) cont

plot cont =
  (night0 <| daynights) cont


won : Faction -> (State -> State)
won faction =
  \s -> State.Won faction

kill : Player -> Player -> (State -> State) -> (State -> State)
-- killer killee continuation
-- returns state transformation that kills killee and then does continuation

-}
