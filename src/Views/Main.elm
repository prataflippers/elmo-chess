module Views.Main exposing (..)

import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)
import Models.ChessBoard exposing (..)


viewHeader : ChessBoard -> Html Msg
viewHeader model =
    div [] [ text "Components are functions!" ]

view : ChessBoard -> Html Msg
view model =
    div []
        [ img [ src "/elmo_chess.png" ] []
        , h1 [] [ text "Elmo still doesn't know wtf he's doing yet!" ]
        , viewHeader model
        ]

