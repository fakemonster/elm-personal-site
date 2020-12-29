module Page.NotFound exposing (content)

import Html exposing (Html)
import Markdown


content : Html msg
content =
    Markdown.toHtml [] """
## nothin

not found
"""
