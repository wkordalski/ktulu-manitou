module Utils exposing (..)

nth l n =
  if n < 0 then Nothing else
  case (l, n) of
    ([], _) -> Nothing
    (h::t, 0) -> Just h
    (_::t, n) -> nth t (n-1)


compareBy f =
  \x -> \y -> compare (f x) (f y)


unique : (a -> a -> Order) -> List a -> List a
unique comp l =
  let sorted = List.sortWith comp l in
  let eq = \x -> \y -> comp x y == EQ in
  uniqueSorted eq sorted

uniqueSorted : (a -> a -> Bool) -> List a -> List a
uniqueSorted eq l =
  let helper l a =
    case (l, a) of
      ([], _) -> a
      (h::t, []) -> helper t [h]
      (h::t, c::_) -> helper t (if eq h c then a else h::a)
  in helper l []
