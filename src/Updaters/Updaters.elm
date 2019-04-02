module Updaters.Updaters exposing (..)

import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (src)
import Models.ChessBoard exposing (..)
import Models.Data exposing (..)
import Updaters.MoveLogic exposing (..)
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
                updatedState = updateState state position piece
            in
                ( updatedState, Cmd.none )
                
updateState : State -> Position -> Maybe Piece -> State
updateState state position piece =
    case piece of
        Just concretePiece -> -- Piece selected
            let 
                moves = getMoves state.board position
                newHighlightedTiles = flatten (map (advancedValidMoves state.board position) moves)
                newState = { state | highlightedTiles = newHighlightedTiles,
                                        selectedPiecePosition = (piece, Just position)
                            }
            in
            newState
        Nothing -> -- Movement or deselection
            case state.selectedPiecePosition of
                (Just concreteSelectedPiece, Just concretePiecePosition) ->
                    if member position state.highlightedTiles then
                        let
                            newBoard = movePiece state.board concretePiecePosition concreteSelectedPiece position
                        in
                            { state | highlightedTiles = []
                                    , board = newBoard
                                    , selectedPiecePosition = ( Nothing, Nothing )
                                    }
                    else
                        { state | highlightedTiles = [], selectedPiecePosition = ( Nothing, Nothing ) }
                ( Nothing, Nothing ) ->
                    { state | highlightedTiles = [], selectedPiecePosition = ( Nothing, Nothing ) }
                (_, _) ->
                    state

movePiece : ChessBoard -> Position -> Piece -> Position -> ChessBoard
movePiece board prevPosition piece newPosition =
    insert newPosition piece (dictRemove prevPosition board)
