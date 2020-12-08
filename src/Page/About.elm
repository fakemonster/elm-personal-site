module Page.About exposing (content)

import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown


content : String
content =
    """
## about

Hey it's Joe!
"""


view : Html msg
view =
    div [ class "tl pb4 pl3 pr3" ]
        [ Markdown.toHtml [] content ]
