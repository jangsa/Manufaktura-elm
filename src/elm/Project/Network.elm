module Project.Network exposing (..)

import Http
import RemoteData exposing (..)
import Project.Model exposing (..)
import Project.Message exposing (..)
import Project.Json exposing (projectsDecoder)
import Project.Detail.Model exposing (ProjectDetail, Job)
import Project.Detail.Json exposing (projectDecoder, projectEncoderUpstream)
import Project.Detail.Network exposing (projectsAPI)


fetchProjects : Cmd Msg
fetchProjects =
    Http.get projectsAPI projectsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map FetchAfterMsg


filterProjects : List ProjectDetail -> String -> List ProjectDetail
filterProjects projects keywords =
    let
        n2nMatch keys vals =
            List.map
                (\k ->
                    List.map (\v -> String.contains k v) vals
                        |> List.foldr (||) False
                )
                keys
                |> List.foldr (&&) True

        filterPaper prj =
            n2nMatch
                (String.toLower >> String.split " " <| keywords)
                (List.map
                    String.toLower
                    [ prj.id, prj.name, prj.created ]
                )

        filtered =
            List.filter
                filterPaper
                projects
    in
        filtered


createProject : CreationState -> Cmd Msg
createProject creationState =
    let
        batch =
            List.map
                (\( i, ( n, d ) ) ->
                    Job i n d "" "" [] [] "" ""
                )
                creationState.batch

        projectDetail =
            ProjectDetail
                ""
                creationState.name
                creationState.description
                ""
                batch
    in
        (Http.post projectsAPI
            (Http.jsonBody <| projectEncoderUpstream projectDetail)
            projectDecoder
        )
            |> RemoteData.sendRequest
            |> Cmd.map CreateAfterMsg
