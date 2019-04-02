module Updaters.Updaters exposing (Msg, attackableTiles, movePiece, resetState, update, updateState)

import Dict exposing (remove)
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (src)
import Models.ChessBoard exposing (..)
import Models.Data exposing (..)
import Updaters.MoveLogic exposing (..)
import Utils exposing (..)


type alias Msg =
    ( Int, Int )


update : Msg -> State -> ( State, Cmd Msg )
update msg state =
    case msg of
        ( x, y ) ->
            let
                position =
                    ( x, y )

                piece =
                    get ( x, y ) state.board

                updatedState =
                    updateState state position piece
            in
            ( updatedState, Cmd.none )


updateState : State -> Position -> Maybe Piece -> State
updateState state position piece =
    case piece of
        Just concretePiece -> -- Piece selected
            if member position state.attackTiles then
                let
                    ( lastSelectedPiece, lastSelectedPosition ) =
                        state.selectedPiecePosition
                in
                case lastSelectedPosition of
                    Just concreteLastSelectedPosition ->
                        let
                            attackingPiece =
                                get concreteLastSelectedPosition state.board
                        in
                        case attackingPiece of
                            Just concreteAttackingPiece -> -- Eat my ass
                                let
                                    boardWithoutCapturedPiece =
                                        insert position concreteAttackingPiece state.board

                                    boardWithoutAttackingPiece =
                                        Dict.remove concreteLastSelectedPosition boardWithoutCapturedPiece
                                in
                                    switchTurn (resetState { state | board = boardWithoutAttackingPiece })
                            Nothing -> -- No ass eater
                                state
                    Nothing -> -- No last selected position
                        state

            else
                let
                    moves = getMoves state.board position
                    newHighlightedTiles = flatten (map (advancedValidMoves state.turn state.board position) moves)
                    newAttackTiles = attackableTiles state.turn state.board concretePiece newHighlightedTiles
                    newTurn = if state.turn == White then Black else White
                 in
                    switchTurn { state
                        | selectedPiecePosition = ( piece, Just position )
                        , highlightedTiles = newHighlightedTiles
                        , attackTiles = newAttackTiles
                        , turn = newTurn
                    }

        Nothing -> -- Movement or deselection
            case state.selectedPiecePosition of
                ( Just concreteSelectedPiece, Just concretePiecePosition ) ->
                    if member position state.highlightedTiles then
                        let
                            newBoard =
                                movePiece state.board concretePiecePosition concreteSelectedPiece position

                        in
                        switchTurn (resetState {  state | board = newBoard })

                    else
                        -- Deselection
                        resetState state

                ( Nothing, Nothing ) -> -- Nothing was selected
                    resetState state

                ( _, _ ) ->
                    state


movePiece : ChessBoard -> Position -> Piece -> Position -> ChessBoard
movePiece board prevPosition piece newPosition =
    insert newPosition piece (dictRemove prevPosition board)


attackableTiles : Color -> ChessBoard -> Piece -> List Tile -> List Tile
attackableTiles turnColor board piece highlightedTiles =
    let
        pieceColor = piece.color
    in
        if pieceColor == turnColor
        then
            case highlightedTiles of
                h :: t ->
                    if isEmpty (getPositionIfPiecePresent board h) then
                        attackableTiles turnColor board piece t
                    else
                        [ h ] ++ attackableTiles turnColor board piece t
                [] -> []
        else
            []


resetState : State -> State
resetState state =
    { state
        | highlightedTiles = []
        , selectedPiecePosition = ( Nothing, Nothing )
        , attackTiles = []
    }


switchTurn : State -> State
switchTurn state =
    let
        currentTurn = state.turn
        newTurn = if currentTurn == White then Black else White
    in
        { state | turn = newTurn }


