module Router exposing (route)

import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown
import Page.About
import Page.Home
import Page.NotFound
import Util


type alias Title =
    Maybe String


format : String -> Html msg
format body =
    Markdown.toHtml [ class "tl pb4 pl3 pr3" ] body


route_ : String -> ( Maybe String, String )
route_ path =
    case path of
        "/about" ->
            ( Just "About", Page.About.content )

        "/" ->
            ( Nothing, Page.Home.content )

        _ ->
            ( Nothing, Page.NotFound.content )


route : String -> ( Maybe String, Html msg )
route =
    route_ >> Util.tupleMap format
