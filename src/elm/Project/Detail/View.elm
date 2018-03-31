module Project.Detail.View exposing (view)

import Dict exposing (..)
import RemoteData exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Common.View.Form exposing (simpleFormFrame, dropfield)
import Project.Detail.Model exposing (..)
import Project.Detail.Message exposing (..)


view : Model -> Html Msg
view model =
    case model.detailAsync of
        NotAsked ->
            text "Reopen the page from link to fetch the project profile"

        Loading ->
            text "Loading the project profile..."

        Failure err ->
            p
                []
                [ text "Error has occurred. Please report the followings to the admin:"
                , text (toString err)
                ]

        Success _ ->
            let
                detail =
                    model.detail

                title =
                    [ p
                        [ class "h2" ]
                        [ text "Notebook of "
                        , span
                            [ class "bold" ]
                            [ text ("\"" ++ detail.name ++ "\"")
                            ]
                        , text " Project"
                        ]
                    ]

                header h =
                    div
                        []
                        [ label [ class "italic" ] [ text h ] ]

                form b =
                    div
                        [ class "border" ]
                        [ text b
                        ]

                uneditable children =
                    section
                        [ class "py2" ]
                        children

                editable top bottom defaultValue =
                    section
                        [ class "py2" ]
                        (top
                            ++ [ input
                                    [ type_ "text"
                                    , class "input"
                                    , value defaultValue
                                    ]
                                    []
                               ]
                            ++ bottom
                        )

                idArea =
                    uneditable
                        [ header "PROJECT ID"
                        , form detail.id
                        ]

                nameArea =
                    editable
                        [ header "PROJECT NAME"
                        ]
                        []
                        detail.name

                createdArea =
                    uneditable
                        [ header "PROJECT CREATED (SINCE)"
                        , form detail.created
                        ]

                dndAreas =
                    div
                        []
                        (List.map
                            (\b ->
                                section
                                    [ class "my2" ]
                                    [ label
                                        []
                                        [ text
                                            ("[job#"
                                                ++ (toString b.index)
                                                ++ "] "
                                                ++ b.name
                                                ++ " - "
                                                ++ b.description
                                            )
                                        ]
                                    , dropfield
                                        -- todo: suppress messages while awaiting remote done
                                        (DragoverMsg b.index)
                                        (DragleaveMsg b.index)
                                        (DropMsg b.index)
                                        [ onClick (DownloadInputFileMsg b.index)
                                        , id ("dropfield-" ++ (toString b.index))
                                        , (case Dict.get b.index model.jobStateDict of
                                            Just state ->
                                                if state.dragover then
                                                    class "bg-silver"
                                                else
                                                    class ""

                                            Nothing ->
                                                class ""
                                          )
                                        ]
                                        []
                                    , div
                                        [ class "clearfix" ]
                                        [ div
                                            [ class "col sm-col-4" ]
                                            [ a
                                                (if b.lastOutputUrl /= "" then
                                                    [ class "btn btn-outline block img center"
                                                    , href b.lastOutputUrl
                                                    ]
                                                 else
                                                    [ class "btn btn-outline block img center gray"
                                                    , style [ ( "pointer-events", "none" ) ]
                                                    ]
                                                )
                                                [ text "download last" ]
                                            ]
                                        , div
                                            [ class "col sm-col-4" ]
                                            [ a
                                                (if b.outputUrls /= [] then
                                                    [ class "btn btn-outline block img center"

                                                    -- todo
                                                    , href ""
                                                    ]
                                                 else
                                                    [ class "btn btn-outline block img center gray"
                                                    , style [ ( "pointer-events", "none" ) ]
                                                    ]
                                                )
                                                [ text "download specific" ]
                                            ]
                                        , div
                                            [ class "col sm-col-4" ]
                                            [ a
                                                (if b.outputUrls /= [] then
                                                    [ class "btn btn-outline block img center"

                                                    -- todo
                                                    , href ""
                                                    ]
                                                 else
                                                    [ class "btn btn-outline block img center gray"
                                                    , style [ ( "pointer-events", "none" ) ]
                                                    ]
                                                )
                                                [ text "download all" ]
                                            ]
                                        ]
                                    ]
                            )
                            detail.batch
                        )

                areas =
                    [ idArea
                    , nameArea
                    , createdArea
                    , dndAreas
                    ]

                notebook =
                    simpleFormFrame
                        title
                        areas
            in
                article
                    []
                    notebook
