module Main exposing (..)

import Browser
import Browser.Navigation as Navigation
import Dots
import Header
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Json.Decode as Decode
import Result
import Router
import Url



-- Main


main : Program Decode.Value Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = wrappedView
        , subscriptions = subscriptions
        , onUrlChange = ChangedUrl
        , onUrlRequest = ClickedLink
        }



-- Model


type alias Spaces =
    { dots : Dots.Space
    }


type alias Model =
    { spaces : Spaces
    , path : String
    }


init : Decode.Value -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init json { path } _ =
    let
        decoder =
            Decode.at [ "dotConfig" ] Dots.decoder

        ( dotSpace, dotCmd ) =
            json
                |> Decode.decodeValue decoder
                |> Result.withDefault (Dots.Config 1 1 1 [])
                |> Dots.init
    in
    ( Model { dots = dotSpace } path
    , Cmd.batch
        [ dotCmd |> Cmd.map DotSpace
        ]
    )



-- Update


type Msg
    = DotSpace Dots.Msg
    | ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    let
        setPath url =
            ( { model | path = url.path }, Cmd.none )
    in
    case msg of
        DotSpace dotMsg ->
            let
                oldSpaces =
                    model.spaces

                ( dots, cmd ) =
                    Dots.update dotMsg oldSpaces.dots
            in
            ( { model | spaces = { oldSpaces | dots = dots } }, cmd )

        ChangedUrl url ->
            setPath url

        ClickedLink request ->
            case request of
                Browser.Internal url ->
                    setPath url

                _ ->
                    ( model, Cmd.none )



-- View


view : Model -> Html Msg -> Html Msg
view { spaces } page =
    div []
        [ Header.view
        , div [ class "absolute left-0 top-0 ml3 mt3" ]
            [ div [ class "relative" ]
                [ Dots.draw spaces.dots ]
            ]
        , div
            []
            [ page ]
        ]


wrappedView : Model -> Browser.Document Msg
wrappedView model =
    let
        ( routerTitle, page ) =
            Router.route model.path
    in
    { title = Maybe.withDefault "Joe Thel" routerTitle
    , body = [ view model page ]
    }



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions { spaces } =
    Sub.batch
        [ spaces.dots |> Dots.subscriptions |> Sub.map DotSpace
        ]
