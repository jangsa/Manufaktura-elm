module Project.Detail.Message exposing (..)

import Project.Detail.Ports exposing (JobFilesUploadPacket)
import Navigation exposing (Location)
import RemoteData exposing (..)
import Project.Detail.Model exposing (..)


type Msg
    = NoMsg
    | ChangeLocationMsg Location
    | FetchMsg String
    | FetchAfterMsg (WebData ProjectDetail)
    | DownloadInputFileMsg Int
    | DragoverMsg Int
    | DragleaveMsg Int
    | DropMsg Int
    | FileLoadedPortMsg JobFilesUploadPacket
    | RemoteDoneMsg Int
