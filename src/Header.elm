module Header exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Link



-- VIEW


logo =
    Link.internal
        { url = "/"
        , child =
            h1
                [ class "ma0 white"
                , style "font-size" "2rem"
                ]
                [ text "joe thel" ]
        , attrs =
            [ class "link black"
            , href "/"
            ]
        }


flexList : Attribute msg
flexList =
    class "list flex ma0 pl0"


pages =
    ul
        [ flexList
        , class "f6 link"
        ]
        [ Link.page "about"
        ]


links =
    ul
        [ flexList
        , class "f6"
        ]
        [ Link.external
            { url = "https://github.com/fakemonster"
            , child = text "github"
            , attrs = []
            }
        , Link.external
            { url = "https://linkedin.com/in/joe-thel"
            , child = text "linkedin"
            , attrs = []
            }
        , Link.page "contact"
        ]


view : Html msg
view =
    div
        [ class "header pa3 mb3 flex justify-between items-center"
        ]
        [ logo
        , pages
        , links
        ]
