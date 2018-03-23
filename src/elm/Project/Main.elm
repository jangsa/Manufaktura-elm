module Project.Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import UrlParser exposing (..)
import RemoteData exposing (WebData, RemoteData(..))
import View.Structures exposing (simpleTable)
import Project.Model exposing (..)
import Project.Messages exposing (..)
import Project.Network exposing (..)


matchList : List (Parser (Page -> a) a)
matchList =
    [ UrlParser.map Home <| (UrlParser.s "projects")
    , UrlParser.map Home <| (UrlParser.s "projects" </> top)
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
                            { m | projects = ps }

                        _ ->
                            m
            in
                ( newModel, Cmd.none )

        WillFilterMessage keywords ->
            ( model, Cmd.none )

        WillCreateMessage ->
            ( model, Cmd.none )

        DidCreateMessage _ ->
            ( model, Cmd.none )

        WillDeleteMessage id ->
            ( model, Cmd.none )

        DidDeleteMessage _ ->
            ( model, Cmd.none )


title : Html message
title =
    p
        [ class "h2" ]
        [ text "Projects Overview" ]


filter : Html Message
filter =
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
                , onClick WillCreateMessage
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

            Success ps ->
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
                    ps

            Failure e ->
                [ [ ( []
                    , [ text "Error! Please report followings to the administrator:"
                      , text <| toString e
                      ]
                    )
                  ]
                ]
        )


view : Model -> Html Message
view model =
    article
        []
        [ title
        , filter
        , projectsTable model
        ]
