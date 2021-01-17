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
            [ class "pa1 black logo"
            , href "/"
            ]
        }


flexList : Attribute msg
flexList =
    class "list flex ma0 pl0"


pages =
    ul
        [ flexList
        , class "f6 link page-links"
        ]
        [ li [] [ Link.page [ class "ph1 pv3" ] "about" ]
        , li [] [ Link.page [ class "ph1 pv3" ] "projects" ]
        ]


links =
    ul
        [ flexList
        , class "f6 outer-links"
        ]
        [ li []
            [ Link.external
                { url = "https://github.com/fakemonster"
                , child = text "github"
                , attrs = [ class "ph1 pv3" ]
                }
            ]
        , li []
            [ Link.external
                { url = "https://linkedin.com/in/joe-thel"
                , child = text "linkedin"
                , attrs = [ class "ph1 pv3" ]
                }
            ]
        ]


view : Html msg
view =
    div
        [ class "header pa3 mb3 justify-between items-center"
        ]
        [ logo
        , pages
        , links
        ]
