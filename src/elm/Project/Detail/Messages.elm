module Project.Detail.Messages exposing (Message(..))

import RemoteData exposing (..)
import Navigation exposing (Location)
import Utility.UploadPorts as UploadPorts
import Project.Detail.Model exposing (..)


type Message
    = NoMessage
    | LocationChangeMessage Location
    | DidFetchDetailMessage (WebData ProjectDetail)
    | DidFileUploadMessage (WebData ProjectDetail)
    | DidReceiveBase64BodyMessage UploadPorts.BinaryPortData
