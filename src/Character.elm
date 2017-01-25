module Character exposing (..)

import Faction exposing (Faction)

type alias CharacterBase a = { a | player : Int }

type Character
  = Hooker (CharacterBase {})
  | Sheriff (CharacterBase {})


type alias CharacterContainer = {
  hooker : Maybe Int,
  sheriff : Maybe Int
}


name : Character -> String
name character =
  case character of
    Hooker _ -> "Kurtyzana"
    Sheriff _ -> "Szeryf"


displayOrder : Character -> Int
displayOrder character =
  case character of
    Hooker _ -> 0
    Sheriff _ -> 1


faction : Character -> Faction
faction character =
  case character of
    Hooker _ -> Faction.Citizen
    Sheriff _ -> Faction.Citizen


factions : List Character -> List Faction
factions characters =
  let factionList = List.sortBy Faction.order (List.map faction characters)
  in let unique l a =
    case (l, a) of
      ([], _) -> a
      (h::t, []) -> unique t [h]
      (h::t, c::_) -> unique t (if h == c then a else h::a)
  in unique factionList []


filterByFaction : Faction -> List Character -> List Character
filterByFaction fac characters =
  List.filter (\c -> fac == faction c) characters
