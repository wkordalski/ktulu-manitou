module Character exposing (..)

import Faction exposing (Faction)
import Utils exposing (unique, compareBy)

type alias CharacterBase a = { a | player : Int }

type Character
  = Hooker (CharacterBase {})
  | Sheriff (CharacterBase {})


type alias CharacterContainer = {
  hooker : Maybe Int,
  sheriff : Maybe Int
}

makeContainer =
  {
    hooker = Nothing,
    sheriff = Nothing
  }

hooker player =
  Hooker { player = player }

sheriff player =
  Sheriff { player = player }

addCharacterToContainer container character =
  case character of
    Hooker h -> { container | hooker = Just h.player }
    Sheriff s -> { container | sheriff = Just s.player }

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
  unique (compareBy Faction.order) (List.map faction characters)


filterByFaction : Faction -> List Character -> List Character
filterByFaction fac characters =
  List.filter (\c -> fac == faction c) characters
