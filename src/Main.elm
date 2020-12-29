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
import Page.Works
import Result
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
    , mainDots : Dots.Space
    }


type alias SpaceConfig =
    { dots : Dots.Config
    , mainDots : Dots.Config
    }


type alias Model =
    { spaces : Spaces
    , path : String
    , key : Navigation.Key
    }


decodeDotConfig : String -> Decode.Value -> Dots.Config
decodeDotConfig field json =
    json
        |> Decode.decodeValue (Decode.at [ field ] Dots.decoder)
        |> Result.withDefault Dots.defaultConfig


getConfig : Spaces -> SpaceConfig
getConfig { dots, mainDots } =
    { dots = dots.config
    , mainDots = mainDots.config
    }


initSpaces : SpaceConfig -> ( Spaces, Cmd Msg )
initSpaces { dots, mainDots } =
    let
        ( dotSpace, dotCmd ) =
            Dots.init dots

        ( mainDotSpace, mainDotCmd ) =
            Dots.init mainDots
    in
    ( Spaces dotSpace mainDotSpace
    , Cmd.batch
        [ dotCmd |> Cmd.map DotSpace
        , mainDotCmd |> Cmd.map MainDotSpace
        ]
    )


init : Decode.Value -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init json { path } key =
    let
        dotConfig =
            decodeDotConfig "dotConfig" json

        mainDotConfig =
            decodeDotConfig "mainDotConfig" json

        initConfig =
            SpaceConfig dotConfig mainDotConfig

        ( spaces, cmd ) =
            initSpaces initConfig
    in
    ( Model spaces path key
    , cmd
    )



-- Update


type Msg
    = DotSpace Dots.Msg
    | MainDotSpace Dots.Msg
    | ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest


update : Msg -> Model -> ( Model, Cmd Msg )
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

        MainDotSpace dotMsg ->
            let
                oldSpaces =
                    model.spaces

                ( mainDots, cmd ) =
                    Dots.update dotMsg oldSpaces.mainDots
            in
            ( { model | spaces = { oldSpaces | mainDots = mainDots } }, cmd )

        ChangedUrl url ->
            let
                ( spaces, cmd ) =
                    initSpaces (getConfig model.spaces)
            in
            ( { model | path = url.path, spaces = spaces }, cmd )

        ClickedLink request ->
            case request of
                Browser.Internal url ->
                    ( model, Navigation.pushUrl model.key url.path )

                _ ->
                    ( model, Cmd.none )



-- Router


type alias Title =
    Maybe String


route_ : String -> Page msg
route_ path =
    case path of
        "/about" ->
            about

        "/works" ->
            works

        "/" ->
            home

        _ ->
            notFound


route : Model -> ( Maybe String, Html msg )
route model =
    route_ model.path model



-- Pages


type alias MarkdownParser msg =
    String -> Html msg


type alias Page msg =
    Model -> ( Maybe String, Html msg )


home : Page msg
home { spaces } =
    ( Nothing, div [ class "tc" ] [ Dots.draw spaces.mainDots [] ] )


notFound : Page msg
notFound _ =
    ( Nothing, Page.NotFound.content )


about : Page msg
about _ =
    ( Just "About", Page.About.content )


works : Page msg
works _ =
    ( Just "Works", Page.Works.content )



-- View


view : Model -> Html Msg -> Html Msg
view { spaces } page =
    div []
        [ Header.view
        , div [ class "absolute left-0 top-0 ml3 mt3" ]
            [ div [ class "relative" ]
                [ Dots.draw spaces.dots [ class "absolute" ] ]
            ]
        , div
            [ class "tl pb4 pl3 pr3 mw7 center" ]
            [ page
            ]
        ]


wrappedView : Model -> Browser.Document Msg
wrappedView model =
    let
        ( routerTitle, page ) =
            route model

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
        , spaces.mainDots |> Dots.subscriptions |> Sub.map MainDotSpace
        ]
