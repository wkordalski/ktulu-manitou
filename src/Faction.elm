module Faction exposing (..)

type Faction
  = Citizen
  | Bandit
  | Indian


name : Faction -> String
name faction =
  case faction of
    Citizen -> "Miastowy"
    Bandit -> "Bandyta"
    Indian -> "Indianin"


order : Faction -> Int
order faction =
  case faction of
    Citizen -> 0
    Bandit -> 1
    Indian -> 2
