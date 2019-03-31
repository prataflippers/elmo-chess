module Views.Main exposing (chessBoardView, loopComponent, view, viewTile)

import Html exposing (Html, button, div, h1, img, span, text)
import Html.Attributes exposing (class, id, src)
import Html.Events exposing (onClick)
import Models.ChessBoard exposing (..)
import Utils exposing (..)


pieceImageAddress : Piece -> String
pieceImageAddress piece =
    "/pieces/" ++ pieceToString piece ++ ".png"

viewTile : ChessBoard -> Tile -> Html Msg
viewTile board tile =
    let
        piece =
            get tile board

        basicTile =
            div
                [ class "tile"
                , onClick Click
                ]
    in
    case piece of
        Just concretePiece ->
            basicTile
                [ img [ class "pieceImage", src (pieceImageAddress concretePiece) ] []
                ]

        Nothing ->
            basicTile []


gridIndexToTile : Int -> Tile
gridIndexToTile index =
    ( (index - 1) // 8, modBy 8 (index - 1) )


loopComponent : a -> Int -> List a
loopComponent component n =
    if n /= 0 then
        component :: loopComponent component (n - 1)

    else
        []


view : ChessBoard -> Html Msg
view model =
    div []
        [ img [ src "/elmo_chess.png" ] []
        , h1 [] [ text "Elmo is dead BIATCH!" ]
        , chessBoardView model
        ]


chessBoardView : ChessBoard -> Html Msg
chessBoardView board =
    div [ id "board" ]
        (map (viewTile board) (map gridIndexToTile (range 1 64)))
