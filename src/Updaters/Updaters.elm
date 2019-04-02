module Updaters.Updaters exposing (..)

import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (src)
import Models.ChessBoard exposing (..)
import Utils exposing (..)

-- parsePosition : Position -> String
-- parsePosition position =
--     case position of
--         (x, y) ->
--             String.fromInt(x) ++ String.fromInt(y)

type alias Msg = (Int, Int)

update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        (x, y) ->
            let
                position = (x, y)
                piece = get (x, y) state.board
            in
                case piece of
                    Just concretePiece ->  
                        let 
                            moves = getMoves state.board position
                            newHighlightedTiles = flatten (map (advancedValidMoves state.board position) moves)
                            newState = { state | highlightedTiles = newHighlightedTiles }
                        in
                        ( newState , Cmd.none )
                    Nothing -> 
                        ( { state | highlightedTiles = [] } , Cmd.none )


getMoves : ChessBoard -> Position -> List Move
getMoves board position = 
    let piece = get position board
    in
        case piece of 
            Just concretePiece ->
                movesForPiece concretePiece.pieceType
            Nothing -> []


basicValidMoves : ChessBoard -> Position -> Move -> List Position
basicValidMoves board position move =
    case move of
        Diagonal ->
            let
                left = reverse (range 0 (x position - 1))
                right = range (x position + 1) 7
                up =  range (y position + 1) 7
                down = reverse (range 0 (y position - 1))
            in
            flatten (map (\x -> discardRest board x) [ zip left up, zip left down, zip right up, zip right down ])
        RetardJump ->
            let
                addTwoToX = [ ( x position + 2, y position + 1 ), ( x position + 2, y position - 1 )
                            , ( x position - 2, y position + 1 ), ( x position - 2, y position - 1 ) ]
                addTwoToY = [ ( x position + 1, y position + 2 ), ( x position + 1, y position - 2 )
                            , ( x position - 1, y position + 2 ), ( x position - 1, y position - 2 ) ]
            in
            addTwoToX ++ addTwoToY
        File ->
            let
                down = discardRest board (map (\offset -> ( x position + offset, y position)) (reverse (range -7 -1)))
                up = discardRest board (map (\offset -> ( x position + offset, y position)) (range 1 7))
            in
                down ++ up
        Rank ->
            let
                left = discardRest board (map (\offset -> ( x position, y position + offset)) (reverse (range -7 -1)))
                right = discardRest board (map (\offset -> ( x position, y position + offset)) (range 1 7))
            in
                left ++ right
        Single moveType ->
            filter (oneAway position) (basicValidMoves board position moveType)


oneAway : Position -> Position -> Bool
oneAway posA posB =
    member (x posA) [ x posB + 1, x posB - 1 ] || member (y posA) [ y posB + 1, y posB - 1 ]


advancedValidMoves : ChessBoard -> Position -> Move -> List Position
advancedValidMoves board pos move =
    let
        basics =
            basicValidMoves board pos move
    in
        filter isValidPos basics


discardRest : ChessBoard -> List Position -> List Position
discardRest board lst =
    case lst of
        head :: tail ->
            if member head (keys board) then
                [head]
            else
                head :: discardRest board tail
        [] ->
            []