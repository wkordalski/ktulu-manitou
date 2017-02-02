module DialogViews exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Color.Convert exposing (colorToHex)

import Messages exposing (Msg)
import State exposing (State)
import Character exposing (Character)
import Faction exposing (Faction)
import Utils exposing (nth)

buttonFromDescription (text, color, cont) id =
  button
    [style [("color", colorToHex color)]
    , onClick (Messages.CommandClicked id)]
    [Html.text text]

updateMessage msg {buttons, parent} =
  case msg of
    Messages.CommandClicked i ->
        case nth buttons i of
          Nothing -> State.Error "Invalid button ID!!!"
          Just (text, color, cont) -> cont parent
    _ -> State.Error "Invalid message"

viewMessage {text, buttons} =
  div []
  ( (h2 [] [Html.text text]) ::
  (List.indexedMap (\i d -> buttonFromDescription d i) buttons) )

updateMenu msg {buttons, parent} =
  case msg of
    Messages.CommandClicked i ->
        case nth buttons i of
          Nothing -> State.Error "Invalid button ID!!!"
          Just (text, color, cont) -> cont parent
    _ -> State.Error "Invalid message"

-- TODO: more styling - options one above another
viewMenu {text, buttons} =
  div []
  ( (h2 [] [Html.text text]) ::
  (List.indexedMap (\i d -> buttonFromDescription d i) buttons) )


viewCharacterDialog {text, characterDescriptor, characters, faction, character, contCancel} =
  let displayCharacter ch =
    button [onClick (Messages.CharacterDialogSetCharacter ch)] [Html.text (Character.name ch)]
  in let displayFaction fc =
    button [onClick (Messages.CharacterDialogSetFaction fc)] [Html.text (Faction.name fc)]
  in
  case (faction, character) of
    (_, Just ch) -> div []
      [ div [] [Html.text text]
      , div [] [Html.text <| characterDescriptor <| ch]
      , button [onClick Messages.CharacterDialogBackButton] [Html.text "Back"]
      , button [onClick Messages.CharacterDialogOKButton] [Html.text "OK"] ]
    (Just fc, Nothing) -> div [] (
      ( (div [] [Html.text text]) ::
        List.map displayCharacter (Character.filterByFaction fc characters)
      ) ++
      [ button [onClick Messages.CharacterDialogBackButton] [Html.text "Back"] ])
    (Nothing, Nothing) -> div [] (
      ( (div [] [Html.text text]) ::
        List.map displayFaction (Character.factions characters)
      )
      ++
      (
      case contCancel of
        Just _ -> [ button [onClick Messages.CharacterDialogBackButton] [Html.text "Cancel"] ]
        Nothing -> []
      ))

updateCharacterDialog msg state =
  let {text, characterDescriptor, characters, faction, character, contAccept, contCancel, parent} = state
  in
  case msg of
    Messages.CharacterDialogOKButton ->
      case character of
        Just ch -> contAccept ch parent
        Nothing -> State.Error "No character selected!!!"
    Messages.CharacterDialogBackButton ->
      case (faction, character) of
        (_, Just _) -> State.CharacterDialog { state | character = Nothing }
        (Just _, Nothing) -> State.CharacterDialog { state | faction = Nothing }
        (Nothing, Nothing) ->
          case contCancel of
            Just cont -> cont parent
            _ -> State.Error "This shouldn't be done!"
    Messages.CharacterDialogSetFaction fc -> State.CharacterDialog { state | faction = Just fc }
    Messages.CharacterDialogSetCharacter ch -> State.CharacterDialog { state | character = Just ch }
    _ -> State.Error "Shouldn't happen"
