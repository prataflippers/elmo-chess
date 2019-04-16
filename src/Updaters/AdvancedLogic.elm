module Updaters.AdvancedLogic exposing (..)

import Models.ChessBoard exposing (..)
import Models.Data exposing (..)
import Utils exposing (..)


-- For castling ONLY
performCastle : ChessBoard -> Position -> Position -> ChessBoard
performCastle board kingPosition rookPosition =
    let
        kingPiece = get kingPosition board
        rookPiece = get rookPosition board
    in
        case [ kingPiece, rookPiece ] of
            [ Just concreteKingPiece, Just concreteRookPiece ] ->
                let
                    boardy = if ( y rookPosition == 0 ) then
                                let
                                    boardAfterKingMove = move board kingPosition ( x kingPosition, y kingPosition - 2 )
                                    boardAfterRookMove = move boardAfterKingMove rookPosition ( x rookPosition, y rookPosition + 3 )
                                in
                                    boardAfterRookMove
                            else if ( y rookPosition == 7 ) then
                                let
                                    boardAfterKingMove = move board kingPosition ( x kingPosition, y kingPosition + 2 )
                                    boardAfterRookMove = move boardAfterKingMove rookPosition ( x rookPosition, y rookPosition - 2 )
                                in
                                    boardAfterRookMove
                            else
                                board
                    in
                        boardy
            _ -> 
                board


-- aCheckIfItIsOkayToCastleOurKing : State -> Position -> Position -> Bool
-- castleKingSide : ChessBoard -> Piece -> Piece -> ChessBoard
-- castleKingSide board king rook =
--     let
--         whiteKingPosition = (0, 4)
--         blackKingPosition = (7, 3)
--         whiteRookPosition = (0, 7)
--         blackRookPosition = (7, 0)
--     in
--         case king.color of
--             White ->
--                 let
--                     map dictRemove whiteKingPosition, whiteRookPosition board
--                     dictRemove whiteRookPosition board
--                 in
                    
--             Black ->
--                 dictRemove blackKingPosition board
        
        
-- castleQueenSide : ChessBoard -> Piece -> ChessBoard
-- castleQueenSide board piece =
--     let
--         whiteKingPosition = (0, 4)
--         blackKingPosition = (7, 3)
--         whiteRookPosition = (0, 7)
--         blackRookPosition = (7, 0)
--     in
--         case piece.color of
--             White ->
--                 dictRemove board whiteKingPosition
--                 dictRemove whiteKingPosition board
--             Black ->
--                 dictRemove board blackKingPosition


isUnderCheck: Color -> Position -> ChessBoard -> Bool
isUnderCheck color position board = 
    advancedValidMoves color board position move



type alias Pinoy = Int
type alias Putang = Pinoy
type alias Ina = Pinoy
type alias Mo = Pinoy

isAboveCheck: Putang -> Ina -> Mo -> Pinoy
isAboveCheck putang ina mo =
    putang + ina + mo


move: ChessBoard -> Position -> Position  -> ChessBoard
move board initialPosition newPosition = 
    let 
        piece = get initialPosition board
    in
        case piece of
            Just concretePiece -> 
                dictRemove initialPosition (insert newPosition concretePiece board)
            Nothing -> board

