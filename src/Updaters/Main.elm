module Updaters.Main exposing (..)

import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (src)
import Models.ChessBoard exposing (..)


update : Msg -> ChessBoard -> ( ChessBoard, Cmd Msg )
update msg model =
    case msg of
        Click ->
            ( model , Cmd.none )
        AntiClick -> ( model, Cmd.none )
