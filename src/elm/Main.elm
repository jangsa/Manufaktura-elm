module Main exposing (main)

import Maybe exposing (withDefault)
import Navigation exposing (program, Location)
import UrlParser exposing (..)
import Html
import Html.Attributes
import View.Structures
import View.Navigator
import Project.Main
import Project.Detail.Main


type Message
    = NoMessage
    | LocationChangeMessage Location
    | ProjectMessage Project.Main.Message
    | ProjectDetailMessage Project.Detail.Main.Message


type Page
    = NoSuchPage
    | HomePage
    | ProjectPage Project.Main.Page
    | ProjectDetailPage Project.Detail.Main.Page
    | GitBucketPage


matchList : List (Parser (Page -> a) a)
matchList =
    [ UrlParser.map HomePage top
    , UrlParser.map HomePage <| (s "home")
    , UrlParser.map GitBucketPage <| (s "gitbucket")
    ]


matchers : Parser (Page -> a) a
matchers =
    oneOf
        (matchList
            ++ (List.map (\m -> UrlParser.map ProjectPage m) Project.Main.matchList)
            ++ (List.map (\m -> UrlParser.map ProjectDetailPage m) Project.Detail.Main.matchList)
        )


parseLocation : Location -> Page
parseLocation location =
    withDefault
        NoSuchPage
        (UrlParser.parseHash matchers location)


type alias Model =
    { page : Page
    , navigatorState : View.Structures.NavigatorState
    , projectModel : Project.Main.Model
    , projectDetailModel : Project.Detail.Main.Model
    }


initModel : Page -> Model
initModel page =
    { page = page
    , navigatorState = View.Structures.initNavigatorState
    , projectModel = Project.Main.initModel
    , projectDetailModel = Project.Detail.Main.initModel
    }


init : Location -> ( Model, Cmd Message )
init location =
    ( parseLocation location |> initModel, Cmd.none )


takeActiveCmd : List (Cmd message) -> Cmd message
takeActiveCmd cmds =
    case List.head <| List.filter (\c -> c /= Cmd.none) cmds of
        Just cmd ->
            cmd

        Nothing ->
            Cmd.none


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        NoMessage ->
            ( model, Cmd.none )

        LocationChangeMessage location ->
            let
                newPage =
                    parseLocation location

                ( newProjectModel, newProjectMessage ) =
                    Project.Main.update
                        (Project.Main.LocationChangeMessage location)
                        model.projectModel

                ( newProjectDetailModel, newProjectDetailMessage ) =
                    Project.Detail.Main.update
                        (Project.Detail.Main.LocationChangeMessage location)
                        model.projectDetailModel

                newCommand =
                    takeActiveCmd
                        [ Cmd.map ProjectMessage newProjectMessage
                        , Cmd.map ProjectDetailMessage newProjectDetailMessage
                        ]
            in
                ( { model
                    | page = newPage
                    , projectModel = newProjectModel
                    , projectDetailModel = newProjectDetailModel
                  }
                , newCommand
                )

        ProjectMessage projectMessage ->
            let
                ( newProjectModel, newProjectMessage ) =
                    Project.Main.update projectMessage model.projectModel
            in
                ( { model | projectModel = newProjectModel }, Cmd.none )

        ProjectDetailMessage projectDetailMessage ->
            let
                ( newProjectDetailModel, newProjectDetailMessage ) =
                    Project.Detail.Main.update projectDetailMessage model.projectDetailModel
            in
                ( { model | projectDetailModel = newProjectDetailModel }, Cmd.none )


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.none


home : Html.Html message
home =
    Html.article
        []
        [ Html.p
            [ Html.Attributes.class "h2" ]
            [ Html.text "Welcome to Manufaktura!" ]
        , Html.p
            []
            [ Html.text "Manufaktura is a web-based helper that expedites your boring works." ]
        ]


view : Model -> Html.Html message
view model =
    let
        mainContents =
            case model.page of
                NoSuchPage ->
                    [ View.Structures.default ]

                HomePage ->
                    [ home ]

                ProjectPage _ ->
                    [ Project.Main.view model.projectModel ]

                ProjectDetailPage _ ->
                    [ Project.Detail.Main.view model.projectDetailModel ]

                GitBucketPage ->
                    [ Html.text "GitBucket Page" ]

        sideContents =
            [ Html.text "side contents" ]
    in
        View.Structures.frame
            model.navigatorState
            (View.Navigator.simpleMenuItems
                [ "home", "project", "gitbucket" ]
                |> View.Navigator.navigator
                    "Manufaktura"
            )
            mainContents
            sideContents


main : Program Never Model Message
main =
    program
        LocationChangeMessage
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
