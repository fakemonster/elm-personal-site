module Page.About exposing (content)

import Html exposing (..)
import Html.Attributes exposing (..)
import Markdown


content : String
content =
    """
## about

### me (computers)

Hi! I'm a web developer living in LA, currently working at Ticketmaster. I've worked in a variety of languages, though JS (and a bit of Java) are my main tool at the moment. If you're looking to collaborate, please contact! In general I try to work in languages/problem spaces different from my professional ones. These days I'm curious about Rust, Haskell, and language design, but it's always subject to change.

### me (music)

This is usually in the third person, but I'm an oboist, composer, and occasional singer. My work (in all three) is directed towards new music, whether that's performing it or writing it.

### the site

This iteration of my personal site is entirely built in [Elm](https://elm-lang.org/). I highly recommend trying it out on something like a personal site, which should just enough stretch your needs that you see what parts are easy and what parts are hard.
"""


view : Html msg
view =
    div [ class "tl pb4 pl3 pr3" ]
        [ Markdown.toHtml [] content ]
