module Project.Detail.Network exposing (..)

import RemoteData
import Http
import Project.Detail.Model exposing (..)
import Project.Detail.Messages exposing (..)
import Project.Detail.Json exposing (..)


projectsAPI : String
projectsAPI =
    "http://localhost:4000/projects"


projectAPI : String -> String
projectAPI id =
    projectsAPI ++ "/" ++ id


fetchProject : String -> Cmd Message
fetchProject id =
    Http.get (projectAPI id) projectDecoder
        |> RemoteData.sendRequest
        |> Cmd.map DidFetchDetailMessage


uploadFile : ProjectDetail -> String -> Cmd Message
uploadFile detail base64body =
    Http.post (projectAPI detail.id) (projectEncoder detail |> Http.jsonBody) projectDecoder
        |> RemoteData.sendRequest
        |> Cmd.map DidFileUploadMessage
