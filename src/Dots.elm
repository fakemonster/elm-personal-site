module Dots exposing
    ( Config
    , Msg
    , Point
    , Space
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
import Time exposing (Posix)



-- Model


type alias Point =
    ( Float, Float )


type alias Dot =
    { r : Float
    , color : Color
    , pos : ( Float, Float )
    }


type alias Config =
    { width : Int
    , height : Int
    , radius : Float
    , points : List Point
    }


type alias Space =
    { colors : List Color
    , delays : List Int
    , limit : Int
    }


defaultSpace : Space
defaultSpace =
    { colors = []
    , delays = []
    , limit = 0
    }


init : Config -> ( Space, Cmd Msg )
init { points } =
    ( defaultSpace
    , Cmd.batch
        [ genColors (List.length points)
        , genDelays (List.length points)
        ]
    )



-- Rand


randColor : Random.Generator Color
randColor =
    Random.map4 Color.hsla
        (Random.float 0.45 0.8)
        (Random.float 0.5 0.7)
        (Random.float 0.45 0.75)
        (Random.float 0.5 0.75)


frameLength : Int
frameLength =
    60


randDelay : Random.Generator Int
randDelay =
    Random.int 1 frameLength


genColors : Int -> Cmd Msg
genColors n =
    Random.generate NewColors (Random.list n randColor)


genDelays : Int -> Cmd Msg
genDelays n =
    Random.generate NewDelays (Random.list n randDelay)



-- Update


type Msg
    = NewColors (List Color)
    | NewDelays (List Int)
    | Tick Posix


update : Msg -> Space -> ( Space, Cmd msg )
update msg space =
    case msg of
        NewColors colors ->
            ( { space | colors = colors }, Cmd.none )

        NewDelays delays ->
            ( { space | delays = delays }, Cmd.none )

        Tick posix ->
            ( { space | limit = space.limit + 1 }, Cmd.none )



-- View


toDots : Float -> List Color -> List Point -> List Dot
toDots r =
    List.map2 (Dot r)


toShape : Dot -> Renderable
toShape { pos, r, color } =
    shapes [ fill color ] [ circle pos r ]


filterOnDelay : Int -> List Int -> List a -> List a
filterOnDelay limit ds xs =
    let
        joined =
            List.map2 Tuple.pair ds xs
    in
    List.filterMap
        (\( d, x ) ->
            case d < limit of
                True ->
                    Just x

                False ->
                    Nothing
        )
        joined


draw : Config -> Space -> Html msg
draw { width, height, points, radius } { colors, limit, delays } =
    let
        f =
            toFloat

        delayFilter =
            filterOnDelay limit delays

        dots =
            toDots (radius * 0.85) colors points
    in
    Canvas.toHtml ( width, height )
        [ id "dots" ]
        (List.concat
            [ [ shapes
                    [ fill Color.white ]
                    [ rect ( 0, 0 ) (toFloat width) (toFloat height) ]
              ]
            , dots |> delayFilter |> List.map toShape
            ]
        )



-- Subscriptions


subscriptions : Space -> Sub Msg
subscriptions { limit } =
    case limit > frameLength of
        True ->
            Sub.none

        False ->
            onAnimationFrame Tick
