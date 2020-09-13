module Dots exposing
    ( Config
    , Msg
    , Point
    , Space
    , defaultSpace
    , draw
    , init
    , subscriptions
    , update
    )

import Browser
import Browser.Events exposing (onAnimationFrame)
import Canvas exposing (..)
import Canvas.Settings exposing (..)
import Color exposing (Color)
import Html exposing (Html)
import Html.Attributes exposing (id)
import Random


type alias Dot =
    { r : Float
    , color : Color
    , pos : ( Float, Float )
    }


randColor : Random.Generator Color
randColor =
    Random.map4 Color.hsla
        (Random.float 0.45 0.8)
        (Random.float 0.5 0.7)
        (Random.float 0.45 0.75)
        (Random.float 0.5 0.75)


genColors : (List Color -> a) -> Int -> Cmd a
genColors msgr n =
    Random.generate msgr (Random.list n randColor)


type Msg
    = NewColors (List Color)


toDots : Float -> List Color -> List Point -> List Dot
toDots r =
    List.map2 (Dot r)


toShape : Dot -> Renderable
toShape { pos, r, color } =
    shapes [ fill color ] [ circle pos r ]


type alias Point =
    ( Float, Float )


type alias Config =
    { width : Int
    , height : Int
    , radius : Float
    , points : List Point
    }


type alias Space =
    { colors : List Color
    }


defaultSpace : Space
defaultSpace =
    { colors = []
    }


init : Config -> Cmd Msg
init { points } =
    genColors NewColors (List.length points)


update : Msg -> Space -> ( Space, Cmd msg )
update msg space =
    case msg of
        NewColors colors ->
            ( { space | colors = colors }, Cmd.none )


draw : Config -> Space -> Html msg
draw config { colors } =
    let
        f =
            toFloat

        { width, height, points, radius } =
            config
    in
    Canvas.toHtml ( width, height )
        [ id "dots" ]
        (List.concat
            [ [ shapes [ fill Color.white ] [ rect ( 0, 0 ) (f width) (f height) ]
              ]
            , List.map toShape (toDots (radius * 0.85) colors points)
            ]
        )


subscriptions : Space -> Sub Msg
subscriptions =
    always Sub.none
