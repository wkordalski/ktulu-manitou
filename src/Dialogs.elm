-- Należy wykonać zwracaną wartość (State → State) by pokazać okno
playerChooser : List Player -> String -> Bool -> (Maybe Player -> State -> State) -> (State -> State)
playerChooser choices title cancelEnabled cont =
  \s -> PlayerChoosing {
    original = s,
    continuation = cont,
    firstDigit = Nothing,
    secondDigit = Nothing,
    choices = players,
    title = title,
    cancelEnabled = cancelEnabled
  }
