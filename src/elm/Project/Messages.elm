module Project.Messages exposing (Message(..))

import RemoteData exposing (..)
import Navigation exposing (Location)
import Project.Detail.Model exposing (..)


type Message
    = NoMessage
    | LocationChangeMessage Location
    | DidFetchListMessage (WebData (List ProjectDetail))
    | WillFilterMessage String
    | WillCreateMessage
    | DidCreateMessage (WebData ProjectDetail)
    | WillDeleteMessage String
    | DidDeleteMessage (WebData ProjectDetail)
