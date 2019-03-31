module Models.ChessBoard exposing (ChessBoard, Color(..), Msg(..), PieceType(..), init)

import Dict exposing (Dict, keys)
import List exposing (foldr, map, range, reverse, filter, member)
import Tuple exposing (first, pair, second)


type PieceType
    = Rook
    | Knight
    | Bishop
    | King
    | Queen
    | Pawn


zip : List a -> List b -> List ( a, b )
zip =
    List.map2 Tuple.pair


flatten : List (List a) -> List a
flatten list =
    foldr (++) [] list


isValidPos : Position -> Bool
isValidPos ( a, b ) =
    a >= 0 && a <= 8 && b >= 0 && b <= 8


type alias Position =
    ( Int, Int )


x : Position -> Int
x =
    first


y : Position -> Int
y =
    second


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


init : ( ChessBoard, Cmd Msg )
init =
    ( Dict.fromList [], Cmd.none )


type Move
    = Diagonal
    | File
    | Rank
    | RetardJump
    | Single Move


basicValidMoves : ChessBoard -> Position -> Move -> List Position
basicValidMoves board position move =
    case move of
        Diagonal ->
            let
                left = reverse (range 0 (x position - 1))
                right = reverse (range (x position + 1) 8)
                up = reverse (range (y position + 1) 8)
                down = reverse (range 0 (y position - 1))
            in
            flatten (map (discardRest board) [ zip left up, zip left down, zip right up, zip right up ])

        RetardJump ->
            let
                posX = x position
                posY = y position
                addTwoToX =  [(posX + 2, posY + 1), (posX + 2, posY - 1), (posX - 2, posY + 1), (posX - 2, posY + 1)]
                addTwoToY =  [(posX + 1, posY + 2), (posX + 1, posY - 2), (posX - 1, posY + 2), (posX - 1, posY + 2)]
            in
                addTwoToX ++ addTwoToY
        File ->
            [(x position + 1, y position), (x position - 1, y position)]
        
        Rank ->
            [(x position, y position + 1), (x position, y position - 1)]

        Single moveType ->
            filter (oneAway position) (basicValidMoves board position moveType)


oneAway: Position -> Position -> Bool
oneAway posA posB = member (x posA) [(x posB) + 1, (x posB) - 1] && member (y posA) [y posB + 1, y posB - 1]

advancedValidMoves : ChessBoard -> Position -> Move -> List Position
advancedValidMoves board pos move = 
    let 
        basics = basicValidMoves board pos move
    in
        filter isValidPos basics

discardRest : ChessBoard -> List Position -> List Position
discardRest board lst =
    case lst of
        head :: tail ->
            if member head (keys board) then
                head :: discardRest board tail
            else
                [head]
        [] ->
            []


bishopMoves =
    [ Diagonal ]


kingMoves =
    [ Single Diagonal, Single File, Single Rank ]


pawnMoves =
    [ Single File ]


knightMoves =
    [ RetardJump ]


rookMoves =
    [ File, Rank ]


queenMoves =
    bishopMoves ++ rookMoves
