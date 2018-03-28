module Project.View exposing (view)

import RemoteData exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Common.View.Presentation exposing (simpleTable)
import Common.View.Form exposing (overlay, console, sectionHeader, simpleFormFrame, simpleTextfield, extensibleDuo, simpleButton)
import Common.View.Util exposing (displayIf)
import Project.Model exposing (..)
import Project.Message exposing (..)


overlay : Model -> List (Html Msg) -> Html Msg
overlay model children =
    displayIf
        model.overlayState
        (Common.View.Form.overlay
            OpenCreationMsg
            CloseCreationMsg
            children
        )


projectsTable : Model -> Html msg
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
                let
                    showFiltered detail =
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
                in
                    List.map
                        showFiltered
                        model.projectsFiltered

            Failure e ->
                [ [ ( []
                    , [ p [] [ text "Error! Please report followings to the administrator:" ]
                      , p [] [ text <| toString e ]
                      ]
                    )
                  ]
                ]
        )


title : Html msg
title =
    p
        [ class "h2" ]
        [ text "Projects Overview" ]


view : Model -> Html Msg
view model =
    let
        projectConsole =
            console FilterMsg OpenCreationMsg "filter projects" "create"

        nameSectionHeader =
            div [] [ sectionHeader "name" ]

        nameField =
            simpleTextfield ChangeNameMsg model.creationState.name ""

        descriptionSectionHeader =
            div [] [ sectionHeader "description" ]

        descriptionField =
            simpleTextfield ChangeDescriptionMsg model.creationState.description ""

        addJobButton =
            simpleButton AddJobMsg "add job"

        batchSectionHeader =
            div
                []
                [ sectionHeader "batch sequence"
                , span
                    [ class "px2" ]
                    [ addJobButton ]
                ]

        createButton =
            simpleButton CreateMsg "create"

        creationOverlay =
            overlay
                model
                (simpleFormFrame
                    "Launching New Project"
                    [ nameSectionHeader
                    , nameField
                    , descriptionSectionHeader
                    , descriptionField
                    , batchSectionHeader
                    , extensibleDuo
                        ChangeJobNameMsg
                        [ class "input"
                        , placeholder "name"
                        ]
                        ChangeJobDescriptionMsg
                        [ class "input"
                        , placeholder "description"
                        ]
                        model.creationState.batch
                        RemoveJobMsg
                    , createButton
                    ]
                )
    in
        article
            []
            [ title
            , projectConsole
            , projectsTable model
            , creationOverlay
            ]
