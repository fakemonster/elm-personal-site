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
    { dots : Maybe Dots.Space
    }


type alias Model =
    { field : String
    , dotConfig : Dots.Config
    , spaces : Spaces
    }


defaultText =
    "Joe"


defaultSpaces =
    { dots = Nothing
    }


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
    in
    ( Model "" dotConfig defaultSpaces, Dots.initCmd DotSpace dotConfig )


fallback : String -> String -> String
fallback text backup =
    case String.isEmpty text of
        True ->
            backup

        False ->
            text


type Msg
    = Change String
    | DotSpace Dots.Space


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Change text ->
            ( { model | field = text }, Cmd.none )

        DotSpace space ->
            let
                oldSpaces =
                    model.spaces
            in
            ( { model | spaces = { oldSpaces | dots = Just space } }, Cmd.none )



-- View


view : Model -> Html Msg
view model =
    div []
        [ Header.view
        , case model.spaces.dots of
            Nothing ->
                div [] []

            Just space ->
                Dots.draw model.dotConfig space
        , canvas [ id "dots" ] []
        ]



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions =
    always Sub.none
