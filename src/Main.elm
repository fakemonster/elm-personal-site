module Main exposing (..)

import Browser
import Dots
import Header
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Json.Decode as Decode exposing (Value)
import Result



-- Main


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
    { dotConfig : Dots.Config
    , spaces : Spaces
    }


init : Value -> ( Model, Cmd Msg )
init json =
    let
        decoder =
            Decode.at [ "dotConfig" ] Dots.decoder

        dotConfig =
            json
                |> Decode.decodeValue decoder
                |> Result.withDefault (Dots.Config 100 100 1 [])

        ( dotSpace, dotCmd ) =
            Dots.init dotConfig
    in
    ( Model dotConfig { dots = dotSpace }
    , Cmd.batch
        [ dotCmd |> Cmd.map DotSpace
        ]
    )



-- Update


type Msg
    = DotSpace Dots.Msg


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        DotSpace dotMsg ->
            let
                oldSpaces =
                    model.spaces

                ( dots, cmd ) =
                    Dots.update dotMsg oldSpaces.dots
            in
            ( { model | spaces = { oldSpaces | dots = dots } }, cmd )



-- View


view : Model -> Html Msg
view { dotConfig, spaces } =
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
