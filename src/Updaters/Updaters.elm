module Updaters.Updaters exposing (..)

import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (src)
import Models.ChessBoard exposing (..)
import Models.Data exposing (..)
import Updaters.MoveLogic exposing (..)
import Utils exposing (..)


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
                newAttackTiles = attackableTiles state.board concretePiece newHighlightedTiles
                newState = { state | selectedPiecePosition = (piece, Just position)
                                   , highlightedTiles = newHighlightedTiles
                                   , attackTiles = newAttackTiles
                                   }
            in
            newState
        Nothing -> -- Movement or deselection
            case state.selectedPiecePosition of
                (Just concreteSelectedPiece, Just concretePiecePosition) ->
                    if member position state.highlightedTiles then --Movement / Attacking
                        let
                            newBoard = movePiece state.board concretePiecePosition concreteSelectedPiece position
                            newTurn = if state.turn == White then Black else White
                        in
                            { state | highlightedTiles = []
                                    , board = newBoard
                                    , selectedPiecePosition = ( Nothing, Nothing )
                                    , turn = newTurn
                                    }
                    else -- Deselection
                        { state | highlightedTiles = []
                                , selectedPiecePosition = ( Nothing, Nothing )
                                , attackTiles = []
                                }
                ( Nothing, Nothing ) ->
                    { state | highlightedTiles = []
                            , selectedPiecePosition = ( Nothing, Nothing )
                            , attackTiles = [] }
                (_, _) ->
                    state


movePiece : ChessBoard -> Position -> Piece -> Position -> ChessBoard
movePiece board prevPosition piece newPosition =
    insert newPosition piece (dictRemove prevPosition board)


attackableTiles : ChessBoard -> Piece -> List Tile -> List Tile
attackableTiles board piece highlightedTiles =
    case highlightedTiles of
        (h::t) ->
            if isEmpty (getPositionIfPiecePresent board h)
            then attackableTiles board piece t
            else [h] ++ attackableTiles board piece t
        [] ->
            []