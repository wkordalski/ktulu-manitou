module DialogViews exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Color.Convert exposing (colorToHex)

import Messages exposing (Msg)
import State exposing (State)
import Character exposing (Character)
import Faction exposing (Faction)
import Utils exposing (nth, unique)
import Game

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


viewCharacterDialog {text, characterDescriptor, characters, faction, character, contCancel, parent} =
  let displayCharacter ch =
    button [onClick (Messages.CharacterDialogSetCharacter ch)] [Html.text (Character.name ch)]
  in let displayFaction fc =
    button [onClick (Messages.CharacterDialogSetFaction fc)] [Html.text (Faction.name fc)]
  in
  case (faction, character) of
    (_, Just ch) ->
      let (desc, enable) = characterDescriptor ch parent
      in
      div []
        [ div [] [Html.text text]
        , div [] [Html.text desc]
        , button [onClick Messages.CharacterDialogBackButton] [Html.text "Back"]
        , button [onClick Messages.CharacterDialogOKButton] [Html.text "OK"]
        ]
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


makeKeyboard : List Int -> (Int -> Int) -> (Int -> Msg) -> Html Msg
makeKeyboard values mapper digitSetter =
  let vals = unique compare <| List.map mapper values in
  let check_disable n = disabled <| not <| List.any (\x -> x == n) vals in
  let make_button n = button [onClick (digitSetter n), check_disable n] [Html.text (Basics.toString n)]
  in
  div [] (List.map make_button [1, 2, 3, 4, 5, 6, 7, 8, 9, 0])

viewPlayerDialog state =
  let {text, playerDescriptor, players, digit1, digit2, contCancel, parent} = state
  in
  case (digit1, digit2) of
    (Just d1, Just d2) ->
      let playerId = d1 * 10 + d2 in
      let (desc, enable) = playerDescriptor playerId parent in
      div []
      [ div [] [Html.text text]
      , div [] [Html.text desc]
      , button [onClick Messages.PlayerDialogBackButton] [Html.text "Back"]
      , button [onClick Messages.PlayerDialogOKButton, disabled (not enable)] [Html.text "OK"]
      ]
    (Just d1, Nothing) ->
      div []
      [ div [] [Html.text text]
      , makeKeyboard (List.filter (\x -> x // 10 == d1) players) (\x -> x % 10) (\x -> Messages.PlayerDialogSetDigit2 x)
      , button [onClick Messages.PlayerDialogBackButton] [Html.text "Back"]
      ]
    (Nothing, _) ->
      div [] (
      [ div [] [Html.text text]
      , makeKeyboard players (\x -> x // 10) (\x -> Messages.PlayerDialogSetDigit1 x)
      ] ++
      case contCancel of
        Nothing -> []
        Just _ -> [button [onClick Messages.PlayerDialogBackButton] [Html.text "Back"]]
      )

updatePlayerDialog msg state =
  let {playerDescriptor, players, digit1, digit2, contAccept, contCancel, parent} = state
  in
  case msg of
    Messages.PlayerDialogOKButton ->
      case (digit1, digit2) of
        (Just d1, Just d2) -> contAccept (d1 * 10 + d2) parent
        _ -> State.Error "No player selected!!!"
    Messages.PlayerDialogBackButton ->
      case (digit1, digit2) of
        (_, Just _) -> State.PlayerDialog { state | digit2 = Nothing }
        (Just _, Nothing) -> State.PlayerDialog { state | digit1 = Nothing }
        (Nothing, Nothing) ->
          case contCancel of
            Just cont -> cont parent
            _ -> State.Error "This shouldn't be done!"
    Messages.PlayerDialogSetDigit1 v -> State.PlayerDialog { state | digit1 = Just v }
    Messages.PlayerDialogSetDigit2 v -> State.PlayerDialog { state | digit2 = Just v }
    _ -> State.Error "Shouldn't happen"
