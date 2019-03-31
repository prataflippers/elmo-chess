module Updaters.Main exposing (update)

import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (src)
import Models.ChessBoard exposing (..)


update : Msg -> ChessBoard -> ( ChessBoard, Cmd Msg )
update msg model =
    ( model, Cmd.none )
