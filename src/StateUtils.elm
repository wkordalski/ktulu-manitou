module StateUtils exposing (..)

displayPlayer : Game.State -> Game.Player -> Result String (Html Msg)
displayPlayer s p =
  case nth s.players p of
    Just ch -> Html.text ((toString ch.player) ++ ". " + (Character.name ch))
    Nothing -> Err "Such player does not exist"
