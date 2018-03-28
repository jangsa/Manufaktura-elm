module Message exposing (..)

import Navigation exposing (Location)
import Project.Message as ProjectMsg
import Project.Detail.Message as DetailMsg


type Msg
    = NoMsg
    | ChangeLocationMsg Location
    | ProjectsMsg ProjectMsg.Msg
    | ProjectDetailMsg DetailMsg.Msg
