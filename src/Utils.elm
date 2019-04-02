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
head = List.head
isEmpty = List.isEmpty
-- Removes first occurrence of given element in list
remove: a -> List a -> List a
remove a xs = 
    case xs of
        (first::tail) -> if first == a then tail else first :: remove a tail
        [] -> []

-- Dicts
keys = Dict.keys
get = Dict.get
insert = Dict.insert
fromList = Dict.fromList
dictRemove = Dict.remove

-- Debugging
-- log = Debug.log

-- Custom

zip : List a -> List b -> List ( a, b )
zip =
    List.map2 Tuple.pair


flatten : List (List a) -> List a
flatten list =
    List.foldr (++) [] list