module Router exposing (route)

import Html exposing (..)
import Page.About
import Page.NotFound


route : String -> ( Maybe String, Html msg )
route path =
    case path of
        "/about" ->
            ( Just "About", Page.About.view )

        "/" ->
            ( Nothing, text "" )

        _ ->
            ( Nothing, Page.NotFound.view )
