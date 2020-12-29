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
         , class "link"
         ]
            ++ attrs
        )
        [ child ]


internal : LinkConfig msg -> Html msg
internal { url, child, attrs } =
    a
        ([ href url
         , class "link"
         ]
            ++ attrs
        )
        [ child ]


page : List (Attribute msg) -> String -> Html msg
page attrs s =
    internal
        { child = text s
        , url = "/" ++ s
        , attrs = attrs
        }
