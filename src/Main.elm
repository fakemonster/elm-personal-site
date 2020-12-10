module Main exposing (..)

import Browser
import Browser.Navigation as Navigation
import Dots
import Header
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Json.Decode as Decode
import Markdown
import Page.About
import Page.Home
import Page.NotFound
import Result
import Url
import Util



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
    , key : Navigation.Key
    }


init : Decode.Value -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init json { path } key =
    let
        decoder =
            Decode.at [ "dotConfig" ] Dots.decoder

        ( dotSpace, dotCmd ) =
            json
                |> Decode.decodeValue decoder
                |> Result.withDefault (Dots.Config 1 1 1 [])
                |> Dots.init
    in
    ( Model { dots = dotSpace } path key
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
                    ( model, Navigation.pushUrl model.key url.path )

                _ ->
                    ( model, Cmd.none )



-- Router


type alias Title =
    Maybe String


format : String -> Html msg
format body =
    Markdown.toHtml [ class "tl pb4 pl3 pr3" ] body


route_ : String -> ( Maybe String, String )
route_ path =
    case path of
        "/about" ->
            ( Just "About", Page.About.content )

        "/" ->
            ( Nothing, Page.Home.content )

        _ ->
            ( Nothing, Page.NotFound.content )


route : String -> ( Maybe String, Html msg )
route =
    route_ >> Util.tupleMap format



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
            route model.path

        flipConcat x y =
            y ++ x

        formattedTitle =
            Maybe.map (flipConcat " | jt") routerTitle
    in
    { title = Maybe.withDefault "joe thel" formattedTitle
    , body = [ view model page ]
    }



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions { spaces } =
    Sub.batch
        [ spaces.dots |> Dots.subscriptions |> Sub.map DotSpace
        ]
