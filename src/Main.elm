module Main exposing (..)

import Browser
import Dots
import Header
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Json.Decode as Decode exposing (Value)
import Result
import Router



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
    { spaces : Spaces
    }


init : Value -> ( Model, Cmd Msg )
init json =
    let
        decoder =
            Decode.at [ "dotConfig" ] Dots.decoder

        ( dotSpace, dotCmd ) =
            json
                |> Decode.decodeValue decoder
                |> Result.withDefault (Dots.Config 1 1 1 [])
                |> Dots.init
    in
    ( Model { dots = dotSpace }
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
view { spaces } =
    div []
        [ Header.view
        , div [ class "absolute left-0 top-0 ml3 mt3" ]
            [ div [ class "relative" ]
                [ Dots.draw spaces.dots ]
            ]
        , div
            []
            [ Router.route "/about" ]
        ]



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions { spaces } =
    Sub.batch
        [ spaces.dots |> Dots.subscriptions |> Sub.map DotSpace
        ]
