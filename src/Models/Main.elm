module Models.Main exposing (Color(..), Model, Msg(..), PieceType(..), init)

import Dict exposing (Dict)


type PieceType
    = Rook
    | Knight
    | Bishop
    | King
    | Queen
    | Pawn


validPos : Position -> Maybe Position
validPos (x, y) =
  if x >= 0 && x <= 8 && y >= 0 && y <= 8 then
    Just (x, y)
  else
    Nothing


type alias Position =
    ( Int, Int )


type Color
    = White
    | Black


type alias Piece =
    { color : Color
    , pieceType : PieceType
    }


type alias ChessBoard =
    Dict Position Piece


type Msg
    = NoOp


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



--
