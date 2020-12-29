module Page.Works exposing (content)

import Html exposing (Html)
import Markdown


content : Html msg
content =
    Markdown.toHtml [] """
## works

Music to come! For now, here's a couple of open source projects I've worked on:

### brom

- [source](https://github.com/22bulbs/brom)

> brom is a configurable CLI for recording HTTP transactions and improving security practices, designed for use in local environments and CI tools. Get your headers in order before deployment.

Essentially brom has two major functions:

1. an inverted test suite, where one can write rules against an entire REST server, introspecting on headers for each response without a ton of repetitive unit testing.
2. a GUI for spying on a live (local) server, reverse-proxying all your requests to provide a little more detail than dev tools, plus comparing against your ruleset (mentioned above)

### Sand

- [play](https://our-beach.github.io/sand/)
- [source](https://github.com/our-beach/sand)

An interactive waveform using the Web Audio API and React. Click and drag to change the wave shape, further controls on the bottom. For an educational experience, try drawing a wave half as long twice, or changing the shape to triangles (zigzags) or squares.
"""
