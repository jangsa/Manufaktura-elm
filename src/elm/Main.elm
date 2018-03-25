module Main exposing (main)

import Maybe exposing (withDefault)
import Navigation exposing (program, Location)
import UrlParser exposing (..)
import Html
import Html.Attributes
import View.Structures
import View.Navigator
import Project.Main
import Project.Model
import Project.Messages
import Project.Detail.Main
import Project.Detail.Model
import Project.Detail.Messages


type Message
    = NoMessage
    | LocationChangeMessage Location
    | ProjectMessage Project.Messages.Message
    | ProjectDetailMessage Project.Detail.Messages.Message


type Page
    = NoSuchPage
    | HomePage
    | ProjectPage Project.Model.Page
    | ProjectDetailPage Project.Detail.Model.Page
    | GitBucketPage


type alias Model =
    { page : Page
    , navigatorState : View.Structures.NavigatorState
    , projectModel : Project.Model.Model
    , projectDetailModel : Project.Detail.Model.Model
    }


initModel : Page -> Model
initModel page =
    { page = page
    , navigatorState = View.Structures.initNavigatorState
    , projectModel = Project.Model.initModel
    , projectDetailModel = Project.Detail.Model.initModel
    }


matchList : List (Parser (Page -> a) a)
matchList =
    [ UrlParser.map HomePage top
    , UrlParser.map HomePage <| s "home"
    , UrlParser.map GitBucketPage <| s "gitbucket"
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


updateSub : Model -> Page -> Location -> ( Model, Cmd Message )
updateSub model newPage location =
    case newPage of
        ProjectPage _ ->
            let
                ( newProjectModel, newProjectMessage ) =
                    Project.Main.update
                        (Project.Messages.LocationChangeMessage location)
                        model.projectModel
            in
                ( { model
                    | projectModel = newProjectModel
                  }
                , Cmd.map ProjectMessage newProjectMessage
                )

        ProjectDetailPage _ ->
            let
                ( newProjectDetailModel, newProjectDetailMessage ) =
                    Project.Detail.Main.update
                        (Project.Detail.Messages.LocationChangeMessage location)
                        model.projectDetailModel
            in
                ( { model
                    | projectDetailModel = newProjectDetailModel
                  }
                , Cmd.map ProjectDetailMessage newProjectDetailMessage
                )

        _ ->
            ( model, Cmd.none )


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        NoMessage ->
            ( model, Cmd.none )

        LocationChangeMessage location ->
            let
                newPage =
                    parseLocation location

                modelWithNewPage =
                    { model | page = newPage }
            in
                updateSub modelWithNewPage newPage location

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


view : Model -> Html.Html Message
view model =
    let
        mainContents =
            case model.page of
                NoSuchPage ->
                    [ View.Structures.default ]

                HomePage ->
                    [ home ]

                ProjectPage _ ->
                    [ Html.map
                        ProjectMessage
                        (Project.Main.view model.projectModel)
                    ]

                ProjectDetailPage _ ->
                    [ Html.map
                        ProjectDetailMessage
                        (Project.Detail.Main.view model.projectDetailModel)
                    ]

                GitBucketPage ->
                    [ Html.text "GitBucket Page" ]

        sideContents =
            [ Html.text "side contents" ]
    in
        View.Structures.frame
            model.navigatorState
            (View.Navigator.simpleMenuItems
                [ "home", "projects", "gitbucket" ]
                |> View.Navigator.navigator
                    "Manufaktura"
            )
            mainContents
            sideContents


init : Location -> ( Model, Cmd Message )
init location =
    ( parseLocation location |> initModel, Cmd.none )


main : Program Never Model Message
main =
    program
        LocationChangeMessage
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
