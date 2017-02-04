module StateUtils exposing (..)

import Character
import Game
import Html exposing (Html)
import Messages exposing (Msg)
import Utils exposing (nth)

displayPlayer : Game.State -> Game.Player -> (Html Msg)
displayPlayer s p =
  case nth s.players p of
    Just ch -> Html.text ((toString <| Character.getPlayer ch) ++ ". " ++ (Character.name ch))
    Nothing -> Html.text "«nie istnieje»"
