module Models.ChessBoard exposing (..)

import Dict exposing ( Dict )
import Tuple exposing (first, pair, second)
import Models.Data exposing (..)
import Utils exposing (..)

type alias Tile =
    Position

pieceTypeToString: PieceType -> String
pieceTypeToString p = 
    case p of
        Rook -> "Rook"
        Knight -> "Knight"
        Bishop -> "Bishop"
        King -> "King"
        Queen -> "Queen"
        Pawn -> "Pawn"


isValidPos : Position -> Bool
isValidPos ( a, b ) =
    a >= 0 && a <= 7 && b >= 0 && b <= 7


type alias Position =
    ( Int, Int )


x : Position -> Int
x =
    first


y : Position -> Int
y =
    second

colorToString: Color -> String
colorToString c = 
    case c of
        White -> "White"
        Black -> "Black"

type alias Piece =
    { color : Color
    , pieceType : PieceType
    }

pieceToString: Piece -> String
pieceToString p = (colorToString p.color) ++ (pieceTypeToString p.pieceType)

type alias ChessBoard =
    Dict Position Piece

type alias State = Store

type alias Store = { board: ChessBoard
                   , selectedPiecePosition : (Maybe Piece, Maybe Position)
                   , highlightedTiles: List Tile
                   , attackTiles: List Tile
                   , turn: Color
                   }

type Move
    = Diagonal
    | File
    | Rank
    | KnightJump
    | Walk
    | Single Move


movesForPiece: PieceType -> List Move
movesForPiece piece = case piece of
    Bishop -> [ Diagonal ]
    King -> [ Single Diagonal, Single File, Single Rank ]
    Pawn -> [ Walk ]
    Knight -> [ KnightJump ]
    Rook -> [ File, Rank ]
    Queen -> [ File, Rank, Diagonal ]
