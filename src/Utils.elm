module Utils exposing (..)

nth l n =
  if n < 0 then Nothing else
  case (l, n) of
    ([], _) -> Nothing
    (h::t, 0) -> Just h
    (_::t, n) -> nth t (n-1)
