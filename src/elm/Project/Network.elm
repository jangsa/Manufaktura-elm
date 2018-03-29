module Project.Network exposing (..)

import Http
import RemoteData exposing (..)
import Project.Model exposing (..)
import Project.Message exposing (..)
import Project.Json exposing (projectsDecoder)
import Project.Detail.Model exposing (ProjectDetail, Job)
import Project.Detail.Json exposing (projectDecoder, projectEncoderForRegister)
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
                        |> List.foldr
                            (\l ->
                                \r ->
                                    if l || r then
                                        True
                                    else
                                        l || r
                            )
                            False
                )
                keys
                |> List.foldl (&&) True

        filterer detail =
            n2nMatch
                (String.toLower >> String.split " " <| keywords)
                (List.map
                    String.toLower
                    [ detail.id, detail.name, detail.created ]
                )

        filtered =
            List.filter
                filterer
                projects
    in
        filtered


createProject : CreationState -> Cmd Msg
createProject creationState =
    let
        batch =
            List.map
                (\( i, ( n, d ) ) ->
                    Job i n d "" ""
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
            (Http.jsonBody <| projectEncoderForRegister projectDetail)
            projectDecoder
        )
            |> RemoteData.sendRequest
            |> Cmd.map CreateAfterMsg



{-
   Http.post
       "http://localhost:4000/projects/"
       Http.emptyBody
       (Decode.succeed "foo")
       |> sendRequest
       |> Cmd.map CreateAfterMsg
-}
