module Utils exposing (..)

import Dict
import List
import Debug

-- Lists
map = List.map
range = List.range
filter = List.filter
foldr = List.foldr
member = List.member
reverse = List.reverse

-- Dicts
get = Dict.get

-- Debugging
log = Debug.log

-- Custom

zip : List a -> List b -> List ( a, b )
zip =
    List.map2 Tuple.pair


flatten : List (List a) -> List a
flatten list =
    List.foldr (++) [] list