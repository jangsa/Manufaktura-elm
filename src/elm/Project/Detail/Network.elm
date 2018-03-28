module Project.Detail.Network exposing (..)

import Http
import RemoteData exposing (..)
import Project.Detail.Model exposing (ProjectDetail)
import Project.Detail.Message exposing (..)
import Project.Detail.Json exposing (projectDecoder, projectEncoderForRegister)


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
