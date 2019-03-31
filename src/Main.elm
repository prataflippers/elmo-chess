module Main exposing (..)

import Browser
import Models.ChessBoard exposing (..)
import Updaters.Main exposing (..)
import Views.Main exposing (..)
import Utils exposing (..)


---- PROGRAM ----


main : Program () ChessBoard Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
