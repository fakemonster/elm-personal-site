module Link exposing
    ( external
    , internal
    , page
    )

import Html exposing (..)
import Html.Attributes exposing (..)


type alias LinkConfig msg =
    { url : String
    , child : Html msg
    , attrs : List (Attribute msg)
    }


external : LinkConfig msg -> Html msg
external { url, child, attrs } =
    a
        ([ href url
         , target "_blank"
         , rel "noopener nofollow"
         , class "pa1 link"
         ]
            ++ attrs
        )
        [ child ]


internal : LinkConfig msg -> Html msg
internal { url, child, attrs } =
    a
        ([ href url
         , class "pa1 link"
         ]
            ++ attrs
        )
        [ child ]


page : String -> Html msg
page s =
    internal
        { child = text s
        , url = "/" ++ s
        , attrs = []
        }
