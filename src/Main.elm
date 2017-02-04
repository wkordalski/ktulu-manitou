{-
Players: {0, ..., n-1} -> character detail
Characters: {name -> Mayby player}
-- Character { id -> player, (other options...)}
Some options of game (ship arrival, who has statuette {Maby player}, who owns statuette {Maby player})
-}

import Html exposing (..)
import Html.Events exposing (..)

import Settings
import Messages exposing (Msg)
import DialogViews

import State exposing (State)

import Dialogs
import Color exposing (Color)

import Program exposing (program)

type OutState
  = History {current : State, previous : OutState }
  | First {current : State}

main = Html.program {
    init = init,
    view = view,
    update = update,
    subscriptions = subscriptions
  }

-- INIT

init : (OutState, Cmd Msg)
init = (First { current = Program.program () }, Cmd.none)


-- UPDATE SYSTEM

getCurrentState state =
  case state of
    First  {current} -> current
    History {current} -> current

update : Msg -> OutState -> (OutState, Cmd Msg)
update msg state =
  case msg of
    Messages.Undo ->
      case state of
        History {previous} -> (previous, Cmd.none)
        First _ -> (state, Cmd.none)
    Messages.DropHistory -> (First {current = getCurrentState state}, Cmd.none)
    _ ->
      let (newState, command) = updateGeneral msg (getCurrentState state) in
      (History {current = newState, previous = state}, command)

updateGeneral : Msg -> State -> (State, Cmd Msg)
updateGeneral msg state =
  case state of
    State.Start s -> updateDialog (State.Start) msg s
    State.Settings s -> updateDialogWithSettings (State.Settings) msg s
    State.Game s -> updateDialog (State.Game) msg s
    _ -> (state, Cmd.none)

--updateDialog : (State.DialogState data -> State.State) -> Msg -> (State.DialogState data) -> (State.State, Cmd Msg)
updateDialog ctor msg state =
  case state of
    State.MenuDialog s -> (DialogViews.updateMenu ctor msg s, Cmd.none)
    State.MessageDialog s -> (DialogViews.updateMessage ctor msg s, Cmd.none)
    State.CharacterDialog s -> (DialogViews.updateCharacterDialog ctor msg s, Cmd.none)
    State.PlayerDialog s -> (DialogViews.updatePlayerDialog ctor msg s, Cmd.none)
    _ -> (State.Error "Invalid state now!", Cmd.none)

updateDialogWithSettings ctor msg state =
  case state of
    State.GameSettings s -> (Settings.update ctor msg s, Cmd.none)
    _ -> updateDialog ctor msg state

-- SUBSCRIPTIONS

subscriptions : OutState -> Sub Msg
subscriptions model =
  Sub.none


-- VIEWS

global_menu : OutState -> Html Msg -> Html Msg
global_menu state contents =
  case state of
    First _ -> contents
    History _ -> div [] [button [onClick Messages.Undo] [text "Undo"], contents]

view : OutState -> Html Msg
view state =
  global_menu state <| viewGeneral <| getCurrentState <| state

viewGeneral state =
  case state of
    State.Start s -> viewDialog s
    State.Settings s -> viewDialogWithSettings s
    State.Game s -> viewDialog s
    State.Error msg -> div [] [h2 [] [text "Błąd!"], span [] [text msg]]

viewDialog state =
  case state of
    State.MenuDialog s -> DialogViews.viewMenu s
    State.MessageDialog s -> DialogViews.viewMessage s
    State.CharacterDialog s -> DialogViews.viewCharacterDialog s
    State.PlayerDialog s -> DialogViews.viewPlayerDialog s
    _ -> div [] [text "Co ty tutaj robisz?"]

viewDialogWithSettings state =
  case state of
    State.GameSettings s -> Settings.view s
    _ -> viewDialog state

{-

Some first view on how all this should work.

hooker : (State -> State) -> (State -> State)
sheriff : (State -> State) -> (State -> State)


night0 cont =
  hooker <| sheriff <| cont

day : (State -> State) -> (State -> State)
night : (State -> State) -> (State -> State)

daynights : (State -> State)
daynights = \s -> (day <| night <| daynights) s

plot cont =
  night0 <| daynights <| cont


won : Faction -> (State -> State)
won faction =
  \s -> State.Won faction

kill : Player -> Player -> (State -> State) -> (State -> State)
-- killer killee continuation
-- returns state transformation that kills killee and then does continuation


Ideas for "Undo" - which is quite a usefull feature

-- Inside game

checkpoint : (State -> State) ->  (State -> State)
checkpoint cont =
  \s -> case s of
    State.GameState s -> State.GameSettings { s | undo_state = s, undo_cont = cont}

-- Outside game
"Real" state is extended with pointer to previous state
state = {current : State.State, previous : state}

-}
