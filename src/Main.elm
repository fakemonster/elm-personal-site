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
    , mainDots : Dots.Space
    }


type alias Model =
    { spaces : Spaces
    , path : String
    , key : Navigation.Key
    }


initDotSpace : String -> Decode.Value -> ( Dots.Space, Cmd Dots.Msg )
initDotSpace field json =
    json
        |> Decode.decodeValue (Decode.at [ field ] Dots.decoder)
        |> Result.withDefault Dots.defaultConfig
        |> Dots.init


init : Decode.Value -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init json { path } key =
    let
        ( dotSpace, dotCmd ) =
            initDotSpace "dotConfig" json

        ( mainDotSpace, mainDotCmd ) =
            initDotSpace "mainDotConfig" json
    in
    ( Model { dots = dotSpace, mainDots = mainDotSpace } path key
    , Cmd.batch
        [ dotCmd |> Cmd.map DotSpace
        , mainDotCmd |> Cmd.map MainDotSpace
        ]
    )



-- Update


type Msg
    = DotSpace Dots.Msg
    | MainDotSpace Dots.Msg
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

        MainDotSpace dotMsg ->
            let
                oldSpaces =
                    model.spaces

                ( mainDots, cmd ) =
                    Dots.update dotMsg oldSpaces.mainDots
            in
            ( { model | spaces = { oldSpaces | mainDots = mainDots } }, cmd )

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


route_ : String -> Page msg
route_ path =
    case path of
        "/about" ->
            about

        "/" ->
            home

        _ ->
            notFound


route : Model -> ( Maybe String, Html msg )
route model =
    route_ model.path format model



-- Pages


type alias MarkdownParser msg =
    String -> Html msg


type alias Page msg =
    MarkdownParser msg -> Model -> ( Maybe String, Html msg )


home : Page msg
home _ { spaces } =
    ( Nothing, Dots.draw spaces.mainDots [ class "center" ] )


notFound : Page msg
notFound f _ =
    ( Nothing, f Page.NotFound.content )


about : Page msg
about f _ =
    ( Just "About", f Page.About.content )



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
            []
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
