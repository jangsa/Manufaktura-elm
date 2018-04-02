module Main exposing (main)

import Maybe exposing (withDefault)
import Navigation exposing (program, Location)
import UrlParser exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Common.View.Navigator exposing (..)
import Message exposing (..)
import Model exposing (..)
import Project.Update as ProjectUpdate
import Project.Model as ProjectModel
import Project.Message as ProjectMessage
import Project.View as ProjectView
import Project.Detail.View as DetailView
import Project.Detail.Model as DetailModel
import Project.Detail.Message as DetailMessage
import Project.Detail.Update as DetailUpdate


homePage : Html message
homePage =
    article
        []
        [ p
            [ class "h2" ]
            [ text "Welcome to Manufaktura!" ]
        , p
            []
            [ text "Manufaktura is a web-based helper that expedites your boring works." ]
        ]


defaultPage : Html message
defaultPage =
    article
        []
        [ p
            [ class "h2 red" ]
            [ text "404 NOT FOUND" ]
        ]


view : Model -> Html Msg
view model =
    let
        mainContents =
            case model.page of
                HomePage ->
                    [ homePage ]

                ProjectsPage page ->
                    [ Html.map ProjectsMsg <| ProjectView.view model.projectsState ]

                ProjectDetailPage page ->
                    [ Html.map ProjectDetailMsg <| DetailView.view model.projectDetailState ]

                DefaultPage ->
                    [ defaultPage ]

        sideContents =
            [ text "side contents" ]
    in
        frame
            initNavigatorState
            (navigator
                "Manufaktura"
                (simpleMenuItems [ "home", "projects", "gitbucket" ])
            )
            mainContents
            sideContents


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map
            ProjectDetailMsg
            (DetailUpdate.subscriptions model.projectDetailState)
        ]


matchList : List (Parser (Page -> a) a)
matchList =
    [ UrlParser.map HomePage top
    , UrlParser.map HomePage <| UrlParser.s "home"

    --  , UrlParser.map GitBucketPage <| s "gitbucket"
    ]


matchers : Parser (Page -> a) a
matchers =
    oneOf
        (matchList
            ++ (List.map (\m -> UrlParser.map ProjectsPage m) ProjectModel.matchList)
            ++ (List.map (\m -> UrlParser.map ProjectDetailPage m) DetailModel.matchList)
        )


parseLocation : Location -> Page
parseLocation location =
    Maybe.withDefault
        DefaultPage
        (UrlParser.parseHash matchers location)


changeLocation : Msg -> Model -> Location -> ( Model, Cmd Msg )
changeLocation msg model location =
    let
        newPage =
            parseLocation location
    in
        case newPage of
            ProjectsPage _ ->
                let
                    ( newProjectsState, newProjectsCommand ) =
                        ProjectUpdate.update
                            (ProjectMessage.ChangeLocationMsg location)
                            model.projectsState
                in
                    ( { model
                        | page = newPage
                        , projectsState = newProjectsState
                      }
                    , Cmd.map ProjectsMsg newProjectsCommand
                    )

            ProjectDetailPage _ ->
                let
                    ( newDetailState, newDetailCommand ) =
                        DetailUpdate.update
                            (DetailMessage.ChangeLocationMsg location)
                            model.projectDetailState
                in
                    ( { model
                        | page = newPage
                        , projectDetailState = newDetailState
                      }
                    , Cmd.map ProjectDetailMsg newDetailCommand
                    )

            _ ->
                ( { model | page = newPage }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoMsg ->
            ( model, Cmd.none )

        ChangeLocationMsg location ->
            changeLocation msg model location

        ProjectsMsg projectMsg ->
            let
                ( newProjectsModel, newProjectsCommand ) =
                    ProjectUpdate.update
                        projectMsg
                        model.projectsState
            in
                ( { model | projectsState = newProjectsModel }
                , Cmd.map ProjectsMsg newProjectsCommand
                )

        ProjectDetailMsg projectDetailMsg ->
            let
                ( newDetailModel, newDetailCommand ) =
                    DetailUpdate.update
                        projectDetailMsg
                        model.projectDetailState
            in
                ( { model | projectDetailState = newDetailModel }
                , Cmd.map ProjectDetailMsg newDetailCommand
                )


init : Location -> ( Model, Cmd Msg )
init location =
    ( parseLocation location |> initModel, Cmd.none )


main : Program Never Model Msg
main =
    Navigation.program
        ChangeLocationMsg
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
