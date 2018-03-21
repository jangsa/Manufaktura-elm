module Main exposing (main)

import Maybe exposing (withDefault)
import Navigation exposing (program, Location)
import UrlParser
import Html
import Html.Attributes
import View.Main
import View.Navigator


type Message
    = NoMessage
    | OnLocationChange Location
    | ProjectMessage


type Page
    = NoSuchPage
    | HomePage
    | ProjectPage


type alias Model =
    { page : Page

    --, projectState : Project.Model.Model
    }


matchers : UrlParser.Parser (Page -> a) a
matchers =
    UrlParser.oneOf
        [ UrlParser.map HomePage UrlParser.top
        , UrlParser.map HomePage <| (UrlParser.s "home")
        ]


parseLocation : Location -> Page
parseLocation location =
    withDefault
        NoSuchPage
        (UrlParser.parseHash matchers location)


initModel : Page -> Model
initModel page =
    { page = page }


init : Location -> ( Model, Cmd Message )
init location =
    ( parseLocation location |> initModel, Cmd.none )


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        NoMessage ->
            ( model, Cmd.none )

        OnLocationChange location ->
            let
                newPage =
                    parseLocation location
            in
                ( { model | page = newPage }, Cmd.none )

        ProjectMessage ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.none


view : Model -> Html.Html message
view model =
    View.Main.frame
        (View.Navigator.simpleMenuItems
            [ "home", "project", "gitbucket" ]
            |> View.Navigator.navigator
                "Manufaktura"
        )
        [ Html.text "main contents" ]
        [ Html.text "side contents" ]


main : Program Never Model Message
main =
    program
        OnLocationChange
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
