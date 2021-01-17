module Link exposing
    ( anchor
    , external
    , internal
    , lh2
    , lh3
    , lh4
    , page
    , toAnchorName
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


anchor : String -> String -> Html msg
anchor name content =
    internal
        { url = name
        , child = text content
        , attrs = [ class "anchor" ]
        }


isAsciiPrintable : Char -> Bool
isAsciiPrintable c =
    let
        code =
            Char.toCode c
    in
    code >= 32 && code <= 126


toAnchorName : String -> String
toAnchorName =
    String.cons '_'
        << String.replace "_" "-"
        << String.filter isAsciiPrintable


toAnchorFrag : String -> String
toAnchorFrag =
    String.cons '#' << toAnchorName


anchorize :
    (List (Attribute msg) -> List (Html msg) -> Html msg)
    -> String
    -> Html msg
anchorize render content =
    render
        [ class "anchor-link relative" ]
        [ a
            [ class "anchor-svg w2 h1 link absolute left--2"
            , href (toAnchorFrag content)
            , id (toAnchorName content)
            ]
            [ img
                [ class "w1 h1 ma0 mr2 ml2"
                , src "/svg/link.svg"
                , alt ("link to " ++ content)
                ]
                []
            ]
        , text content
        ]


lh2 : String -> Html msg
lh2 =
    anchorize h2


lh3 : String -> Html msg
lh3 =
    anchorize h3


lh4 : String -> Html msg
lh4 =
    anchorize h4
