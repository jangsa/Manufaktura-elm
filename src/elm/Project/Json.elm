module Project.Json exposing (..)

import Json.Decode as Decode
import Project.Detail.Model exposing (..)
import Project.Detail.Json exposing (..)


projectsDecoder : Decode.Decoder (List ProjectDetail)
projectsDecoder =
    Decode.list projectDecoder
