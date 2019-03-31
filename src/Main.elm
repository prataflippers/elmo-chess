module Main exposing (..)

import Browser
import Models.Main exposing (..)
import Updaters.Main exposing (..)
import Views.Main exposing (..)


---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
