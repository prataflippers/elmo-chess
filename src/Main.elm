module Main exposing (..)

import Browser
import Models.ChessBoard exposing (..)
import Updaters.Updaters exposing (..)
import Views.Views exposing (..)
import Models.Data exposing (..)
import Utils exposing (..)


---- PROGRAM ----
init : ( State, Cmd Msg )
init = ( { board = (fromList initialBoard), highlightedTiles = []}, Cmd.none )

main : Program () State Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
