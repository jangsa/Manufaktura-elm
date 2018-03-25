module Project.Main exposing (..)

import Array exposing (..)
import Tuple exposing (..)
import Json.Decode as Decode
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import UrlParser exposing (..)
import RemoteData exposing (WebData, RemoteData(..))
import View.Structures exposing (simpleTable, displayIf)
import View.Forms as Forms
import Project.Model exposing (..)
import Project.Messages exposing (..)
import Project.Network exposing (..)


matchList : List (Parser (Page -> a) a)
matchList =
    [ UrlParser.map Home <| UrlParser.s "projects"
    , UrlParser.map Home <| UrlParser.s "projects" </> top
    ]


matchers : Parser (Page -> a) a
matchers =
    oneOf
        matchList


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        NoMessage ->
            ( model, Cmd.none )

        LocationChangeMessage location ->
            ( model, fetchProjects )

        DidFetchListMessage webdata ->
            let
                m =
                    { model | projectsAsync = webdata }

                newModel =
                    case webdata of
                        Success ps ->
                            { m | projects = ps, projectsFiltered = ps }

                        _ ->
                            m
            in
                ( newModel, Cmd.none )

        WillFilterMessage keywords ->
            filterProjects model keywords

        OpenCreateMessage ->
            ( { model | overlayState = True }, Cmd.none )

        CloseCreateMessage ->
            ( { model | overlayState = False }, Cmd.none )

        WillCreateMessage ->
            ( model, Cmd.none )

        DidCreateMessage _ ->
            ( model, Cmd.none )

        WillDeleteMessage id ->
            ( model, Cmd.none )

        DidDeleteMessage _ ->
            ( model, Cmd.none )

        DidUpdateColumnMessage column value ->
            let
                oldFormState =
                    model.creationFormState

                newFormState =
                    case column of
                        NewProjectName ->
                            { oldFormState | name = value }

                        NewProjectDescription ->
                            { oldFormState | description = value }

                        NewProjectBatchName uid ->
                            let
                                batch =
                                    Array.map
                                        (\( uid_, ( name_, description_ ) ) ->
                                            if (toString uid_) == uid then
                                                ( uid_, ( value, description_ ) )
                                            else
                                                ( uid_, ( name_, description_ ) )
                                        )
                                        oldFormState.batch
                            in
                                Debug.log
                                    "inside batch name"
                                    { oldFormState | batch = batch }

                        NewProjectBatchDescription uid ->
                            let
                                batch =
                                    Array.map
                                        (\( uid_, ( name_, description_ ) ) ->
                                            if (toString uid_) == uid then
                                                ( uid_, ( name_, value ) )
                                            else
                                                ( uid_, ( name_, description_ ) )
                                        )
                                        oldFormState.batch
                            in
                                Debug.log
                                    "inside batch desc"
                                    { oldFormState | batch = batch }

                        AddBatchRow ->
                            let
                                oldFormState =
                                    model.creationFormState

                                newBatch =
                                    Array.push
                                        ( (Array.length oldFormState.batch) + 1, ( "", "" ) )
                                        oldFormState.batch
                            in
                                { oldFormState | batch = newBatch }

                        RemoveBatchRow uid ->
                            model.creationFormState
            in
                ( { model | creationFormState = newFormState }, Cmd.none )


title : Html message
title =
    p
        [ class "h2" ]
        [ text "Projects Overview" ]


projectConsole : Html Message
projectConsole =
    div
        [ class "clearfix" ]
        [ div
            [ class "col col-10" ]
            [ input
                [ type_ "text"
                , class "input"
                , placeholder "filter projects"
                , onInput WillFilterMessage
                ]
                []
            ]
        , div
            [ class "col-right col-2 pl3" ]
            [ a
                [ class "btn btn-outline"
                , onClick OpenCreateMessage
                ]
                [ text "new project" ]
            ]
        ]


projectsTable : Model -> Html message
projectsTable model =
    simpleTable
        (List.map
            (\t ->
                ( [ class "italic" ], [ text t ] )
            )
            [ "id", "name", "created" ]
        )
        (case model.projectsAsync of
            NotAsked ->
                [ [ ( [], [ text "Reopen this page from a page link." ] ) ] ]

            Loading ->
                [ [ ( [], [ text "Now Loading..." ] ) ] ]

            Success _ ->
                List.map
                    (\detail ->
                        List.map
                            (\v ->
                                ( []
                                , [ a
                                        [ href ("./#/projects/" ++ detail.id) ]
                                        [ text v ]
                                  ]
                                )
                            )
                            [ detail.id, detail.name, detail.created ]
                    )
                    model.projectsFiltered

            Failure e ->
                [ [ ( []
                    , [ text "Error! Please report followings to the administrator:"
                      , text <| toString e
                      ]
                    )
                  ]
                ]
        )


overlay : Model -> List (Html Message) -> Html Message
overlay model children =
    displayIf
        model.overlayState
        (Forms.overlay
            OpenCreateMessage
            CloseCreateMessage
            children
        )


creationForm : Model -> List (Html Message)
creationForm model =
    [ p
        [ class "h3"
        ]
        [ text "Create New Project" ]
    , Html.form
        []
        [ label
            []
            [ text "project name" ]
        , input
            [ on "change" <| Decode.map (DidUpdateColumnMessage NewProjectName) targetValue
            , type_ "text"
            , class "input"
            , placeholder ""
            , value model.creationFormState.name
            ]
            []
        , label
            []
            [ text "batch flow (CSV)" ]
        , div
            []
            (List.map
                (\i ->
                    div
                        []
                        [ input
                            [ type_ "text"
                            , on "change" <|
                                Decode.map
                                    (DidUpdateColumnMessage
                                        (NewProjectBatchName
                                            (case Array.get i model.creationFormState.batch of
                                                Just job ->
                                                    toString <| first job

                                                Nothing ->
                                                    "1"
                                            )
                                        )
                                    )
                                    targetValue
                            , id ("batchname-" ++ (toString i))
                            , class "input"
                            , placeholder ("batch name - " ++ (toString i))
                            ]
                            []
                        , input
                            [ type_ "text"
                            , on "change" <|
                                Decode.map
                                    --                                    (DidUpdateColumnMessage
                                    --                                        (NewProjectBatchDescription
                                    --                                           (case Array.get i model.creationFormState.batch of
                                    --                                              Just job ->
                                    --                                                 toString <| first job
                                    --                                            Nothing ->
                                    --                                               "1"
                                    --                                      )
                                    --                                 )
                                    --                            )
                                    WillFilterMessage
                                    targetValue
                            , id ("batchdescription-" ++ (toString i))
                            , class "input"
                            , placeholder ("batch description - " ++ (toString i))
                            ]
                            []
                        ]
                )
                (List.range
                    1
                    (Array.length model.creationFormState.batch)
                )
            )
        , a
            [ class "btn btn-outline my2"
            , onClick WillCreateMessage
            ]
            [ text "create" ]
        ]
    ]


view : Model -> Html Message
view model =
    article
        []
        [ title
        , projectConsole
        , projectsTable model
        , overlay model <| creationForm model
        ]
