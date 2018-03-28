module Project.Message exposing (..)

import Navigation exposing (Location)
import RemoteData exposing (WebData)
import Project.Detail.Model exposing (ProjectDetail)


type Msg
    = NoMsg
    | ChangeLocationMsg Location
    | FetchMsg
    | FetchAfterMsg (WebData (List ProjectDetail))
    | FilterMsg String
    | OpenCreationMsg
    | CloseCreationMsg
    | ChangeNameMsg String
    | ChangeDescriptionMsg String
    | ChangeJobNameMsg Int String
    | ChangeJobDescriptionMsg Int String
    | AddJobMsg
    | RemoveJobMsg Int
    | CreateMsg
    | CreateAfterMsg (WebData ProjectDetail)
