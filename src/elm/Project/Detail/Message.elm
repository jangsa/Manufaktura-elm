module Project.Detail.Message exposing (..)

import Navigation exposing (Location)
import RemoteData exposing (..)
import Project.Detail.Model exposing (..)


type Msg
    = NoMsg
    | ChangeLocationMsg Location
    | FetchMsg String
    | FetchAfterMsg (WebData ProjectDetail)
