module Page.About exposing (content)

import Html exposing (Html)
import Markdown


content : Html msg
content =
    Markdown.toHtml [] """
## about

### me (computers)

I'm a web engineer living in LA, currently working at Ticketmaster. I've worked in a variety of languages, but most recent professional experience is in the React/Next/Node.js ecosystem. If you're looking to collaborate, please contact! In general I try to work in languages/problem spaces different from my professional ones. These days I'm hobbying in Rust and Haskell, but it's always subject to change.

### me (music)

I'm an oboist, composer, and occasional singer. My work in all three is focused on the weirdness of performance, and what it feels like to watch that kind of fall apart (e.g. breaking an instrument, playing music that's impossible to "get right", doing one thing over and over again, or very slowly)

### the site

This iteration of my personal site is pretty much entirely built in [Elm](https://elm-lang.org/), excluding the text-mapping used by the homepage/logo animation (animations themselves are elm-canvas). I highly recommend trying it out on something small-scale like this, which should just enough stretch your needs that you see what parts are easy and what parts are hard.
"""
