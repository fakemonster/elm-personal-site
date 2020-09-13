module Main exposing (..)

import Browser
import Dots
import Header
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Json.Decode as Decode exposing (Decoder, Value)


main : Program Value Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- Model


type alias Spaces =
    { dots : Dots.Space
    }


type alias Model =
    { field : String
    , dotConfig : Dots.Config
    , spaces : Spaces
    }


defaultText =
    "Joe"


flagDecoder : Decoder Dots.Config
flagDecoder =
    Decode.map4 Dots.Config
        (Decode.at [ "width" ] Decode.int)
        (Decode.at [ "height" ] Decode.int)
        (Decode.at [ "radius" ] Decode.float)
        (Decode.at [ "points" ] (Decode.list pointDecoder))


pointDecoder : Decoder Dots.Point
pointDecoder =
    Decode.list Decode.float
        |> Decode.andThen
            (\list ->
                case list of
                    [ x, y ] ->
                        Decode.succeed ( x, y )

                    _ ->
                        Decode.fail "Not a pair"
            )


init : Value -> ( Model, Cmd Msg )
init json =
    let
        dotConfig =
            case Decode.decodeValue flagDecoder json of
                Ok result ->
                    result

                Err _ ->
                    Dots.Config 100 100 1 []

        ( dotSpace, dotCmd ) =
            Dots.init dotConfig
    in
    ( Model "" dotConfig { dots = dotSpace }
    , Cmd.batch
        [ dotCmd |> Cmd.map DotSpace
        ]
    )


fallback : String -> String -> String
fallback text backup =
    case String.isEmpty text of
        True ->
            backup

        False ->
            text


type Msg
    = Change String
    | DotSpace Dots.Msg


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Change text ->
            ( { model | field = text }, Cmd.none )

        DotSpace dotMsg ->
            let
                oldSpaces =
                    model.spaces

                oldDots =
                    oldSpaces.dots

                ( dots, cmd ) =
                    Dots.update dotMsg oldDots
            in
            ( { model | spaces = { oldSpaces | dots = dots } }, cmd )



-- View


view : Model -> Html Msg
view model =
    let
        { dotConfig, spaces } =
            model
    in
    div []
        [ Header.view
        , Dots.draw dotConfig spaces.dots
        ]



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions { spaces } =
    Sub.batch
        [ spaces.dots |> Dots.subscriptions |> Sub.map DotSpace
        ]
