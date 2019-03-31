module Views.Main exposing (..)

import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src)
import Models.Main exposing (..)


viewHeader : Model -> Html Msg
viewHeader model =
    div [] [ text "This is a header!" ]

view : Model -> Html Msg
view model =
    div []
        [ img [ src "/elmo_chess.png" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        , viewHeader model
        ]

