module Page.Projects exposing (content)

import Html exposing (..)
import Html.Attributes exposing (..)
import Link
import Markdown


plainText :
    (List (Attribute msg) -> List (Html msg) -> Html msg)
    -> String
    -> Html msg
plainText el textContent =
    el [] [ text textContent ]


ytEmbed : String -> Html msg
ytEmbed link =
    iframe
        [ width 560
        , height 315
        , src link
        , attribute "frameborder" "0"
        , attribute "allow" "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
        , attribute "allowfullscreen" "true"
        ]
        []


type alias Section msg =
    List (Html msg)


item : Section msg -> Html msg
item =
    div []


linksList : List ( String, String ) -> Html msg
linksList links =
    ul [ class "list pl0" ]
        (List.map
            (\( url, childContent ) ->
                li []
                    [ Link.external
                        { url = url
                        , child = text childContent
                        , attrs = []
                        }
                    ]
            )
            links
        )


intro : Html msg
intro =
    p
        []
        [ text "My existing work is mostly split between "
        , Link.anchor "#Music" "music"
        , text " and "
        , Link.anchor "#Software" "programming"
        , text " (I don't usually relate them to each other). These days it's about 90% programming!"
        ]


brom : Section msg
brom =
    [ Link.lh4 "brom"
    , linksList [ ( "https://github.com/22bulbs/brom", "source" ) ]
    , plainText blockquote "brom is a configurable CLI for recording HTTP transactions and improving security practices, designed for use in local environments and CI tools. Get your headers in order before deployment."
    , plainText p "Essentially brom has two major functions:"
    , ol []
        [ plainText li "an inverted test suite, where one can write rules against an entire REST server, introspecting on headers for each response without a ton of repetitive unit testing."
        , plainText li "a GUI for spying on a live (local) server, reverse-proxying all your requests to provide a little more detail than dev tools, plus comparing against your ruleset (mentioned above)"
        ]
    ]


sand : Section msg
sand =
    [ Link.lh4 "Sand"
    , linksList
        [ ( "https://our-beach.github.io/sand/", "play" )
        , ( "https://github.com/our-beach/sand", "source" )
        ]
    , plainText p "An interactive waveform using the Web Audio API and React. Click and drag to change the wave shape, further controls on the bottom. For an educational experience, try drawing a wave half as long twice, or changing the shape to triangles (zigzags) or squares."
    ]


rondo : Section msg
rondo =
    [ Link.lh4 "Rondo for Strings and Pegs"
    , plainText p "A tuning piece for solo guitar. Very very peaceful, except it breaks all six strings. An excerpt below:"
    , ytEmbed "https://www.youtube.com/embed/ev-eo7x5nf8"
    ]


content : Html msg
content =
    div
        [ class "tl pb4 pl3 pr3 mw7 center" ]
        [ plainText h2 "projects"
        , intro
        , Link.lh3 "Software"
        , item brom
        , item sand
        , Link.lh3 "Music"
        , plainText p "Plenty of these have scores; feel free to reach out for a copy."
        , item rondo
        ]
