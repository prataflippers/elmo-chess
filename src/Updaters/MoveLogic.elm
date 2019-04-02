module Updaters.MoveLogic exposing (..)

import Models.ChessBoard exposing (..)
import Models.Data exposing (..)
import Utils exposing (..)

getPiece : ChessBoard -> Position -> List Piece
getPiece board position =
    let piece = get position board
    in
        case piece of
            Just concretePiece ->
                [ concretePiece ]
            Nothing ->
                []

getPositionIfPiecePresent : ChessBoard -> Position -> List Position
getPositionIfPiecePresent board position =
    let piece = get position board
    in
        case piece of 
            Just concretePiece ->
                [ position ]
            Nothing ->
                []


getMoves : ChessBoard -> Position -> List Move
getMoves board position =
    let piece = getPiece board position
    in
        flatten (map (\p -> movesForPiece p.pieceType) piece)



basicValidMoves : ChessBoard -> Position -> Move -> List Position
basicValidMoves board position move =
    let
        piece = get position board
    in
        case piece of
            Just concretePiece ->
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
                    RetardWalk ->
                        case concretePiece.color of
                            White ->
                                let
                                    moved = x position /= 1
                                    forward = if moved then [ ( x position + 1, y position ) ] else
                                                            [ ( x position + 1, y position) , (x position + 2, y position )]
                                    diagonal = flatten ( map ( getPositionIfPiecePresent board )
                                                        [ ( x position + 1, y position + 1 ) , ( x position + 1, y position - 1 ) ] )
                                in
                                    discardRest board forward ++ diagonal
                            Black ->
                                let
                                    moved = x position /= 6
                                    forward = if moved then [ ( x position - 1, y position ) ] else
                                                            [ ( x position - 1, y position) , (x position - 2, y position )]
                                    diagonal = flatten ( map ( getPositionIfPiecePresent board )
                                                       [ ( x position - 1, y position + 1 ) , ( x position - 1, y position - 1 ) ] )
                                in
                                    discardRest board forward ++ diagonal
                    Single moveType ->
                        filter (oneAway position) (basicValidMoves board position moveType)
            Nothing ->
                []


oneAway : Position -> Position -> Bool
oneAway posA posB =
    member (x posA) [ x posB + 1, x posB - 1 ] || member (y posA) [ y posB + 1, y posB - 1 ]


advancedValidMoves : ChessBoard -> Position -> Move -> List Position
advancedValidMoves board pos move =
    let
        basicMoves = basicValidMoves board pos move
        movesWithoutAttackingSameColor = removePositionsWithSameColorAsPiece pos board basicMoves
    in
        filter isValidPos movesWithoutAttackingSameColor


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


removePositionsWithSameColorAsPiece:  Position -> ChessBoard -> List Position -> List Position
removePositionsWithSameColorAsPiece position board positions = 
    let 
        piece = get position board
    in
        case piece of
            Just concretePiece -> removePositionsWithColor concretePiece.color board positions
            Nothing -> positions

removePositionsWithColor: Color -> ChessBoard -> List Position -> List Position
removePositionsWithColor color board positions = filter (\a -> 
        let 
            piece = get a board
        in
            case piece of
                Just concretePiece -> concretePiece.color /= color
                Nothing -> True
    ) positions 