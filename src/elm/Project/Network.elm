module Project.Network exposing (..)

import List.Extra
import RemoteData
import Http
import Utility.Misc as Util
import Project.Json exposing (..)
import Project.Messages exposing (..)
import Project.Model as ProjectModel
import Project.Detail.Model exposing (..)
import Project.Detail.Network exposing (projectsAPI, projectAPI)
import Project.Detail.Json exposing (..)


fetchProjects : Cmd Message
fetchProjects =
    Http.get projectsAPI projectsDecoder
        |> RemoteData.sendRequest
        |> Cmd.map DidFetchListMessage


createProject : String -> List String -> Cmd Message
createProject projectName batchNames =
    let
        indexedBatch =
            List.Extra.zip (List.map toString (List.range 1 <| List.length batchNames)) batchNames

        batch =
            List.map (\( i, n ) -> Job i n "" "") indexedBatch

        info =
            ProjectDetail "" projectName "" batch
    in
        Http.post projectsAPI (projectEncoder info |> Http.jsonBody) projectDecoder
            |> RemoteData.sendRequest
            |> Cmd.map DidCreateMessage


filterProjects : ProjectModel.Model -> String -> ( ProjectModel.Model, Cmd Message )
filterProjects model keyword =
    let
        filtered =
            List.filter
                (\detail ->
                    Util.allInclusive
                        (String.toLower >> Util.whiteSplit <| keyword)
                        (List.map
                            String.toLower
                            [ detail.id, detail.name, detail.created ]
                        )
                )
                model.projects
    in
        ( { model | projectsFiltered = filtered }, Cmd.none )
