module Router exposing (route)

import Html exposing (..)
import Page.About
import Page.NotFound


route : String -> Html msg
route path =
    case path of
        "/about" ->
            Page.About.view

        _ ->
            Page.NotFound.view
