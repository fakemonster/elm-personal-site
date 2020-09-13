module Header exposing (view)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)


-- VIEW

link : String -> String -> Html msg
link url textChild = a
  [ href url
  , rel "noopener nofollow"
  , class "pa1"
  ]
  [ text textChild ]

header = a
  [ class "link black"
  , href "/"
  ]
  [ h1 [ class "ma0" ] [ text "joe thel" ]
  ]

links = ul
    [ class "list flex ma0 pl0"
    ]
    [ link "https://github.com/fakemonster" "github"
    , link "https://linkedin.com/in/joe-thel" "linkedin"
    , link "/contact" "contact"
    ]

view : Html msg
view =
      div [ class "pa3 mb3 flex justify-between items-end" ]
      [ header
      , links
      ]
