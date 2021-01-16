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
    div
        [ class "center overflow-hidden aspect-ratio aspect-ratio--16x9"
        ]
        [ iframe
            [ src link
            , class "aspect-ratio--object"
            , attribute "frameborder" "0"
            , attribute "allow" "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
            , attribute "allowfullscreen" "true"
            ]
            []
        ]


bcEmbed : String -> String -> Html msg
bcEmbed playerLink pageLink =
    iframe
        [ src playerLink
        , style "border" "0"
        , style "height" "241px"
        , style "width" "100%"
        , attribute "seamless" "true"
        ]
        [ a
            [ href pageLink ]
            [ text "Poem Pieces by Joseph Thel" ]
        ]



{- <iframe style="" src="" seamless><a href="https://jthel.bandcamp.com/album/poem-pieces">Poem Pieces by Joseph Thel</a></iframe> -}


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


this : Section msg
this =
    [ Link.lh4 "This site"
    , linksList
        [ ( "https://github.com/fakemonster/elm-personal-site", "source" ) ]
    , plainText p "This site is built in Elm (hence the JS requirement). Elm is quite nice! Probably the biggest nuisances I encountered were:"
    , ol
        []
        [ plainText li "it really is pure, so effects are managed exclusively by the runtime. This means you have to colocate all your state in one place, which gets a little hairy when you want to have an isolated state that you could (theoretically) duplicate"
        , li
            []
            [ text "due to the lack of typeclasses, I had to put up a bit of a fight to get a sane page architecture going. If you were to do something like this web app in Haskell, probably your first bet would be for each page to `implement Page`, where here you instead define a `Page` type that's a union of each page's unique constructor. It was pretty ugly originally, but I came across Richard Feldman's "
            , Link.external
                { url = "https://github.com/rtfeldman/elm-spa-example"
                , child = text "elm SPA example"
                , attrs = []
                }
            , text " which proved to solve the problem more nicely."
            ]
        ]
    , p
        []
        [ text "All said, it's been excellent to work with. I get to have 100% confidence in every refactor, which I'd generally given up on in frontends! And algebraic types are particularly nice when making UI, where you have a lot of things that are "
        , em [] [ text "nearly" ]
        , text " identical."
        ]
    ]


rondo : Section msg
rondo =
    [ Link.lh4 "Rondo for Strings and Pegs"
    , plainText p "A tuning piece for solo guitar. Very very peaceful, except it breaks all six strings. An excerpt below:"
    , ytEmbed "https://www.youtube.com/embed/ev-eo7x5nf8"
    ]


poemPieces : Section msg
poemPieces =
    [ Link.lh4 "Poem Pieces"
    , plainText p "An ultra-EP of my ongoing project to turn poetry into music; this is my way of getting involved in an art form for which I have tremendous love and inability."
    , bcEmbed "https://bandcamp.com/EmbeddedPlayer/album=4110281240/size=large/bgcol=ffffff/linkcol=0687f5/artwork=small/transparent=true/" "https://jthel.bandcamp.com/album/poem-pieces"
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
        , item this
        , Link.lh3 "Music"
        , plainText p "Feel free to reach out for a copy of a score to any of these works."
        , item rondo
        , item poemPieces
        ]
