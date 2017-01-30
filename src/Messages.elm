module Messages exposing (..)

type Msg
  = Undo | DropHistory
  | ShowGameSettings
  | GameSettingsPlayersCount String
  | CommandClicked Int
