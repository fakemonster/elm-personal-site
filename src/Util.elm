module Util exposing (tupleMap)


tupleMap : (b -> c) -> ( a, b ) -> ( a, c )
tupleMap f ( x, y ) =
    ( x, f y )
