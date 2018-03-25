module Project.Messages exposing (Message(..), FormColumn(..))

import RemoteData exposing (..)
import Navigation exposing (Location)
import Project.Detail.Model exposing (..)


type FormColumn
    = NewProjectName
    | NewProjectDescription
    | NewProjectBatchName String
    | NewProjectBatchDescription String
    | AddBatchRow
    | RemoveBatchRow String


type Message
    = NoMessage
    | LocationChangeMessage Location
    | DidFetchListMessage (WebData (List ProjectDetail))
    | WillFilterMessage String
    | OpenCreateMessage
    | CloseCreateMessage
    | WillCreateMessage
    | DidCreateMessage (WebData ProjectDetail)
    | WillDeleteMessage String
    | DidDeleteMessage (WebData ProjectDetail)
    | DidUpdateColumnMessage FormColumn String
