module Project.Detail.Network exposing (..)

import Http
import RemoteData exposing (..)
import Project.Detail.Model exposing (..)
import Project.Detail.Message exposing (..)
import Project.Detail.Json exposing (projectDecoder, projectEncoderUpstream)


projectsAPI : String
projectsAPI =
    "http://localhost:4000/projects/"


projectAPI : String -> String
projectAPI id =
    projectsAPI ++ id


fetchProject : String -> Cmd Msg
fetchProject id =
    Http.get
        (projectAPI id)
        projectDecoder
        |> RemoteData.sendRequest
        |> Cmd.map FetchAfterMsg


uploadFile : List Base64File -> Cmd Msg
uploadFile files =
    let
        a =
            Debug.log
                ("upload")
                files
    in
        Cmd.none
