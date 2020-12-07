module Page.About exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


view : Html msg
view =
    div [ class "tl pt4 pb4 pl3 pr3" ]
        [ text "Hey it's Joe!" ]
